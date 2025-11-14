import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/config/app_config.dart';
import '../models/order_tracking_model.dart';

abstract class TrackingRemoteDataSource {
  /// Get order tracking details
  Future<OrderTrackingModel> getOrderTracking(String orderId);

  /// Subscribe to live location updates (returns WebSocket URL)
  Future<String> subscribeLiveTracking(String orderId);

  /// Contact delivery driver
  Future<ContactDriverResponse> contactDriver(ContactDriverRequest request);

  /// Mark order as delivered (for verification)
  Future<void> confirmDelivery(String orderId, String verificationCode);
}

class TrackingRemoteDataSourceImpl implements TrackingRemoteDataSource {
  final DioClient dioClient;

  TrackingRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<OrderTrackingModel> getOrderTracking(String orderId) async {
    try {
      final response = await dioClient.get(
        '${AppConfig.ordersEndpoint}/$orderId/tracking',
      );

      if (response.statusCode == 200) {
        return OrderTrackingModel.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to load tracking: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Order not found');
      }
      throw Exception('Failed to load tracking: ${e.message}');
    }
  }

  @override
  Future<String> subscribeLiveTracking(String orderId) async {
    try {
      final response = await dioClient.post(
        '${AppConfig.ordersEndpoint}/$orderId/tracking/subscribe',
      );

      if (response.statusCode == 200) {
        return response.data['data']['websocketUrl'] as String;
      } else {
        throw Exception('Failed to subscribe: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Order not found');
      } else if (e.response?.statusCode == 400) {
        throw Exception('Live tracking not available for this order');
      }
      throw Exception('Failed to subscribe to tracking: ${e.message}');
    }
  }

  @override
  Future<ContactDriverResponse> contactDriver(
    ContactDriverRequest request,
  ) async {
    try {
      final response = await dioClient.post(
        '${AppConfig.ordersEndpoint}/${request.orderId}/contact-driver',
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return ContactDriverResponse.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to contact driver: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Order or driver not found');
      } else if (e.response?.statusCode == 400) {
        throw Exception('Driver is not available for contact');
      }
      throw Exception('Failed to contact driver: ${e.message}');
    }
  }

  @override
  Future<void> confirmDelivery(String orderId, String verificationCode) async {
    try {
      final response = await dioClient.post(
        '${AppConfig.ordersEndpoint}/$orderId/confirm-delivery',
        data: {
          'verificationCode': verificationCode,
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to confirm delivery: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception('Invalid verification code');
      } else if (e.response?.statusCode == 404) {
        throw Exception('Order not found');
      }
      throw Exception('Failed to confirm delivery: ${e.message}');
    }
  }
}
