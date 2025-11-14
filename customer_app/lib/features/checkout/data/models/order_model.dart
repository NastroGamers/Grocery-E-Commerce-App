import 'package:json_annotation/json_annotation.dart';
import '../../../location/data/models/address_model.dart';
import '../../../delivery/data/models/delivery_slot_model.dart';
import '../../../cart/data/models/cart_model.dart';

part 'order_model.g.dart';

enum PaymentMethod {
  @JsonValue('cod')
  cod,
  @JsonValue('razorpay')
  razorpay,
  @JsonValue('stripe')
  stripe,
  @JsonValue('upi')
  upi,
  @JsonValue('wallet')
  wallet,
}

enum PaymentStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('processing')
  processing,
  @JsonValue('completed')
  completed,
  @JsonValue('failed')
  failed,
  @JsonValue('refunded')
  refunded,
}

enum OrderStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('confirmed')
  confirmed,
  @JsonValue('processing')
  processing,
  @JsonValue('packed')
  packed,
  @JsonValue('shipped')
  shipped,
  @JsonValue('out_for_delivery')
  outForDelivery,
  @JsonValue('delivered')
  delivered,
  @JsonValue('cancelled')
  cancelled,
  @JsonValue('returned')
  returned,
}

@JsonSerializable()
class OrderItemModel {
  final String productId;
  final String productName;
  final String? productImage;
  final int quantity;
  final double priceAtOrder; // Price when order was placed
  final String? variantId;
  final String? variantName;

  OrderItemModel({
    required this.productId,
    required this.productName,
    this.productImage,
    required this.quantity,
    required this.priceAtOrder,
    this.variantId,
    this.variantName,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemModelToJson(this);

  factory OrderItemModel.fromCartItem(CartItemModel cartItem) {
    return OrderItemModel(
      productId: cartItem.productId,
      productName: cartItem.product.name,
      productImage: cartItem.product.images.isNotEmpty
          ? cartItem.product.images.first
          : null,
      quantity: cartItem.quantity,
      priceAtOrder: cartItem.variant?.price ?? cartItem.product.price,
      variantId: cartItem.variant?.variantId,
      variantName: cartItem.variant?.name,
    );
  }

  double get itemTotal => priceAtOrder * quantity;
}

@JsonSerializable()
class OrderModel {
  final String orderId;
  final String userId;
  final List<OrderItemModel> items;
  final AddressModel deliveryAddress;
  final DeliverySlotModel deliverySlot;
  final DateTime deliveryDate;
  final PaymentMethod paymentMethod;
  final PaymentStatus paymentStatus;
  final OrderStatus orderStatus;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double discount;
  final double total;
  final String? appliedCouponCode;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? paymentTransactionId;
  final String? trackingNumber;
  final String? cancelReason;
  final String? deliveryInstructions;

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.items,
    required this.deliveryAddress,
    required this.deliverySlot,
    required this.deliveryDate,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.orderStatus,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    required this.discount,
    required this.total,
    this.appliedCouponCode,
    required this.createdAt,
    this.updatedAt,
    this.paymentTransactionId,
    this.trackingNumber,
    this.cancelReason,
    this.deliveryInstructions,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
  int get uniqueItemCount => items.length;

  bool get canCancel =>
      orderStatus == OrderStatus.pending ||
      orderStatus == OrderStatus.confirmed;

  bool get canTrack =>
      orderStatus != OrderStatus.pending &&
      orderStatus != OrderStatus.cancelled;

  bool get isDelivered => orderStatus == OrderStatus.delivered;
  bool get isCancelled => orderStatus == OrderStatus.cancelled;
  bool get isPending => orderStatus == OrderStatus.pending;
}

@JsonSerializable()
class CreateOrderRequest {
  final List<OrderItemModel> items;
  final String deliveryAddressId;
  final String deliverySlotId;
  final DateTime deliveryDate;
  final PaymentMethod paymentMethod;
  final String? appliedCouponCode;
  final String? deliveryInstructions;

  CreateOrderRequest({
    required this.items,
    required this.deliveryAddressId,
    required this.deliverySlotId,
    required this.deliveryDate,
    required this.paymentMethod,
    this.appliedCouponCode,
    this.deliveryInstructions,
  });

  factory CreateOrderRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateOrderRequestToJson(this);
}

@JsonSerializable()
class CreateOrderResponse {
  final OrderModel order;
  final String? paymentGatewayOrderId; // For Razorpay/Stripe
  final String? paymentGatewayKey; // API key for client-side payment
  final Map<String, dynamic>? paymentMetadata;

  CreateOrderResponse({
    required this.order,
    this.paymentGatewayOrderId,
    this.paymentGatewayKey,
    this.paymentMetadata,
  });

  factory CreateOrderResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateOrderResponseToJson(this);
}

@JsonSerializable()
class OrderSummary {
  final List<OrderItemModel> items;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double discount;
  final double total;
  final String? appliedCouponCode;

  OrderSummary({
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    required this.discount,
    required this.total,
    this.appliedCouponCode,
  });

  factory OrderSummary.fromJson(Map<String, dynamic> json) =>
      _$OrderSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$OrderSummaryToJson(this);

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
  int get uniqueItemCount => items.length;

  double get savingsAmount => discount;
  bool get hasCoupon => appliedCouponCode != null && appliedCouponCode!.isNotEmpty;
}

@JsonSerializable()
class PaymentInitiateRequest {
  final String orderId;
  final double amount;
  final PaymentMethod paymentMethod;
  final String currency;
  final Map<String, dynamic>? metadata;

  PaymentInitiateRequest({
    required this.orderId,
    required this.amount,
    required this.paymentMethod,
    this.currency = 'INR',
    this.metadata,
  });

  factory PaymentInitiateRequest.fromJson(Map<String, dynamic> json) =>
      _$PaymentInitiateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentInitiateRequestToJson(this);
}

@JsonSerializable()
class PaymentInitiateResponse {
  final String paymentId;
  final String orderId;
  final String? gatewayOrderId; // Razorpay/Stripe order ID
  final String? gatewayKey; // Public API key
  final double amount;
  final String currency;
  final Map<String, dynamic>? gatewayMetadata;

  PaymentInitiateResponse({
    required this.paymentId,
    required this.orderId,
    this.gatewayOrderId,
    this.gatewayKey,
    required this.amount,
    required this.currency,
    this.gatewayMetadata,
  });

  factory PaymentInitiateResponse.fromJson(Map<String, dynamic> json) =>
      _$PaymentInitiateResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentInitiateResponseToJson(this);
}

@JsonSerializable()
class PaymentVerifyRequest {
  final String orderId;
  final String paymentId;
  final String? gatewayPaymentId;
  final String? gatewaySignature;
  final PaymentStatus status;
  final String? errorMessage;

  PaymentVerifyRequest({
    required this.orderId,
    required this.paymentId,
    this.gatewayPaymentId,
    this.gatewaySignature,
    required this.status,
    this.errorMessage,
  });

  factory PaymentVerifyRequest.fromJson(Map<String, dynamic> json) =>
      _$PaymentVerifyRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentVerifyRequestToJson(this);
}

@JsonSerializable()
class PaymentVerifyResponse {
  final bool success;
  final String message;
  final OrderModel order;
  final PaymentStatus paymentStatus;

  PaymentVerifyResponse({
    required this.success,
    required this.message,
    required this.order,
    required this.paymentStatus,
  });

  factory PaymentVerifyResponse.fromJson(Map<String, dynamic> json) =>
      _$PaymentVerifyResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentVerifyResponseToJson(this);
}

@JsonSerializable()
class CheckStockAvailabilityRequest {
  final List<CheckStockItem> items;

  CheckStockAvailabilityRequest({required this.items});

  factory CheckStockAvailabilityRequest.fromJson(Map<String, dynamic> json) =>
      _$CheckStockAvailabilityRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CheckStockAvailabilityRequestToJson(this);
}

@JsonSerializable()
class CheckStockItem {
  final String productId;
  final int quantity;
  final String? variantId;

  CheckStockItem({
    required this.productId,
    required this.quantity,
    this.variantId,
  });

  factory CheckStockItem.fromJson(Map<String, dynamic> json) =>
      _$CheckStockItemFromJson(json);

  Map<String, dynamic> toJson() => _$CheckStockItemToJson(this);
}

@JsonSerializable()
class CheckStockAvailabilityResponse {
  final bool allAvailable;
  final List<StockAvailabilityItem> items;
  final String? message;

  CheckStockAvailabilityResponse({
    required this.allAvailable,
    required this.items,
    this.message,
  });

  factory CheckStockAvailabilityResponse.fromJson(Map<String, dynamic> json) =>
      _$CheckStockAvailabilityResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CheckStockAvailabilityResponseToJson(this);

  List<StockAvailabilityItem> get unavailableItems =>
      items.where((item) => !item.isAvailable).toList();
}

@JsonSerializable()
class StockAvailabilityItem {
  final String productId;
  final String productName;
  final bool isAvailable;
  final int requestedQuantity;
  final int availableQuantity;
  final String? message;

  StockAvailabilityItem({
    required this.productId,
    required this.productName,
    required this.isAvailable,
    required this.requestedQuantity,
    required this.availableQuantity,
    this.message,
  });

  factory StockAvailabilityItem.fromJson(Map<String, dynamic> json) =>
      _$StockAvailabilityItemFromJson(json);

  Map<String, dynamic> toJson() => _$StockAvailabilityItemToJson(this);
}
