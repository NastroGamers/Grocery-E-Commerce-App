import 'package:json_annotation/json_annotation.dart';

part 'dashboard_stats_model.g.dart';

@JsonSerializable()
class DashboardStatsModel {
  final int totalOrders;
  final double totalRevenue;
  final int activeUsers;
  final int totalProducts;
  final double growthRate;
  final int pendingOrders;
  final int completedOrders;
  final int cancelledOrders;
  final double avgOrderValue;
  final int newCustomersToday;

  DashboardStatsModel({
    required this.totalOrders,
    required this.totalRevenue,
    required this.activeUsers,
    required this.totalProducts,
    this.growthRate = 0.0,
    this.pendingOrders = 0,
    this.completedOrders = 0,
    this.cancelledOrders = 0,
    this.avgOrderValue = 0.0,
    this.newCustomersToday = 0,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardStatsModelToJson(this);
}

@JsonSerializable()
class SalesChartModel {
  final String date;
  final double revenue;
  final int orders;
  final int customers;

  SalesChartModel({
    required this.date,
    required this.revenue,
    required this.orders,
    this.customers = 0,
  });

  factory SalesChartModel.fromJson(Map<String, dynamic> json) =>
      _$SalesChartModelFromJson(json);

  Map<String, dynamic> toJson() => _$SalesChartModelToJson(this);
}

@JsonSerializable()
class TopProductModel {
  final String productId;
  final String name;
  final String imageUrl;
  final int sales;
  final double revenue;
  final int stockLevel;

  TopProductModel({
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.sales,
    required this.revenue,
    this.stockLevel = 0,
  });

  factory TopProductModel.fromJson(Map<String, dynamic> json) =>
      _$TopProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$TopProductModelToJson(this);
}

@JsonSerializable()
class RecentActivityModel {
  final String id;
  final String type; // 'order', 'customer', 'product', 'payment'
  final String description;
  final DateTime timestamp;
  final String? userId;
  final String? userName;
  final Map<String, dynamic>? metadata;

  RecentActivityModel({
    required this.id,
    required this.type,
    required this.description,
    required this.timestamp,
    this.userId,
    this.userName,
    this.metadata,
  });

  factory RecentActivityModel.fromJson(Map<String, dynamic> json) =>
      _$RecentActivityModelFromJson(json);

  Map<String, dynamic> toJson() => _$RecentActivityModelToJson(this);

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    return '${(difference.inDays / 7).floor()}w ago';
  }
}

@JsonSerializable()
class RevenueByCategoryModel {
  final String category;
  final double revenue;
  final int orders;
  final double percentage;

  RevenueByCategoryModel({
    required this.category,
    required this.revenue,
    required this.orders,
    this.percentage = 0.0,
  });

  factory RevenueByCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$RevenueByCategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$RevenueByCategoryModelToJson(this);
}
