import 'package:json_annotation/json_annotation.dart';

part 'address_model.g.dart';

@JsonSerializable()
class AddressModel {
  final String id;
  final String userId;
  final String label; // 'Home', 'Work', 'Other'
  final double latitude;
  final double longitude;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String state;
  final String pincode;
  final String? landmark;
  final String? instructions;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime? updatedAt;

  AddressModel({
    required this.id,
    required this.userId,
    required this.label,
    required this.latitude,
    required this.longitude,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.state,
    required this.pincode,
    this.landmark,
    this.instructions,
    this.isDefault = false,
    required this.createdAt,
    this.updatedAt,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddressModelToJson(this);

  String get fullAddress {
    final parts = [
      addressLine1,
      if (addressLine2 != null) addressLine2,
      if (landmark != null) landmark,
      city,
      state,
      pincode,
    ];
    return parts.join(', ');
  }

  String get shortAddress {
    return '$addressLine1, $city';
  }

  AddressModel copyWith({
    String? id,
    String? userId,
    String? label,
    double? latitude,
    double? longitude,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? pincode,
    String? landmark,
    String? instructions,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AddressModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      label: label ?? this.label,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      landmark: landmark ?? this.landmark,
      instructions: instructions ?? this.instructions,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

@JsonSerializable()
class LocationCoordinates {
  final double latitude;
  final double longitude;

  LocationCoordinates({
    required this.latitude,
    required this.longitude,
  });

  factory LocationCoordinates.fromJson(Map<String, dynamic> json) =>
      _$LocationCoordinatesFromJson(json);

  Map<String, dynamic> toJson() => _$LocationCoordinatesToJson(this);
}

@JsonSerializable()
class GeocodeResult {
  final String formattedAddress;
  final String? street;
  final String? subLocality;
  final String city;
  final String state;
  final String? pincode;
  final double latitude;
  final double longitude;

  GeocodeResult({
    required this.formattedAddress,
    this.street,
    this.subLocality,
    required this.city,
    required this.state,
    this.pincode,
    required this.latitude,
    required this.longitude,
  });

  factory GeocodeResult.fromJson(Map<String, dynamic> json) =>
      _$GeocodeResultFromJson(json);

  Map<String, dynamic> toJson() => _$GeocodeResultToJson(this);
}

@JsonSerializable()
class AddressSearchResult {
  final String placeId;
  final String description;
  final String mainText;
  final String secondaryText;

  AddressSearchResult({
    required this.placeId,
    required this.description,
    required this.mainText,
    required this.secondaryText,
  });

  factory AddressSearchResult.fromJson(Map<String, dynamic> json) =>
      _$AddressSearchResultFromJson(json);

  Map<String, dynamic> toJson() => _$AddressSearchResultToJson(this);
}

// Request models
@JsonSerializable()
class CreateAddressRequest {
  final String label;
  final double latitude;
  final double longitude;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String state;
  final String pincode;
  final String? landmark;
  final String? instructions;
  final bool isDefault;

  CreateAddressRequest({
    required this.label,
    required this.latitude,
    required this.longitude,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.state,
    required this.pincode,
    this.landmark,
    this.instructions,
    this.isDefault = false,
  });

  Map<String, dynamic> toJson() => _$CreateAddressRequestToJson(this);
}

@JsonSerializable()
class UpdateAddressRequest {
  final String? label;
  final double? latitude;
  final double? longitude;
  final String? addressLine1;
  final String? addressLine2;
  final String? city;
  final String? state;
  final String? pincode;
  final String? landmark;
  final String? instructions;
  final bool? isDefault;

  UpdateAddressRequest({
    this.label,
    this.latitude,
    this.longitude,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.pincode,
    this.landmark,
    this.instructions,
    this.isDefault,
  });

  Map<String, dynamic> toJson() => _$UpdateAddressRequestToJson(this);
}
