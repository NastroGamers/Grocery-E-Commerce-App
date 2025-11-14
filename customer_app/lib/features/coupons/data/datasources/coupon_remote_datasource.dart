import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/config/app_config.dart';
import '../models/coupon_model.dart';

abstract class CouponRemoteDataSource {
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

class CouponRemoteDataSourceImpl implements CouponRemoteDataSource {
  final DioClient dioClient;

  CouponRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<CouponListResponse> getCoupons() async {
    try {
      final response = await dioClient.get(
        AppConfig.couponsEndpoint,
      );

      if (response.statusCode == 200) {
        return CouponListResponse.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to load coupons: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to load coupons: ${e.message}');
    }
  }

  @override
  Future<ValidateCouponResponse> validateCoupon(
    ValidateCouponRequest request,
  ) async {
    try {
      final response = await dioClient.post(
        '${AppConfig.couponsEndpoint}/validate',
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return ValidateCouponResponse.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to validate coupon: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        // Return invalid response with error message
        return ValidateCouponResponse(
          isValid: false,
          message: e.response?.data['message'] ?? 'Invalid coupon code',
        );
      } else if (e.response?.statusCode == 404) {
        return ValidateCouponResponse(
          isValid: false,
          message: 'Coupon not found',
        );
      } else if (e.response?.statusCode == 410) {
        return ValidateCouponResponse(
          isValid: false,
          message: 'Coupon has expired',
        );
      } else if (e.response?.statusCode == 422) {
        return ValidateCouponResponse(
          isValid: false,
          message: e.response?.data['message'] ?? 'Coupon not applicable',
        );
      }
      throw Exception('Failed to validate coupon: ${e.message}');
    }
  }

  @override
  Future<ApplyCouponResponse> applyCoupon(
    ApplyCouponRequest request,
  ) async {
    try {
      final response = await dioClient.post(
        '${AppConfig.couponsEndpoint}/apply',
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return ApplyCouponResponse.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to apply coupon: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception(
          e.response?.data['message'] ?? 'Invalid coupon code'
        );
      } else if (e.response?.statusCode == 404) {
        throw Exception('Coupon not found');
      } else if (e.response?.statusCode == 410) {
        throw Exception('Coupon has expired');
      } else if (e.response?.statusCode == 422) {
        throw Exception(
          e.response?.data['message'] ??
          'Coupon cannot be applied to your cart'
        );
      } else if (e.response?.statusCode == 409) {
        throw Exception('Usage limit exceeded for this coupon');
      }
      throw Exception('Failed to apply coupon: ${e.message}');
    }
  }

  @override
  Future<void> removeCoupon(String code) async {
    try {
      final response = await dioClient.delete(
        '${AppConfig.couponsEndpoint}/remove',
        queryParameters: {
          'code': code,
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to remove coupon: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to remove coupon: ${e.message}');
    }
  }

  @override
  Future<List<UserCouponUsage>> getUserCouponUsage() async {
    try {
      final response = await dioClient.get(
        '${AppConfig.couponsEndpoint}/usage',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data
            .map((json) => UserCouponUsage.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load coupon usage: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to load coupon usage: ${e.message}');
    }
  }

  @override
  Future<CouponModel> getCouponByCode(String code) async {
    try {
      final response = await dioClient.get(
        '${AppConfig.couponsEndpoint}/$code',
      );

      if (response.statusCode == 200) {
        return CouponModel.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to load coupon: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Coupon not found');
      }
      throw Exception('Failed to load coupon: ${e.message}');
    }
  }
}
