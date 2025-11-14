import 'package:json_annotation/json_annotation.dart';

part 'delivery_person_auth_model.g.dart';

@JsonSerializable()
class DeliveryPersonAuthModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? profilePicture;
  final String status; // 'active', 'inactive', 'suspended'
  final String vehicleType; // 'bike', 'scooter', 'car'
  final String? vehicleNumber;
  final String? licenseNumber;
  final bool isVerified;
  final double rating;
  final int totalDeliveries;
  final String? currentOrderId;

  DeliveryPersonAuthModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profilePicture,
    this.status = 'active',
    required this.vehicleType,
    this.vehicleNumber,
    this.licenseNumber,
    this.isVerified = false,
    this.rating = 5.0,
    this.totalDeliveries = 0,
    this.currentOrderId,
  });

  factory DeliveryPersonAuthModel.fromJson(Map<String, dynamic> json) =>
      _$DeliveryPersonAuthModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryPersonAuthModelToJson(this);
}

@JsonSerializable()
class DeliveryAuthResponse {
  final DeliveryPersonAuthModel user;
  final String token;
  final String refreshToken;

  DeliveryAuthResponse({
    required this.user,
    required this.token,
    required this.refreshToken,
  });

  factory DeliveryAuthResponse.fromJson(Map<String, dynamic> json) =>
      _$DeliveryAuthResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryAuthResponseToJson(this);
}
