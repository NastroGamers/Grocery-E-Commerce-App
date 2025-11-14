import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/config/app_config.dart';
import '../../../checkout/data/models/order_model.dart';
import '../models/order_history_model.dart';

abstract class OrdersRemoteDataSource {
  Future<OrderHistoryResponse> getOrderHistory({
    required int page,
    required int limit,
    OrderFilter? filter,
  });

  Future<OrderModel> getOrderDetails(String orderId);

  Future<ReorderResponse> reorder(ReorderRequest request);

  Future<List<OrderModel>> getRecentOrders({required int limit});
}

class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  final DioClient dioClient;

  OrdersRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<OrderHistoryResponse> getOrderHistory({
    required int page,
    required int limit,
    OrderFilter? filter,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (filter != null) {
        queryParams['filterType'] = filter.type.toString().split('.').last;
        if (filter.startDate != null) {
          queryParams['startDate'] = filter.startDate!.toIso8601String();
        }
        if (filter.endDate != null) {
          queryParams['endDate'] = filter.endDate!.toIso8601String();
        }
      }

      final response = await dioClient.get(
        AppConfig.ordersEndpoint,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        return OrderHistoryResponse.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to load orders: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to load orders: ${e.message}');
    }
  }

  @override
  Future<OrderModel> getOrderDetails(String orderId) async {
    try {
      final response = await dioClient.get(
        '${AppConfig.ordersEndpoint}/$orderId',
      );

      if (response.statusCode == 200) {
        return OrderModel.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to load order: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Order not found');
      }
      throw Exception('Failed to load order: ${e.message}');
    }
  }

  @override
  Future<ReorderResponse> reorder(ReorderRequest request) async {
    try {
      final response = await dioClient.post(
        '${AppConfig.ordersEndpoint}/${request.orderId}/reorder',
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return ReorderResponse.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to reorder: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Order not found');
      } else if (e.response?.statusCode == 400) {
        throw Exception(
          e.response?.data['message'] ?? 'Cannot reorder this order'
        );
      }
      throw Exception('Failed to reorder: ${e.message}');
    }
  }

  @override
  Future<List<OrderModel>> getRecentOrders({required int limit}) async {
    try {
      final response = await dioClient.get(
        '${AppConfig.ordersEndpoint}/recent',
        queryParameters: {'limit': limit},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data
            .map((json) => OrderModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load recent orders: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to load recent orders: ${e.message}');
    }
  }
}
