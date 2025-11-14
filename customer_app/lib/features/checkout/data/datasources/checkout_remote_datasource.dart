import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/config/app_config.dart';
import '../models/order_model.dart';

abstract class CheckoutRemoteDataSource {
  /// Calculate order summary with all fees and discounts
  Future<OrderSummary> calculateOrderSummary({
    required List<OrderItemModel> items,
    required String deliveryAddressId,
    String? couponCode,
  });

  /// Check stock availability before placing order
  Future<CheckStockAvailabilityResponse> checkStockAvailability(
    CheckStockAvailabilityRequest request,
  );

  /// Create a new order
  Future<CreateOrderResponse> createOrder(CreateOrderRequest request);

  /// Get order details by ID
  Future<OrderModel> getOrderById(String orderId);

  /// Initiate payment for an order
  Future<PaymentInitiateResponse> initiatePayment(
    PaymentInitiateRequest request,
  );

  /// Verify payment status
  Future<PaymentVerifyResponse> verifyPayment(
    PaymentVerifyRequest request,
  );

  /// Cancel an order
  Future<OrderModel> cancelOrder(String orderId, String reason);
}

class CheckoutRemoteDataSourceImpl implements CheckoutRemoteDataSource {
  final DioClient dioClient;

  CheckoutRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<OrderSummary> calculateOrderSummary({
    required List<OrderItemModel> items,
    required String deliveryAddressId,
    String? couponCode,
  }) async {
    try {
      final response = await dioClient.post(
        '${AppConfig.ordersEndpoint}/calculate-summary',
        data: {
          'items': items.map((item) => item.toJson()).toList(),
          'deliveryAddressId': deliveryAddressId,
          if (couponCode != null) 'couponCode': couponCode,
        },
      );

      if (response.statusCode == 200) {
        return OrderSummary.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to calculate order summary: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception(
          e.response?.data['message'] ?? 'Invalid order data'
        );
      }
      throw Exception('Failed to calculate order summary: ${e.message}');
    }
  }

  @override
  Future<CheckStockAvailabilityResponse> checkStockAvailability(
    CheckStockAvailabilityRequest request,
  ) async {
    try {
      final response = await dioClient.post(
        '${AppConfig.ordersEndpoint}/check-stock',
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return CheckStockAvailabilityResponse.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to check stock availability: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to check stock availability: ${e.message}');
    }
  }

  @override
  Future<CreateOrderResponse> createOrder(CreateOrderRequest request) async {
    try {
      final response = await dioClient.post(
        '${AppConfig.ordersEndpoint}/create',
        data: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return CreateOrderResponse.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to create order: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception(
          e.response?.data['message'] ?? 'Invalid order data'
        );
      } else if (e.response?.statusCode == 409) {
        throw Exception(
          e.response?.data['message'] ?? 'Order already exists for this cart'
        );
      } else if (e.response?.statusCode == 422) {
        throw Exception(
          e.response?.data['message'] ?? 'Some items are out of stock'
        );
      }
      throw Exception('Failed to create order: ${e.message}');
    }
  }

  @override
  Future<OrderModel> getOrderById(String orderId) async {
    try {
      final response = await dioClient.get(
        '${AppConfig.ordersEndpoint}/$orderId',
      );

      if (response.statusCode == 200) {
        return OrderModel.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to get order: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Order not found');
      }
      throw Exception('Failed to get order: ${e.message}');
    }
  }

  @override
  Future<PaymentInitiateResponse> initiatePayment(
    PaymentInitiateRequest request,
  ) async {
    try {
      final response = await dioClient.post(
        '${AppConfig.paymentsEndpoint}/initiate',
        data: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PaymentInitiateResponse.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to initiate payment: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception(
          e.response?.data['message'] ?? 'Invalid payment data'
        );
      } else if (e.response?.statusCode == 404) {
        throw Exception('Order not found');
      }
      throw Exception('Failed to initiate payment: ${e.message}');
    }
  }

  @override
  Future<PaymentVerifyResponse> verifyPayment(
    PaymentVerifyRequest request,
  ) async {
    try {
      final response = await dioClient.post(
        '${AppConfig.paymentsEndpoint}/verify',
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return PaymentVerifyResponse.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to verify payment: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception(
          e.response?.data['message'] ?? 'Payment verification failed'
        );
      } else if (e.response?.statusCode == 404) {
        throw Exception('Payment or order not found');
      }
      throw Exception('Failed to verify payment: ${e.message}');
    }
  }

  @override
  Future<OrderModel> cancelOrder(String orderId, String reason) async {
    try {
      final response = await dioClient.post(
        '${AppConfig.ordersEndpoint}/$orderId/cancel',
        data: {
          'reason': reason,
        },
      );

      if (response.statusCode == 200) {
        return OrderModel.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to cancel order: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception(
          e.response?.data['message'] ?? 'Cannot cancel order at this stage'
        );
      } else if (e.response?.statusCode == 404) {
        throw Exception('Order not found');
      }
      throw Exception('Failed to cancel order: ${e.message}');
    }
  }
}
