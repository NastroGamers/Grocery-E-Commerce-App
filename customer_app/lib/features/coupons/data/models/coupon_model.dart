import 'package:json_annotation/json_annotation.dart';

part 'coupon_model.g.dart';

enum DiscountType {
  @JsonValue('percentage')
  percentage,
  @JsonValue('fixed')
  fixed,
}

enum CouponApplicability {
  @JsonValue('all')
  all,
  @JsonValue('categories')
  categories,
  @JsonValue('products')
  products,
  @JsonValue('first_order')
  firstOrder,
  @JsonValue('user_specific')
  userSpecific,
}

@JsonSerializable()
class CouponModel {
  final String couponId;
  final String code;
  final String title;
  final String description;
  final DiscountType discountType;
  final double discountValue; // Percentage (0-100) or Fixed amount
  final double? minOrderValue;
  final double? maxDiscount; // For percentage discounts
  final DateTime validFrom;
  final DateTime validTo;
  final int? usageLimit; // Total usage limit
  final int usageCount; // Current usage count
  final int? perUserLimit; // Usage limit per user
  final CouponApplicability applicability;
  final List<String>? applicableCategories;
  final List<String>? applicableProducts;
  final List<String>? excludedProducts;
  final bool isActive;
  final String? terms;
  final String? imageUrl;

  CouponModel({
    required this.couponId,
    required this.code,
    required this.title,
    required this.description,
    required this.discountType,
    required this.discountValue,
    this.minOrderValue,
    this.maxDiscount,
    required this.validFrom,
    required this.validTo,
    this.usageLimit,
    required this.usageCount,
    this.perUserLimit,
    required this.applicability,
    this.applicableCategories,
    this.applicableProducts,
    this.excludedProducts,
    required this.isActive,
    this.terms,
    this.imageUrl,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) =>
      _$CouponModelFromJson(json);

  Map<String, dynamic> toJson() => _$CouponModelToJson(this);

  // Computed properties
  bool get isExpired {
    final now = DateTime.now();
    return now.isAfter(validTo) || now.isBefore(validFrom);
  }

  bool get hasUsageLimitReached {
    if (usageLimit == null) return false;
    return usageCount >= usageLimit!;
  }

  bool get isValid => isActive && !isExpired && !hasUsageLimitReached;

  String get discountText {
    if (discountType == DiscountType.percentage) {
      return '${discountValue.toInt()}% OFF';
    } else {
      return '₹${discountValue.toInt()} OFF';
    }
  }

  String get validityText {
    final now = DateTime.now();
    if (now.isBefore(validFrom)) {
      return 'Valid from ${_formatDate(validFrom)}';
    } else if (now.isBefore(validTo)) {
      final daysLeft = validTo.difference(now).inDays;
      if (daysLeft == 0) {
        return 'Expires today';
      } else if (daysLeft == 1) {
        return 'Expires tomorrow';
      } else if (daysLeft <= 7) {
        return 'Expires in $daysLeft days';
      } else {
        return 'Valid till ${_formatDate(validTo)}';
      }
    } else {
      return 'Expired';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

@JsonSerializable()
class ValidateCouponRequest {
  final String code;
  final double orderSubtotal;
  final List<String> productIds;
  final List<String> categoryIds;

  ValidateCouponRequest({
    required this.code,
    required this.orderSubtotal,
    required this.productIds,
    required this.categoryIds,
  });

  factory ValidateCouponRequest.fromJson(Map<String, dynamic> json) =>
      _$ValidateCouponRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ValidateCouponRequestToJson(this);
}

@JsonSerializable()
class ValidateCouponResponse {
  final bool isValid;
  final String message;
  final CouponModel? coupon;
  final double? discountAmount;
  final double? finalAmount;

  ValidateCouponResponse({
    required this.isValid,
    required this.message,
    this.coupon,
    this.discountAmount,
    this.finalAmount,
  });

  factory ValidateCouponResponse.fromJson(Map<String, dynamic> json) =>
      _$ValidateCouponResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ValidateCouponResponseToJson(this);
}

@JsonSerializable()
class ApplyCouponRequest {
  final String code;
  final double orderSubtotal;
  final List<String> productIds;
  final List<String> categoryIds;

  ApplyCouponRequest({
    required this.code,
    required this.orderSubtotal,
    required this.productIds,
    required this.categoryIds,
  });

  factory ApplyCouponRequest.fromJson(Map<String, dynamic> json) =>
      _$ApplyCouponRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ApplyCouponRequestToJson(this);
}

@JsonSerializable()
class ApplyCouponResponse {
  final bool success;
  final String message;
  final CouponModel coupon;
  final double discountAmount;
  final double subtotal;
  final double finalAmount;

  ApplyCouponResponse({
    required this.success,
    required this.message,
    required this.coupon,
    required this.discountAmount,
    required this.subtotal,
    required this.finalAmount,
  });

  factory ApplyCouponResponse.fromJson(Map<String, dynamic> json) =>
      _$ApplyCouponResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ApplyCouponResponseToJson(this);
}

@JsonSerializable()
class CouponListResponse {
  final List<CouponModel> availableCoupons;
  final List<CouponModel> usedCoupons;

  CouponListResponse({
    required this.availableCoupons,
    required this.usedCoupons,
  });

  factory CouponListResponse.fromJson(Map<String, dynamic> json) =>
      _$CouponListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CouponListResponseToJson(this);
}

@JsonSerializable()
class UserCouponUsage {
  final String couponId;
  final String code;
  final int usageCount;
  final DateTime? lastUsedAt;
  final List<String> orderIds;

  UserCouponUsage({
    required this.couponId,
    required this.code,
    required this.usageCount,
    this.lastUsedAt,
    required this.orderIds,
  });

  factory UserCouponUsage.fromJson(Map<String, dynamic> json) =>
      _$UserCouponUsageFromJson(json);

  Map<String, dynamic> toJson() => _$UserCouponUsageToJson(this);
}
