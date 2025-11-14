import 'package:dio/dio.dart';
import '../models/dashboard_stats_model.dart';

abstract class DashboardRemoteDataSource {
  Future<DashboardStatsModel> getDashboardStats(DateTime? startDate, DateTime? endDate);
  Future<List<SalesChartModel>> getSalesChart(String period);
  Future<List<TopProductModel>> getTopProducts(int limit, String period);
  Future<List<RecentActivityModel>> getRecentActivities(int page, int limit);
  Future<List<RevenueByCategoryModel>> getRevenueByCategory();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final Dio dio;

  DashboardRemoteDataSourceImpl({required this.dio});

  @override
  Future<DashboardStatsModel> getDashboardStats(DateTime? startDate, DateTime? endDate) async {
    final response = await dio.get(
      '/admin/dashboard/stats',
      queryParameters: {
        if (startDate != null) 'startDate': startDate.toIso8601String(),
        if (endDate != null) 'endDate': endDate.toIso8601String(),
      },
    );

    return DashboardStatsModel.fromJson(response.data['data']);
  }

  @override
  Future<List<SalesChartModel>> getSalesChart(String period) async {
    final response = await dio.get(
      '/admin/dashboard/sales-chart',
      queryParameters: {'period': period},
    );

    return (response.data['data'] as List)
        .map((json) => SalesChartModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<TopProductModel>> getTopProducts(int limit, String period) async {
    final response = await dio.get(
      '/admin/dashboard/top-products',
      queryParameters: {'limit': limit, 'period': period},
    );

    return (response.data['data'] as List)
        .map((json) => TopProductModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<RecentActivityModel>> getRecentActivities(int page, int limit) async {
    final response = await dio.get(
      '/admin/dashboard/activities',
      queryParameters: {'page': page, 'limit': limit},
    );

    return (response.data['data'] as List)
        .map((json) => RecentActivityModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<RevenueByCategoryModel>> getRevenueByCategory() async {
    final response = await dio.get('/admin/dashboard/revenue-by-category');

    return (response.data['data'] as List)
        .map((json) => RevenueByCategoryModel.fromJson(json))
        .toList();
  }
}
