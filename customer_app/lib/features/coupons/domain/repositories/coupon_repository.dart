import '../../data/models/coupon_model.dart';

abstract class CouponRepository {
  /// Get all available coupons for the user
  Future<CouponListResponse> getCoupons();

  /// Validate a coupon code
  Future<ValidateCouponResponse> validateCoupon(
    ValidateCouponRequest request,
  );

  /// Apply a coupon to the cart
  Future<ApplyCouponResponse> applyCoupon(
    ApplyCouponRequest request,
  );

  /// Remove applied coupon from cart
  Future<void> removeCoupon(String code);

  /// Get user's coupon usage history
  Future<List<UserCouponUsage>> getUserCouponUsage();

  /// Get coupon details by code
  Future<CouponModel> getCouponByCode(String code);
}
