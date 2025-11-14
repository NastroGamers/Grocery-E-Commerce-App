import '../../domain/repositories/coupon_repository.dart';
import '../datasources/coupon_remote_datasource.dart';
import '../models/coupon_model.dart';

class CouponRepositoryImpl implements CouponRepository {
  final CouponRemoteDataSource remoteDataSource;

  CouponRepositoryImpl({required this.remoteDataSource});

  @override
  Future<CouponListResponse> getCoupons() async {
    return await remoteDataSource.getCoupons();
  }

  @override
  Future<ValidateCouponResponse> validateCoupon(
    ValidateCouponRequest request,
  ) async {
    return await remoteDataSource.validateCoupon(request);
  }

  @override
  Future<ApplyCouponResponse> applyCoupon(
    ApplyCouponRequest request,
  ) async {
    return await remoteDataSource.applyCoupon(request);
  }

  @override
  Future<void> removeCoupon(String code) async {
    return await remoteDataSource.removeCoupon(code);
  }

  @override
  Future<List<UserCouponUsage>> getUserCouponUsage() async {
    return await remoteDataSource.getUserCouponUsage();
  }

  @override
  Future<CouponModel> getCouponByCode(String code) async {
    return await remoteDataSource.getCouponByCode(code);
  }
}
