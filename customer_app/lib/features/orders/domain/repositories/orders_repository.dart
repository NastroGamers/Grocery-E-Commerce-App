import '../../../checkout/data/models/order_model.dart';
import '../../data/models/order_history_model.dart';

abstract class OrdersRepository {
  Future<OrderHistoryResponse> getOrderHistory({
    required int page,
    required int limit,
    OrderFilter? filter,
  });

  Future<OrderModel> getOrderDetails(String orderId);

  Future<ReorderResponse> reorder(ReorderRequest request);

  Future<List<OrderModel>> getRecentOrders({required int limit});
}
