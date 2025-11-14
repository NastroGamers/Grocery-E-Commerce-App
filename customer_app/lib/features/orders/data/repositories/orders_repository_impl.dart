import '../../domain/repositories/orders_repository.dart';
import '../datasources/orders_remote_datasource.dart';
import '../../../checkout/data/models/order_model.dart';
import '../models/order_history_model.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersRemoteDataSource remoteDataSource;

  OrdersRepositoryImpl({required this.remoteDataSource});

  @override
  Future<OrderHistoryResponse> getOrderHistory({
    required int page,
    required int limit,
    OrderFilter? filter,
  }) async {
    return await remoteDataSource.getOrderHistory(
      page: page,
      limit: limit,
      filter: filter,
    );
  }

  @override
  Future<OrderModel> getOrderDetails(String orderId) async {
    return await remoteDataSource.getOrderDetails(orderId);
  }

  @override
  Future<ReorderResponse> reorder(ReorderRequest request) async {
    return await remoteDataSource.reorder(request);
  }

  @override
  Future<List<OrderModel>> getRecentOrders({required int limit}) async {
    return await remoteDataSource.getRecentOrders(limit: limit);
  }
}
