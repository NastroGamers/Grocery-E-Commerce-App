import '../repositories/checkout_repository.dart';
import '../../data/models/order_model.dart';

class ProcessPaymentUseCase {
  final CheckoutRepository repository;

  ProcessPaymentUseCase(this.repository);

  /// Initiate payment for an order
  Future<PaymentInitiateResponse> initiatePayment({
    required String orderId,
    required double amount,
    required PaymentMethod paymentMethod,
    String currency = 'INR',
    Map<String, dynamic>? metadata,
  }) async {
    // Validate inputs
    if (orderId.isEmpty) {
      throw Exception('Order ID is required');
    }

    if (amount <= 0) {
      throw Exception('Invalid payment amount');
    }

    // For COD, no payment gateway is needed
    if (paymentMethod == PaymentMethod.cod) {
      // Return a mock response for COD
      return PaymentInitiateResponse(
        paymentId: 'COD_${orderId}_${DateTime.now().millisecondsSinceEpoch}',
        orderId: orderId,
        amount: amount,
        currency: currency,
      );
    }

    // Validate payment method requires gateway
    if (paymentMethod != PaymentMethod.razorpay &&
        paymentMethod != PaymentMethod.stripe &&
        paymentMethod != PaymentMethod.upi &&
        paymentMethod != PaymentMethod.wallet) {
      throw Exception('Unsupported payment method');
    }

    final request = PaymentInitiateRequest(
      orderId: orderId,
      amount: amount,
      paymentMethod: paymentMethod,
      currency: currency,
      metadata: metadata,
    );

    try {
      return await repository.initiatePayment(request);
    } catch (e) {
      if (e.toString().contains('Order not found')) {
        throw Exception('Order not found. Please try again.');
      } else if (e.toString().contains('Invalid payment')) {
        throw Exception('Invalid payment data. Please check and try again.');
      }
      rethrow;
    }
  }

  /// Verify payment after completion
  Future<PaymentVerifyResponse> verifyPayment({
    required String orderId,
    required String paymentId,
    String? gatewayPaymentId,
    String? gatewaySignature,
    required PaymentStatus status,
    String? errorMessage,
  }) async {
    // Validate inputs
    if (orderId.isEmpty) {
      throw Exception('Order ID is required');
    }

    if (paymentId.isEmpty) {
      throw Exception('Payment ID is required');
    }

    // For gateway payments, validate gateway-specific fields
    if (status == PaymentStatus.completed) {
      if (gatewayPaymentId == null || gatewayPaymentId.isEmpty) {
        // Allow COD payments without gateway payment ID
        if (!paymentId.startsWith('COD_')) {
          throw Exception('Gateway payment ID is required for verification');
        }
      }
    }

    final request = PaymentVerifyRequest(
      orderId: orderId,
      paymentId: paymentId,
      gatewayPaymentId: gatewayPaymentId,
      gatewaySignature: gatewaySignature,
      status: status,
      errorMessage: errorMessage,
    );

    try {
      return await repository.verifyPayment(request);
    } catch (e) {
      if (e.toString().contains('verification failed')) {
        throw Exception(
          'Payment verification failed. If amount was deducted, it will be refunded within 5-7 business days.'
        );
      } else if (e.toString().contains('not found')) {
        throw Exception('Payment or order not found. Please contact support.');
      }
      rethrow;
    }
  }

  /// Handle payment failure
  Future<void> handlePaymentFailure({
    required String orderId,
    required String paymentId,
    required String errorMessage,
  }) async {
    // Verify payment with failed status
    await verifyPayment(
      orderId: orderId,
      paymentId: paymentId,
      status: PaymentStatus.failed,
      errorMessage: errorMessage,
    );
  }

  /// Retry payment for a failed order
  Future<PaymentInitiateResponse> retryPayment({
    required String orderId,
    required double amount,
    required PaymentMethod paymentMethod,
    String currency = 'INR',
  }) async {
    // First, get the order to check if it exists and can be retried
    try {
      final order = await repository.getOrderById(orderId);

      // Check if order is in a state that allows payment retry
      if (order.paymentStatus == PaymentStatus.completed) {
        throw Exception('Payment already completed for this order');
      }

      if (order.orderStatus == OrderStatus.cancelled) {
        throw Exception('Cannot retry payment for a cancelled order');
      }

      // Initiate new payment
      return await initiatePayment(
        orderId: orderId,
        amount: amount,
        paymentMethod: paymentMethod,
        currency: currency,
        metadata: {'isRetry': true},
      );
    } catch (e) {
      if (e.toString().contains('already completed')) {
        throw Exception('Payment already completed. Please check your orders.');
      }
      rethrow;
    }
  }

  /// Check if a payment method is available
  bool isPaymentMethodAvailable(PaymentMethod method) {
    // All methods are available, but you can add custom logic here
    // For example, check if Razorpay/Stripe keys are configured
    return true;
  }

  /// Get user-friendly payment method name
  String getPaymentMethodName(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cod:
        return 'Cash on Delivery';
      case PaymentMethod.razorpay:
        return 'Razorpay (Card/UPI/Net Banking)';
      case PaymentMethod.stripe:
        return 'Credit/Debit Card';
      case PaymentMethod.upi:
        return 'UPI';
      case PaymentMethod.wallet:
        return 'Wallet';
    }
  }
}
