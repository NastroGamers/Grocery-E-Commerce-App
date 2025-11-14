import 'package:json_annotation/json_annotation.dart';
import '../../../products/data/models/product_model.dart';

part 'cart_model.g.dart';

@JsonSerializable()
class CartItemModel {
  final String id;
  final String userId;
  final String productId;
  final ProductModel product;
  final String? variantId;
  final ProductVariant? variant;
  final int quantity;
  final double priceAtAdd; // Price when added to cart
  final DateTime addedAt;
  final DateTime? updatedAt;

  CartItemModel({
    required this.id,
    required this.userId,
    required this.productId,
    required this.product,
    this.variantId,
    this.variant,
    required this.quantity,
    required this.priceAtAdd,
    required this.addedAt,
    this.updatedAt,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemModelToJson(this);

  // Computed properties
  double get currentPrice => variant?.price ?? product.price;
  double get itemTotal => currentPrice * quantity;
  bool get priceChanged => currentPrice != priceAtAdd;
  int get availableStock => variant?.stockQuantity ?? product.stockQuantity;
  bool get isInStock => availableStock > 0;
  bool get exceedsStock => quantity > availableStock;
  String get displayName => variant != null
      ? '${product.name} - ${variant!.name}'
      : product.name;

  CartItemModel copyWith({
    String? id,
    String? userId,
    String? productId,
    ProductModel? product,
    String? variantId,
    ProductVariant? variant,
    int? quantity,
    double? priceAtAdd,
    DateTime? addedAt,
    DateTime? updatedAt,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      productId: productId ?? this.productId,
      product: product ?? this.product,
      variantId: variantId ?? this.variantId,
      variant: variant ?? this.variant,
      quantity: quantity ?? this.quantity,
      priceAtAdd: priceAtAdd ?? this.priceAtAdd,
      addedAt: addedAt ?? this.addedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

@JsonSerializable()
class CartSummary {
  final List<CartItemModel> items;
  final double subtotal;
  final double discount;
  final double deliveryFee;
  final double tax;
  final double total;
  final int itemCount;
  final int uniqueItemCount;
  final String? appliedCouponCode;
  final double? couponDiscount;

  CartSummary({
    required this.items,
    required this.subtotal,
    this.discount = 0.0,
    this.deliveryFee = 0.0,
    this.tax = 0.0,
    required this.total,
    required this.itemCount,
    required this.uniqueItemCount,
    this.appliedCouponCode,
    this.couponDiscount,
  });

  factory CartSummary.fromJson(Map<String, dynamic> json) =>
      _$CartSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$CartSummaryToJson(this);

  bool get hasCoupon => appliedCouponCode != null;
  bool get isEmpty => items.isEmpty;
  double get totalDiscount => discount + (couponDiscount ?? 0.0);
  double get savings => totalDiscount;
}

@JsonSerializable()
class AddToCartRequest {
  final String productId;
  final String? variantId;
  final int quantity;

  AddToCartRequest({
    required this.productId,
    this.variantId,
    this.quantity = 1,
  });

  Map<String, dynamic> toJson() => _$AddToCartRequestToJson(this);
}

@JsonSerializable()
class UpdateCartItemRequest {
  final int quantity;

  UpdateCartItemRequest({required this.quantity});

  Map<String, dynamic> toJson() => _$UpdateCartItemRequestToJson(this);
}

@JsonSerializable()
class WishlistItemModel {
  final String id;
  final String userId;
  final String productId;
  final ProductModel product;
  final DateTime addedAt;

  WishlistItemModel({
    required this.id,
    required this.userId,
    required this.productId,
    required this.product,
    required this.addedAt,
  });

  factory WishlistItemModel.fromJson(Map<String, dynamic> json) =>
      _$WishlistItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$WishlistItemModelToJson(this);
}
