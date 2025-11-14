import '../repositories/tracking_repository.dart';
import '../../data/models/order_tracking_model.dart';

class TrackOrderUseCase {
  final TrackingRepository repository;

  TrackOrderUseCase(this.repository);

  /// Get order tracking details
  Future<OrderTrackingModel> call(String orderId) async {
    if (orderId.isEmpty) {
      throw Exception('Order ID is required');
    }

    return await repository.getOrderTracking(orderId);
  }

  /// Subscribe to live tracking
  Future<String> subscribeLiveTracking(String orderId) async {
    if (orderId.isEmpty) {
      throw Exception('Order ID is required');
    }

    return await repository.subscribeLiveTracking(orderId);
  }

  /// Contact delivery driver
  Future<ContactDriverResponse> contactDriver({
    required String orderId,
    required String contactType,
    String? message,
  }) async {
    if (orderId.isEmpty) {
      throw Exception('Order ID is required');
    }

    if (contactType != 'call' && contactType != 'message') {
      throw Exception('Invalid contact type');
    }

    final request = ContactDriverRequest(
      orderId: orderId,
      contactType: contactType,
      message: message,
    );

    return await repository.contactDriver(request);
  }

  /// Confirm delivery
  Future<void> confirmDelivery({
    required String orderId,
    required String verificationCode,
  }) async {
    if (orderId.isEmpty) {
      throw Exception('Order ID is required');
    }

    if (verificationCode.isEmpty) {
      throw Exception('Verification code is required');
    }

    if (verificationCode.length != 6) {
      throw Exception('Verification code must be 6 digits');
    }

    return await repository.confirmDelivery(orderId, verificationCode);
  }
}
