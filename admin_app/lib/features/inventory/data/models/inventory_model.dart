import 'package:json_annotation/json_annotation.dart';

part 'inventory_model.g.dart';

@JsonSerializable()
class InventoryItemModel {
  final String productId;
  final String productName;
  final String imageUrl;
  final int currentStock;
  final int minStock;
  final int maxStock;
  final DateTime? lastRestocked;
  final String? sku;
  final String category;
  final double price;
  final String status; // 'in_stock', 'low_stock', 'out_of_stock'

  InventoryItemModel({
    required this.productId,
    required this.productName,
    required this.imageUrl,
    required this.currentStock,
    this.minStock = 10,
    this.maxStock = 1000,
    this.lastRestocked,
    this.sku,
    required this.category,
    required this.price,
    required this.status,
  });

  factory InventoryItemModel.fromJson(Map<String, dynamic> json) =>
      _$InventoryItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$InventoryItemModelToJson(this);

  bool get isLowStock => currentStock <= minStock;
  bool get isOutOfStock => currentStock == 0;
}

@JsonSerializable()
class StockAdjustmentModel {
  final String id;
  final String productId;
  final String type; // 'add', 'remove', 'restock', 'damage', 'return'
  final int quantity;
  final String reason;
  final DateTime timestamp;
  final String? performedBy;

  StockAdjustmentModel({
    required this.id,
    required this.productId,
    required this.type,
    required this.quantity,
    required this.reason,
    required this.timestamp,
    this.performedBy,
  });

  factory StockAdjustmentModel.fromJson(Map<String, dynamic> json) =>
      _$StockAdjustmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$StockAdjustmentModelToJson(this);
}

@JsonSerializable()
class LowStockAlertModel {
  final String productId;
  final String productName;
  final String imageUrl;
  final int currentStock;
  final int minStock;
  final String category;
  final DateTime alertedAt;

  LowStockAlertModel({
    required this.productId,
    required this.productName,
    required this.imageUrl,
    required this.currentStock,
    required this.minStock,
    required this.category,
    required this.alertedAt,
  });

  factory LowStockAlertModel.fromJson(Map<String, dynamic> json) =>
      _$LowStockAlertModelFromJson(json);

  Map<String, dynamic> toJson() => _$LowStockAlertModelToJson(this);
}
