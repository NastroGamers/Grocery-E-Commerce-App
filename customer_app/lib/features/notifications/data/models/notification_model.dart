import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

enum NotificationType {
  @JsonValue('order_placed')
  orderPlaced,
  @JsonValue('order_confirmed')
  orderConfirmed,
  @JsonValue('order_shipped')
  orderShipped,
  @JsonValue('order_delivered')
  orderDelivered,
  @JsonValue('order_cancelled')
  orderCancelled,
  @JsonValue('payment_success')
  paymentSuccess,
  @JsonValue('payment_failed')
  paymentFailed,
  @JsonValue('delivery_nearby')
  deliveryNearby,
  @JsonValue('offer')
  offer,
  @JsonValue('promotion')
  promotion,
  @JsonValue('general')
  general,
}

@JsonSerializable()
class NotificationModel {
  final String notificationId;
  final String title;
  final String body;
  final NotificationType type;
  final DateTime createdAt;
  final bool isRead;
  final String? imageUrl;
  final Map<String, dynamic>? data; // Additional data like orderId, offerId
  final String? actionUrl;

  NotificationModel({
    required this.notificationId,
    required this.title,
    required this.body,
    required this.type,
    required this.createdAt,
    required this.isRead,
    this.imageUrl,
    this.data,
    this.actionUrl,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
    }
  }
}

@JsonSerializable()
class NotificationListResponse {
  final List<NotificationModel> notifications;
  final int unreadCount;
  final int total;
  final bool hasMore;

  NotificationListResponse({
    required this.notifications,
    required this.unreadCount,
    required this.total,
    required this.hasMore,
  });

  factory NotificationListResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationListResponseToJson(this);
}

@JsonSerializable()
class UpdateFCMTokenRequest {
  final String fcmToken;
  final String deviceId;
  final String platform; // 'android' or 'ios'

  UpdateFCMTokenRequest({
    required this.fcmToken,
    required this.deviceId,
    required this.platform,
  });

  factory UpdateFCMTokenRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateFCMTokenRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateFCMTokenRequestToJson(this);
}

@JsonSerializable()
class NotificationSettings {
  final bool orderUpdates;
  final bool promotions;
  final bool newArrivals;
  final bool priceDrops;
  final bool deliveryReminders;

  NotificationSettings({
    required this.orderUpdates,
    required this.promotions,
    required this.newArrivals,
    required this.priceDrops,
    required this.deliveryReminders,
  });

  factory NotificationSettings.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationSettingsToJson(this);
}
