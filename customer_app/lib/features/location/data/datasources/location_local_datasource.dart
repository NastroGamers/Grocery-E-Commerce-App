import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/address_model.dart';

abstract class LocationLocalDataSource {
  Future<LocationCoordinates> getCurrentLocation();
  Future<bool> requestLocationPermission();
  Future<bool> isLocationServiceEnabled();
  Future<GeocodeResult> getAddressFromCoordinates(double latitude, double longitude);
  Future<void> saveLastKnownLocation(LocationCoordinates coordinates);
  Future<LocationCoordinates?> getLastKnownLocation();
  Future<void> saveSelectedAddress(AddressModel address);
  Future<AddressModel?> getSelectedAddress();
}

class LocationLocalDataSourceImpl implements LocationLocalDataSource {
  final SharedPreferences _sharedPreferences;

  LocationLocalDataSourceImpl(this._sharedPreferences);

  @override
  Future<LocationCoordinates> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      final coordinates = LocationCoordinates(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      // Save last known location
      await saveLastKnownLocation(coordinates);

      return coordinates;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> requestLocationPermission() async {
    try {
      final status = await Permission.location.request();
      return status.isGranted;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> isLocationServiceEnabled() async {
    try {
      return await Geolocator.isLocationServiceEnabled();
    } catch (e) {
      return false;
    }
  }

  @override
  Future<GeocodeResult> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isEmpty) {
        throw Exception('No address found for the given coordinates');
      }

      final placemark = placemarks.first;

      return GeocodeResult(
        formattedAddress: _formatAddress(placemark),
        street: placemark.street,
        subLocality: placemark.subLocality,
        city: placemark.locality ?? placemark.subAdministrativeArea ?? '',
        state: placemark.administrativeArea ?? '',
        pincode: placemark.postalCode,
        latitude: latitude,
        longitude: longitude,
      );
    } catch (e) {
      rethrow;
    }
  }

  String _formatAddress(Placemark placemark) {
    final parts = <String>[];

    if (placemark.street != null && placemark.street!.isNotEmpty) {
      parts.add(placemark.street!);
    }
    if (placemark.subLocality != null && placemark.subLocality!.isNotEmpty) {
      parts.add(placemark.subLocality!);
    }
    if (placemark.locality != null && placemark.locality!.isNotEmpty) {
      parts.add(placemark.locality!);
    }
    if (placemark.administrativeArea != null &&
        placemark.administrativeArea!.isNotEmpty) {
      parts.add(placemark.administrativeArea!);
    }
    if (placemark.postalCode != null && placemark.postalCode!.isNotEmpty) {
      parts.add(placemark.postalCode!);
    }

    return parts.join(', ');
  }

  @override
  Future<void> saveLastKnownLocation(LocationCoordinates coordinates) async {
    try {
      await _sharedPreferences.setString(
        'last_known_location',
        json.encode(coordinates.toJson()),
      );
    } catch (e) {
      // Silently fail - not critical
    }
  }

  @override
  Future<LocationCoordinates?> getLastKnownLocation() async {
    try {
      final data = _sharedPreferences.getString('last_known_location');
      if (data != null) {
        return LocationCoordinates.fromJson(json.decode(data));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveSelectedAddress(AddressModel address) async {
    try {
      await _sharedPreferences.setString(
        'selected_address',
        json.encode(address.toJson()),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AddressModel?> getSelectedAddress() async {
    try {
      final data = _sharedPreferences.getString('selected_address');
      if (data != null) {
        return AddressModel.fromJson(json.decode(data));
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
