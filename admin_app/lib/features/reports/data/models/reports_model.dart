import 'package:json_annotation/json_annotation.dart';

part 'reports_model.g.dart';

@JsonSerializable()
class SalesReportModel {
  final String period;
  final double totalRevenue;
  final int totalOrders;
  final double avgOrderValue;
  final List<TopProductReportModel> topProducts;
  final Map<String, double> revenueByCategory;

  SalesReportModel({
    required this.period,
    required this.totalRevenue,
    required this.totalOrders,
    required this.avgOrderValue,
    required this.topProducts,
    required this.revenueByCategory,
  });

  factory SalesReportModel.fromJson(Map<String, dynamic> json) =>
      _$SalesReportModelFromJson(json);

  Map<String, dynamic> toJson() => _$SalesReportModelToJson(this);
}

@JsonSerializable()
class CustomerReportModel {
  final int newCustomers;
  final int activeCustomers;
  final int totalCustomers;
  final double retentionRate;
  final double churnRate;
  final double avgLifetimeValue;

  CustomerReportModel({
    required this.newCustomers,
    required this.activeCustomers,
    required this.totalCustomers,
    required this.retentionRate,
    required this.churnRate,
    required this.avgLifetimeValue,
  });

  factory CustomerReportModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerReportModelFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerReportModelToJson(this);
}

@JsonSerializable()
class TopProductReportModel {
  final String productId;
  final String name;
  final int unitsSold;
  final double revenue;
  final int stockLevel;

  TopProductReportModel({
    required this.productId,
    required this.name,
    required this.unitsSold,
    required this.revenue,
    required this.stockLevel,
  });

  factory TopProductReportModel.fromJson(Map<String, dynamic> json) =>
      _$TopProductReportModelFromJson(json);

  Map<String, dynamic> toJson() => _$TopProductReportModelToJson(this);
}
