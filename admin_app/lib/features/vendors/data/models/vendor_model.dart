import 'package:json_annotation/json_annotation.dart';

part 'vendor_model.g.dart';

@JsonSerializable()
class VendorModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String businessName;
  final String? businessLicense;
  final String? taxId;
  final String status; // 'pending', 'approved', 'rejected', 'suspended'
  final int productsCount;
  final double rating;
  final int totalReviews;
  final DateTime joinedAt;
  final DateTime? approvedAt;
  final String? address;
  final double? commissionRate;

  VendorModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.businessName,
    this.businessLicense,
    this.taxId,
    this.status = 'pending',
    this.productsCount = 0,
    this.rating = 0.0,
    this.totalReviews = 0,
    required this.joinedAt,
    this.approvedAt,
    this.address,
    this.commissionRate,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) =>
      _$VendorModelFromJson(json);

  Map<String, dynamic> toJson() => _$VendorModelToJson(this);
}

@JsonSerializable()
class VendorStatsModel {
  final int totalProducts;
  final int activeProducts;
  final int totalSales;
  final double totalRevenue;
  final double avgRating;

  VendorStatsModel({
    required this.totalProducts,
    required this.activeProducts,
    this.totalSales = 0,
    this.totalRevenue = 0.0,
    this.avgRating = 0.0,
  });

  factory VendorStatsModel.fromJson(Map<String, dynamic> json) =>
      _$VendorStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$VendorStatsModelToJson(this);
}
