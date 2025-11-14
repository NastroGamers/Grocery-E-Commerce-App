import '../../domain/repositories/tracking_repository.dart';
import '../datasources/tracking_remote_datasource.dart';
import '../models/order_tracking_model.dart';

class TrackingRepositoryImpl implements TrackingRepository {
  final TrackingRemoteDataSource remoteDataSource;

  TrackingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<OrderTrackingModel> getOrderTracking(String orderId) async {
    return await remoteDataSource.getOrderTracking(orderId);
  }

  @override
  Future<String> subscribeLiveTracking(String orderId) async {
    return await remoteDataSource.subscribeLiveTracking(orderId);
  }

  @override
  Future<ContactDriverResponse> contactDriver(
    ContactDriverRequest request,
  ) async {
    return await remoteDataSource.contactDriver(request);
  }

  @override
  Future<void> confirmDelivery(String orderId, String verificationCode) async {
    return await remoteDataSource.confirmDelivery(orderId, verificationCode);
  }
}
