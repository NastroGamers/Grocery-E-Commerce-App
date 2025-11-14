import 'package:json_annotation/json_annotation.dart';

part 'admin_order_model.g.dart';

@JsonSerializable()
class AdminOrderModel {
  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final String userPhone;
  final List<OrderItemModel> items;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double discount;
  final double total;
  final String status; // 'pending', 'confirmed', 'preparing', 'out_for_delivery', 'delivered', 'cancelled'
  final String paymentMethod;
  final String paymentStatus;
  final DateTime createdAt;
  final DateTime? deliveryTime;
  final String? deliveryPersonId;
  final String? deliveryPersonName;
  final String deliveryAddress;
  final String? adminNotes;
  final String? cancellationReason;
  final double? refundAmount;

  AdminOrderModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.items,
    required this.subtotal,
    this.deliveryFee = 0.0,
    this.tax = 0.0,
    this.discount = 0.0,
    required this.total,
    required this.status,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.createdAt,
    this.deliveryTime,
    this.deliveryPersonId,
    this.deliveryPersonName,
    required this.deliveryAddress,
    this.adminNotes,
    this.cancellationReason,
    this.refundAmount,
  });

  factory AdminOrderModel.fromJson(Map<String, dynamic> json) =>
      _$AdminOrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$AdminOrderModelToJson(this);
}

@JsonSerializable()
class OrderItemModel {
  final String productId;
  final String productName;
  final String imageUrl;
  final int quantity;
  final double price;
  final double total;

  OrderItemModel({
    required this.productId,
    required this.productName,
    required this.imageUrl,
    required this.quantity,
    required this.price,
    required this.total,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemModelToJson(this);
}
