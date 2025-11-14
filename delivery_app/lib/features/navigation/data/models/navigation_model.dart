import 'package:json_annotation/json_annotation.dart';

part 'navigation_model.g.dart';

@JsonSerializable()
class NavigationRouteModel {
  final String orderId;
  final double originLat;
  final double originLng;
  final double destinationLat;
  final double destinationLng;
  final double distance; // in meters
  final int duration; // in seconds
  final String polyline;
  final List<RouteStep>? steps;

  NavigationRouteModel({
    required this.orderId,
    required this.originLat,
    required this.originLng,
    required this.destinationLat,
    required this.destinationLng,
    required this.distance,
    required this.duration,
    required this.polyline,
    this.steps,
  });

  factory NavigationRouteModel.fromJson(Map<String, dynamic> json) =>
      _$NavigationRouteModelFromJson(json);

  Map<String, dynamic> toJson() => _$NavigationRouteModelToJson(this);

  String get formattedDistance {
    if (distance < 1000) return '${distance.toInt()} m';
    return '${(distance / 1000).toStringAsFixed(1)} km';
  }

  String get formattedDuration {
    final minutes = (duration / 60).round();
    if (minutes < 60) return '$minutes min';
    final hours = (minutes / 60).floor();
    final remainingMinutes = minutes % 60;
    return '$hours h $remainingMinutes min';
  }
}

@JsonSerializable()
class RouteStep {
  final double lat;
  final double lng;
  final String instruction;
  final double distance;
  final int duration;

  RouteStep({
    required this.lat,
    required this.lng,
    required this.instruction,
    required this.distance,
    required this.duration,
  });

  factory RouteStep.fromJson(Map<String, dynamic> json) =>
      _$RouteStepFromJson(json);

  Map<String, dynamic> toJson() => _$RouteStepToJson(this);
}

@JsonSerializable()
class LocationUpdateModel {
  final double lat;
  final double lng;
  final DateTime timestamp;
  final double? speed;
  final double? heading;
  final String? orderId;

  LocationUpdateModel({
    required this.lat,
    required this.lng,
    required this.timestamp,
    this.speed,
    this.heading,
    this.orderId,
  });

  factory LocationUpdateModel.fromJson(Map<String, dynamic> json) =>
      _$LocationUpdateModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocationUpdateModelToJson(this);
}

@JsonSerializable()
class AvailabilityStatusModel {
  final bool isAvailable;
  final DateTime lastToggleAt;
  final String? currentOrderId;
  final double? currentLat;
  final double? currentLng;

  AvailabilityStatusModel({
    required this.isAvailable,
    required this.lastToggleAt,
    this.currentOrderId,
    this.currentLat,
    this.currentLng,
  });

  factory AvailabilityStatusModel.fromJson(Map<String, dynamic> json) =>
      _$AvailabilityStatusModelFromJson(json);

  Map<String, dynamic> toJson() => _$AvailabilityStatusModelToJson(this);
}
