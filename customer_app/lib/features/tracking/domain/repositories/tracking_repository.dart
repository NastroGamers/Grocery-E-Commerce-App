import '../../data/models/order_tracking_model.dart';

abstract class TrackingRepository {
  /// Get order tracking details
  Future<OrderTrackingModel> getOrderTracking(String orderId);

  /// Subscribe to live location updates
  Future<String> subscribeLiveTracking(String orderId);

  /// Contact delivery driver
  Future<ContactDriverResponse> contactDriver(ContactDriverRequest request);

  /// Confirm delivery
  Future<void> confirmDelivery(String orderId, String verificationCode);
}
