import 'package:json_annotation/json_annotation.dart';
import '../../../checkout/data/models/order_model.dart';

part 'order_tracking_model.g.dart';

@JsonSerializable()
class LocationCoordinates {
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final double? accuracy; // in meters

  LocationCoordinates({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    this.accuracy,
  });

  factory LocationCoordinates.fromJson(Map<String, dynamic> json) =>
      _$LocationCoordinatesFromJson(json);

  Map<String, dynamic> toJson() => _$LocationCoordinatesToJson(this);
}

@JsonSerializable()
class DeliveryPersonModel {
  final String deliveryPersonId;
  final String name;
  final String phone;
  final String? photoUrl;
  final double? rating;
  final int? totalDeliveries;
  final String? vehicleType;
  final String? vehicleNumber;
  final bool isOnline;

  DeliveryPersonModel({
    required this.deliveryPersonId,
    required this.name,
    required this.phone,
    this.photoUrl,
    this.rating,
    this.totalDeliveries,
    this.vehicleType,
    this.vehicleNumber,
    required this.isOnline,
  });

  factory DeliveryPersonModel.fromJson(Map<String, dynamic> json) =>
      _$DeliveryPersonModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryPersonModelToJson(this);

  String get maskedPhone {
    // Mask phone number: 98******45
    if (phone.length >= 10) {
      return '${phone.substring(0, 2)}${'*' * 6}${phone.substring(phone.length - 2)}';
    }
    return phone;
  }

  String get ratingText => rating != null ? '${rating!.toStringAsFixed(1)} ★' : 'N/A';
}

@JsonSerializable()
class StatusHistoryItem {
  final OrderStatus status;
  final DateTime timestamp;
  final String? message;
  final String? updatedBy; // system, admin, delivery_person

  StatusHistoryItem({
    required this.status,
    required this.timestamp,
    this.message,
    this.updatedBy,
  });

  factory StatusHistoryItem.fromJson(Map<String, dynamic> json) =>
      _$StatusHistoryItemFromJson(json);

  Map<String, dynamic> toJson() => _$StatusHistoryItemToJson(this);

  String get statusLabel {
    switch (status) {
      case OrderStatus.pending:
        return 'Order Placed';
      case OrderStatus.confirmed:
        return 'Order Confirmed';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.packed:
        return 'Packed';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.returned:
        return 'Returned';
    }
  }
}

@JsonSerializable()
class TrackingUpdate {
  final String updateId;
  final String message;
  final DateTime timestamp;
  final LocationCoordinates? location;
  final String? imageUrl;

  TrackingUpdate({
    required this.updateId,
    required this.message,
    required this.timestamp,
    this.location,
    this.imageUrl,
  });

  factory TrackingUpdate.fromJson(Map<String, dynamic> json) =>
      _$TrackingUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$TrackingUpdateToJson(this);

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}

@JsonSerializable()
class OrderTrackingModel {
  final String orderId;
  final OrderStatus currentStatus;
  final List<StatusHistoryItem> statusHistory;
  final DateTime? estimatedDeliveryTime;
  final DateTime? actualDeliveryTime;
  final DeliveryPersonModel? deliveryPerson;
  final LocationCoordinates? currentLocation;
  final LocationCoordinates? deliveryLocation;
  final List<TrackingUpdate> trackingUpdates;
  final double? distanceRemaining; // in kilometers
  final int? timeRemaining; // in minutes
  final bool isLiveTrackingAvailable;

  OrderTrackingModel({
    required this.orderId,
    required this.currentStatus,
    required this.statusHistory,
    this.estimatedDeliveryTime,
    this.actualDeliveryTime,
    this.deliveryPerson,
    this.currentLocation,
    this.deliveryLocation,
    required this.trackingUpdates,
    this.distanceRemaining,
    this.timeRemaining,
    required this.isLiveTrackingAvailable,
  });

  factory OrderTrackingModel.fromJson(Map<String, dynamic> json) =>
      _$OrderTrackingModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderTrackingModelToJson(this);

  // Computed properties
  bool get isDelivered => currentStatus == OrderStatus.delivered;
  bool get isCancelled => currentStatus == OrderStatus.cancelled;
  bool get isOutForDelivery => currentStatus == OrderStatus.outForDelivery;
  bool get isActive =>
      !isDelivered && !isCancelled && currentStatus != OrderStatus.returned;

  bool get canContactDriver =>
      isOutForDelivery &&
      deliveryPerson != null &&
      deliveryPerson!.isOnline;

  bool get hasDeliveryPerson => deliveryPerson != null;

  bool get hasLiveLocation =>
      isLiveTrackingAvailable &&
      currentLocation != null &&
      isOutForDelivery;

  String get estimatedTimeText {
    if (timeRemaining != null) {
      if (timeRemaining! < 60) {
        return '$timeRemaining mins';
      } else {
        final hours = (timeRemaining! / 60).floor();
        final mins = timeRemaining! % 60;
        return '$hours hr ${mins > 0 ? "$mins mins" : ""}';
      }
    } else if (estimatedDeliveryTime != null) {
      final now = DateTime.now();
      final remaining = estimatedDeliveryTime!.difference(now);

      if (remaining.isNegative) {
        return 'Delayed';
      } else if (remaining.inMinutes < 60) {
        return '${remaining.inMinutes} mins';
      } else {
        return '${remaining.inHours} hr';
      }
    }
    return 'Calculating...';
  }

  String get distanceText {
    if (distanceRemaining != null) {
      if (distanceRemaining! < 1) {
        return '${(distanceRemaining! * 1000).toInt()} m';
      } else {
        return '${distanceRemaining!.toStringAsFixed(1)} km';
      }
    }
    return 'N/A';
  }

  double get trackingProgress {
    // Calculate progress based on status
    switch (currentStatus) {
      case OrderStatus.pending:
        return 0.0;
      case OrderStatus.confirmed:
        return 0.2;
      case OrderStatus.processing:
        return 0.4;
      case OrderStatus.packed:
        return 0.5;
      case OrderStatus.shipped:
        return 0.6;
      case OrderStatus.outForDelivery:
        return 0.8;
      case OrderStatus.delivered:
        return 1.0;
      case OrderStatus.cancelled:
      case OrderStatus.returned:
        return 0.0;
    }
  }
}

@JsonSerializable()
class LiveLocationUpdate {
  final String orderId;
  final LocationCoordinates location;
  final double? speed; // in km/h
  final String? status;

  LiveLocationUpdate({
    required this.orderId,
    required this.location,
    this.speed,
    this.status,
  });

  factory LiveLocationUpdate.fromJson(Map<String, dynamic> json) =>
      _$LiveLocationUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$LiveLocationUpdateToJson(this);
}

@JsonSerializable()
class ContactDriverRequest {
  final String orderId;
  final String contactType; // 'call' or 'message'
  final String? message;

  ContactDriverRequest({
    required this.orderId,
    required this.contactType,
    this.message,
  });

  factory ContactDriverRequest.fromJson(Map<String, dynamic> json) =>
      _$ContactDriverRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ContactDriverRequestToJson(this);
}

@JsonSerializable()
class ContactDriverResponse {
  final bool success;
  final String message;
  final String? contactNumber;
  final String? chatChannelId;

  ContactDriverResponse({
    required this.success,
    required this.message,
    this.contactNumber,
    this.chatChannelId,
  });

  factory ContactDriverResponse.fromJson(Map<String, dynamic> json) =>
      _$ContactDriverResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ContactDriverResponseToJson(this);
}
