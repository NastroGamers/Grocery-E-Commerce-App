import '../repositories/coupon_repository.dart';
import '../../data/models/coupon_model.dart';

class ManageCouponsUseCase {
  final CouponRepository repository;

  ManageCouponsUseCase(this.repository);

  /// Get all available coupons for the user
  Future<CouponListResponse> getCoupons() async {
    final response = await repository.getCoupons();

    // Filter out expired and inactive coupons from available list
    final validAvailableCoupons = response.availableCoupons
        .where((coupon) => coupon.isValid)
        .toList();

    // Sort by discount value (highest first)
    validAvailableCoupons.sort((a, b) {
      if (a.discountType == DiscountType.percentage &&
          b.discountType == DiscountType.percentage) {
        return b.discountValue.compareTo(a.discountValue);
      } else if (a.discountType == DiscountType.fixed &&
          b.discountType == DiscountType.fixed) {
        return b.discountValue.compareTo(a.discountValue);
      }
      // Prioritize percentage discounts
      return a.discountType == DiscountType.percentage ? -1 : 1;
    });

    return CouponListResponse(
      availableCoupons: validAvailableCoupons,
      usedCoupons: response.usedCoupons,
    );
  }

  /// Validate a coupon code
  Future<ValidateCouponResponse> validateCoupon({
    required String code,
    required double orderSubtotal,
    required List<String> productIds,
    required List<String> categoryIds,
  }) async {
    // Validate input
    if (code.trim().isEmpty) {
      return ValidateCouponResponse(
        isValid: false,
        message: 'Please enter a coupon code',
      );
    }

    if (orderSubtotal <= 0) {
      return ValidateCouponResponse(
        isValid: false,
        message: 'Invalid order amount',
      );
    }

    final request = ValidateCouponRequest(
      code: code.trim().toUpperCase(),
      orderSubtotal: orderSubtotal,
      productIds: productIds,
      categoryIds: categoryIds,
    );

    return await repository.validateCoupon(request);
  }

  /// Apply a coupon to the cart
  Future<ApplyCouponResponse> applyCoupon({
    required String code,
    required double orderSubtotal,
    required List<String> productIds,
    required List<String> categoryIds,
  }) async {
    // Validate input
    if (code.trim().isEmpty) {
      throw Exception('Please enter a coupon code');
    }

    if (orderSubtotal <= 0) {
      throw Exception('Invalid order amount');
    }

    // First validate the coupon
    final validationResponse = await validateCoupon(
      code: code,
      orderSubtotal: orderSubtotal,
      productIds: productIds,
      categoryIds: categoryIds,
    );

    if (!validationResponse.isValid) {
      throw Exception(validationResponse.message);
    }

    // If valid, apply the coupon
    final request = ApplyCouponRequest(
      code: code.trim().toUpperCase(),
      orderSubtotal: orderSubtotal,
      productIds: productIds,
      categoryIds: categoryIds,
    );

    try {
      return await repository.applyCoupon(request);
    } catch (e) {
      // Provide user-friendly error messages
      if (e.toString().contains('minimum order')) {
        throw Exception(
          'Minimum order value not met. ${validationResponse.coupon?.minOrderValue != null ? "Add ₹${(validationResponse.coupon!.minOrderValue! - orderSubtotal).toStringAsFixed(0)} more to apply this coupon." : ""}'
        );
      } else if (e.toString().contains('not applicable')) {
        throw Exception(
          'This coupon cannot be applied to items in your cart'
        );
      }
      rethrow;
    }
  }

  /// Remove applied coupon from cart
  Future<void> removeCoupon(String code) async {
    if (code.trim().isEmpty) {
      throw Exception('Coupon code is required');
    }

    await repository.removeCoupon(code.trim().toUpperCase());
  }

  /// Get user's coupon usage history
  Future<List<UserCouponUsage>> getUserCouponUsage() async {
    return await repository.getUserCouponUsage();
  }

  /// Get coupon details by code
  Future<CouponModel> getCouponByCode(String code) async {
    if (code.trim().isEmpty) {
      throw Exception('Coupon code is required');
    }

    return await repository.getCouponByCode(code.trim().toUpperCase());
  }

  /// Calculate discount amount for a coupon
  double calculateDiscountAmount({
    required CouponModel coupon,
    required double orderSubtotal,
  }) {
    if (coupon.discountType == DiscountType.percentage) {
      final discountAmount = (orderSubtotal * coupon.discountValue) / 100;

      // Apply max discount cap if specified
      if (coupon.maxDiscount != null && discountAmount > coupon.maxDiscount!) {
        return coupon.maxDiscount!;
      }

      return discountAmount;
    } else {
      // Fixed discount
      // Don't give more discount than the order total
      return coupon.discountValue > orderSubtotal
          ? orderSubtotal
          : coupon.discountValue;
    }
  }

  /// Check if coupon is applicable to cart
  bool isCouponApplicableToCart({
    required CouponModel coupon,
    required double orderSubtotal,
    required List<String> productIds,
    required List<String> categoryIds,
  }) {
    // Check if coupon is valid
    if (!coupon.isValid) {
      return false;
    }

    // Check minimum order value
    if (coupon.minOrderValue != null &&
        orderSubtotal < coupon.minOrderValue!) {
      return false;
    }

    // Check applicability based on type
    switch (coupon.applicability) {
      case CouponApplicability.all:
        return true;

      case CouponApplicability.categories:
        if (coupon.applicableCategories == null ||
            coupon.applicableCategories!.isEmpty) {
          return false;
        }
        // Check if any cart category matches
        return categoryIds
            .any((id) => coupon.applicableCategories!.contains(id));

      case CouponApplicability.products:
        if (coupon.applicableProducts == null ||
            coupon.applicableProducts!.isEmpty) {
          return false;
        }
        // Check if any cart product matches
        return productIds.any((id) => coupon.applicableProducts!.contains(id));

      case CouponApplicability.firstOrder:
      case CouponApplicability.userSpecific:
        // These require server-side validation
        return true;
    }
  }

  /// Get best applicable coupon for cart
  CouponModel? getBestCouponForCart({
    required List<CouponModel> coupons,
    required double orderSubtotal,
    required List<String> productIds,
    required List<String> categoryIds,
  }) {
    // Filter applicable coupons
    final applicableCoupons = coupons.where((coupon) {
      return isCouponApplicableToCart(
        coupon: coupon,
        orderSubtotal: orderSubtotal,
        productIds: productIds,
        categoryIds: categoryIds,
      );
    }).toList();

    if (applicableCoupons.isEmpty) {
      return null;
    }

    // Find coupon with maximum discount
    CouponModel? bestCoupon;
    double maxDiscount = 0;

    for (final coupon in applicableCoupons) {
      final discount = calculateDiscountAmount(
        coupon: coupon,
        orderSubtotal: orderSubtotal,
      );

      if (discount > maxDiscount) {
        maxDiscount = discount;
        bestCoupon = coupon;
      }
    }

    return bestCoupon;
  }
}
