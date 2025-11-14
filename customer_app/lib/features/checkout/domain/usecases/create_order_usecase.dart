import '../repositories/checkout_repository.dart';
import '../../data/models/order_model.dart';

class CreateOrderUseCase {
  final CheckoutRepository repository;

  CreateOrderUseCase(this.repository);

  /// Create a new order
  Future<CreateOrderResponse> call({
    required List<OrderItemModel> items,
    required String deliveryAddressId,
    required String deliverySlotId,
    required DateTime deliveryDate,
    required PaymentMethod paymentMethod,
    String? appliedCouponCode,
    String? deliveryInstructions,
  }) async {
    // Validate inputs
    if (items.isEmpty) {
      throw Exception('Cannot create order with empty cart');
    }

    if (deliveryAddressId.isEmpty) {
      throw Exception('Delivery address is required');
    }

    if (deliverySlotId.isEmpty) {
      throw Exception('Delivery slot is required');
    }

    // Validate delivery date
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final requestDate = DateTime(deliveryDate.year, deliveryDate.month, deliveryDate.day);

    if (requestDate.isBefore(today)) {
      throw Exception('Cannot create order for past dates');
    }

    // Validate delivery instructions length
    if (deliveryInstructions != null && deliveryInstructions.length > 500) {
      throw Exception('Delivery instructions cannot exceed 500 characters');
    }

    // Create order request
    final request = CreateOrderRequest(
      items: items,
      deliveryAddressId: deliveryAddressId,
      deliverySlotId: deliverySlotId,
      deliveryDate: deliveryDate,
      paymentMethod: paymentMethod,
      appliedCouponCode: appliedCouponCode,
      deliveryInstructions: deliveryInstructions,
    );

    try {
      return await repository.createOrder(request);
    } catch (e) {
      // Handle specific error cases
      if (e.toString().contains('already exists')) {
        throw Exception(
          'An order with these items already exists. Please check your order history.'
        );
      } else if (e.toString().contains('out of stock')) {
        throw Exception(
          'Some items became out of stock. Please review your cart.'
        );
      }
      rethrow;
    }
  }

  /// Get order details by ID
  Future<OrderModel> getOrderById(String orderId) async {
    if (orderId.isEmpty) {
      throw Exception('Order ID is required');
    }

    return await repository.getOrderById(orderId);
  }

  /// Cancel an order
  Future<OrderModel> cancelOrder({
    required String orderId,
    required String reason,
  }) async {
    if (orderId.isEmpty) {
      throw Exception('Order ID is required');
    }

    if (reason.isEmpty) {
      throw Exception('Please provide a reason for cancellation');
    }

    if (reason.length < 10) {
      throw Exception('Please provide a more detailed reason (at least 10 characters)');
    }

    if (reason.length > 500) {
      throw Exception('Cancellation reason cannot exceed 500 characters');
    }

    try {
      return await repository.cancelOrder(orderId, reason);
    } catch (e) {
      if (e.toString().contains('Cannot cancel')) {
        throw Exception(
          'This order cannot be cancelled at this stage. Please contact support.'
        );
      }
      rethrow;
    }
  }
}
