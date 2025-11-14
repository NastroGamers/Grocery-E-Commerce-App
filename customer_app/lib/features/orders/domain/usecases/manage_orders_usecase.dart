import '../repositories/orders_repository.dart';
import '../../../checkout/data/models/order_model.dart';
import '../../data/models/order_history_model.dart';

class ManageOrdersUseCase {
  final OrdersRepository repository;

  ManageOrdersUseCase(this.repository);

  Future<OrderHistoryResponse> getOrderHistory({
    required int page,
    required int limit,
    OrderFilter? filter,
  }) async {
    if (page < 1) {
      throw Exception('Invalid page number');
    }

    if (limit < 1 || limit > 50) {
      throw Exception('Limit must be between 1 and 50');
    }

    return await repository.getOrderHistory(
      page: page,
      limit: limit,
      filter: filter,
    );
  }

  Future<OrderModel> getOrderDetails(String orderId) async {
    if (orderId.isEmpty) {
      throw Exception('Order ID is required');
    }

    return await repository.getOrderDetails(orderId);
  }

  Future<ReorderResponse> reorder({
    required String orderId,
    List<String>? excludeProductIds,
  }) async {
    if (orderId.isEmpty) {
      throw Exception('Order ID is required');
    }

    final request = ReorderRequest(
      orderId: orderId,
      excludeProductIds: excludeProductIds,
    );

    return await repository.reorder(request);
  }

  Future<List<OrderModel>> getRecentOrders({int limit = 5}) async {
    if (limit < 1 || limit > 20) {
      throw Exception('Limit must be between 1 and 20');
    }

    return await repository.getRecentOrders(limit: limit);
  }
}
