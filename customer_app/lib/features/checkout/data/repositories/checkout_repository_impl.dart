import '../../domain/repositories/checkout_repository.dart';
import '../datasources/checkout_remote_datasource.dart';
import '../models/order_model.dart';

class CheckoutRepositoryImpl implements CheckoutRepository {
  final CheckoutRemoteDataSource remoteDataSource;

  CheckoutRepositoryImpl({required this.remoteDataSource});

  @override
  Future<OrderSummary> calculateOrderSummary({
    required List<OrderItemModel> items,
    required String deliveryAddressId,
    String? couponCode,
  }) async {
    return await remoteDataSource.calculateOrderSummary(
      items: items,
      deliveryAddressId: deliveryAddressId,
      couponCode: couponCode,
    );
  }

  @override
  Future<CheckStockAvailabilityResponse> checkStockAvailability(
    CheckStockAvailabilityRequest request,
  ) async {
    return await remoteDataSource.checkStockAvailability(request);
  }

  @override
  Future<CreateOrderResponse> createOrder(CreateOrderRequest request) async {
    return await remoteDataSource.createOrder(request);
  }

  @override
  Future<OrderModel> getOrderById(String orderId) async {
    return await remoteDataSource.getOrderById(orderId);
  }

  @override
  Future<PaymentInitiateResponse> initiatePayment(
    PaymentInitiateRequest request,
  ) async {
    return await remoteDataSource.initiatePayment(request);
  }

  @override
  Future<PaymentVerifyResponse> verifyPayment(
    PaymentVerifyRequest request,
  ) async {
    return await remoteDataSource.verifyPayment(request);
  }

  @override
  Future<OrderModel> cancelOrder(String orderId, String reason) async {
    return await remoteDataSource.cancelOrder(orderId, reason);
  }
}
