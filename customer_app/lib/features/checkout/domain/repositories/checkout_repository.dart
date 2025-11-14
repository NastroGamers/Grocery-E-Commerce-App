import '../../data/models/order_model.dart';

abstract class CheckoutRepository {
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
