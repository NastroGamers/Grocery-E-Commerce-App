import 'package:json_annotation/json_annotation.dart';

part 'vendor_dashboard_model.g.dart';

@JsonSerializable()
class VendorDashboardModel {
  final int totalProducts;
  final int activeProducts;
  final int pendingProducts;
  final int rejectedProducts;
  final int totalOrders;
  final int pendingOrders;
  final int completedOrders;
  final double totalRevenue;
  final double monthlyRevenue;
  final double pendingEarnings;
  final double avgRating;
  final int totalReviews;

  VendorDashboardModel({
    required this.totalProducts,
    required this.activeProducts,
    this.pendingProducts = 0,
    this.rejectedProducts = 0,
    required this.totalOrders,
    this.pendingOrders = 0,
    this.completedOrders = 0,
    required this.totalRevenue,
    this.monthlyRevenue = 0.0,
    this.pendingEarnings = 0.0,
    this.avgRating = 0.0,
    this.totalReviews = 0,
  });

  factory VendorDashboardModel.fromJson(Map<String, dynamic> json) =>
      _$VendorDashboardModelFromJson(json);

  Map<String, dynamic> toJson() => _$VendorDashboardModelToJson(this);
}

@JsonSerializable()
class VendorProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String? imageUrl;
  final List<String>? images;
  final String category;
  final int stock;
  final String unit;
  final String approvalStatus; // 'pending', 'approved', 'rejected'
  final String? rejectionReason;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final double? discount;
  final Map<String, dynamic>? variants;

  VendorProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
    this.images,
    required this.category,
    required this.stock,
    required this.unit,
    this.approvalStatus = 'pending',
    this.rejectionReason,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
    this.discount,
    this.variants,
  });

  factory VendorProductModel.fromJson(Map<String, dynamic> json) =>
      _$VendorProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$VendorProductModelToJson(this);
}

@JsonSerializable()
class VendorOrderModel {
  final String orderId;
  final String customerName;
  final String customerPhone;
  final List<VendorOrderItemModel> items;
  final double subtotal;
  final double commission;
  final double netEarnings;
  final String status; // 'pending', 'confirmed', 'preparing', 'ready', 'delivered', 'cancelled'
  final String paymentStatus;
  final DateTime createdAt;
  final DateTime? deliveryTime;

  VendorOrderModel({
    required this.orderId,
    required this.customerName,
    required this.customerPhone,
    required this.items,
    required this.subtotal,
    this.commission = 0.0,
    required this.netEarnings,
    required this.status,
    required this.paymentStatus,
    required this.createdAt,
    this.deliveryTime,
  });

  factory VendorOrderModel.fromJson(Map<String, dynamic> json) =>
      _$VendorOrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$VendorOrderModelToJson(this);
}

@JsonSerializable()
class VendorOrderItemModel {
  final String productId;
  final String productName;
  final int quantity;
  final double price;
  final double total;

  VendorOrderItemModel({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.total,
  });

  factory VendorOrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$VendorOrderItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$VendorOrderItemModelToJson(this);
}
