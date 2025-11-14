import 'package:json_annotation/json_annotation.dart';

part 'assigned_order_model.g.dart';

@JsonSerializable()
class AssignedOrderModel {
  final String orderId;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final double deliveryLat;
  final double deliveryLng;
  final String pickupAddress;
  final double pickupLat;
  final double pickupLng;
  final List<OrderItemSummary> items;
  final double total;
  final String paymentMethod;
  final bool isPaymentCollected;
  final DateTime deliverySlotStart;
  final DateTime deliverySlotEnd;
  final String status; // 'assigned', 'accepted', 'picked_up', 'in_transit', 'delivered'
  final String? deliveryOTP;
  final DateTime assignedAt;
  final String? specialInstructions;

  AssignedOrderModel({
    required this.orderId,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.deliveryLat,
    required this.deliveryLng,
    required this.pickupAddress,
    required this.pickupLat,
    required this.pickupLng,
    required this.items,
    required this.total,
    required this.paymentMethod,
    this.isPaymentCollected = false,
    required this.deliverySlotStart,
    required this.deliverySlotEnd,
    required this.status,
    this.deliveryOTP,
    required this.assignedAt,
    this.specialInstructions,
  });

  factory AssignedOrderModel.fromJson(Map<String, dynamic> json) =>
      _$AssignedOrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$AssignedOrderModelToJson(this);

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
}

@JsonSerializable()
class OrderItemSummary {
  final String productName;
  final int quantity;
  final String unit;

  OrderItemSummary({
    required this.productName,
    required this.quantity,
    required this.unit,
  });

  factory OrderItemSummary.fromJson(Map<String, dynamic> json) =>
      _$OrderItemSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemSummaryToJson(this);
}

@JsonSerializable()
class PickupConfirmationModel {
  final String orderId;
  final DateTime pickedAt;
  final int itemsCount;
  final String verificationCode;
  final List<String>? images;

  PickupConfirmationModel({
    required this.orderId,
    required this.pickedAt,
    required this.itemsCount,
    required this.verificationCode,
    this.images,
  });

  factory PickupConfirmationModel.fromJson(Map<String, dynamic> json) =>
      _$PickupConfirmationModelFromJson(json);

  Map<String, dynamic> toJson() => _$PickupConfirmationModelToJson(this);
}

@JsonSerializable()
class DeliveryConfirmationModel {
  final String orderId;
  final DateTime deliveredAt;
  final String otp;
  final String? customerSignature;
  final List<String>? deliveryImages;

  DeliveryConfirmationModel({
    required this.orderId,
    required this.deliveredAt,
    required this.otp,
    this.customerSignature,
    this.deliveryImages,
  });

  factory DeliveryConfirmationModel.fromJson(Map<String, dynamic> json) =>
      _$DeliveryConfirmationModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryConfirmationModelToJson(this);
}
