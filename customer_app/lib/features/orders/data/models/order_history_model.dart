import 'package:json_annotation/json_annotation.dart';
import '../../../checkout/data/models/order_model.dart';

part 'order_history_model.g.dart';

@JsonSerializable()
class OrderHistoryResponse {
  final List<OrderModel> orders;
  final int total;
  final int page;
  final int limit;
  final bool hasMore;

  OrderHistoryResponse({
    required this.orders,
    required this.total,
    required this.page,
    required this.limit,
    required this.hasMore,
  });

  factory OrderHistoryResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderHistoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrderHistoryResponseToJson(this);
}

@JsonSerializable()
class ReorderRequest {
  final String orderId;
  final List<String>? excludeProductIds; // Products to exclude from reorder

  ReorderRequest({
    required this.orderId,
    this.excludeProductIds,
  });

  factory ReorderRequest.fromJson(Map<String, dynamic> json) =>
      _$ReorderRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ReorderRequestToJson(this);
}

@JsonSerializable()
class ReorderResponse {
  final bool success;
  final String message;
  final int itemsAdded;
  final int itemsUnavailable;
  final List<String>? unavailableProductNames;

  ReorderResponse({
    required this.success,
    required this.message,
    required this.itemsAdded,
    required this.itemsUnavailable,
    this.unavailableProductNames,
  });

  factory ReorderResponse.fromJson(Map<String, dynamic> json) =>
      _$ReorderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ReorderResponseToJson(this);
}

enum OrderFilterType {
  @JsonValue('all')
  all,
  @JsonValue('active')
  active,
  @JsonValue('delivered')
  delivered,
  @JsonValue('cancelled')
  cancelled,
}

@JsonSerializable()
class OrderFilter {
  final OrderFilterType type;
  final DateTime? startDate;
  final DateTime? endDate;

  OrderFilter({
    required this.type,
    this.startDate,
    this.endDate,
  });

  factory OrderFilter.fromJson(Map<String, dynamic> json) =>
      _$OrderFilterFromJson(json);

  Map<String, dynamic> toJson() => _$OrderFilterToJson(this);
}
