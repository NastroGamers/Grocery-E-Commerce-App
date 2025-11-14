import 'package:json_annotation/json_annotation.dart';

part 'customer_model.g.dart';

@JsonSerializable()
class CustomerModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? profilePicture;
  final int totalOrders;
  final double totalSpent;
  final DateTime registeredAt;
  final DateTime? lastOrderAt;
  final String status; // 'active', 'blocked', 'inactive'
  final List<String>? addresses;
  final String? preferredPaymentMethod;
  final double avgOrderValue;
  final int completedOrders;
  final int cancelledOrders;

  CustomerModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profilePicture,
    this.totalOrders = 0,
    this.totalSpent = 0.0,
    required this.registeredAt,
    this.lastOrderAt,
    this.status = 'active',
    this.addresses,
    this.preferredPaymentMethod,
    this.avgOrderValue = 0.0,
    this.completedOrders = 0,
    this.cancelledOrders = 0,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerModelFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerModelToJson(this);
}

@JsonSerializable()
class CustomerStatsModel {
  final int totalCustomers;
  final int activeCustomers;
  final int newCustomersToday;
  final int newCustomersThisWeek;
  final int newCustomersThisMonth;
  final double avgLifetimeValue;

  CustomerStatsModel({
    required this.totalCustomers,
    required this.activeCustomers,
    this.newCustomersToday = 0,
    this.newCustomersThisWeek = 0,
    this.newCustomersThisMonth = 0,
    this.avgLifetimeValue = 0.0,
  });

  factory CustomerStatsModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerStatsModelToJson(this);
}
