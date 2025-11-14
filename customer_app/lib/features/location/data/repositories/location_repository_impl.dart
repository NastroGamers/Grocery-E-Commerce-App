import '../../domain/repositories/location_repository.dart';
import '../datasources/location_local_datasource.dart';
import '../datasources/location_remote_datasource.dart';
import '../models/address_model.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationLocalDataSource localDataSource;
  final LocationRemoteDataSource remoteDataSource;

  LocationRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<LocationCoordinates> getCurrentLocation() async {
    try {
      return await localDataSource.getCurrentLocation();
    } catch (e) {
      // If GPS fails, try to get last known location
      final lastKnown = await localDataSource.getLastKnownLocation();
      if (lastKnown != null) {
        return lastKnown;
      }
      rethrow;
    }
  }

  @override
  Future<bool> requestLocationPermission() async {
    return await localDataSource.requestLocationPermission();
  }

  @override
  Future<bool> isLocationServiceEnabled() async {
    return await localDataSource.isLocationServiceEnabled();
  }

  @override
  Future<GeocodeResult> reverseGeocode(
    double latitude,
    double longitude,
  ) async {
    try {
      // Try remote API first (more accurate)
      return await remoteDataSource.reverseGeocode(latitude, longitude);
    } catch (e) {
      // Fallback to local geocoding
      return await localDataSource.getAddressFromCoordinates(
        latitude,
        longitude,
      );
    }
  }

  @override
  Future<List<AddressSearchResult>> searchAddress(String query) async {
    return await remoteDataSource.searchAddress(query);
  }

  @override
  Future<GeocodeResult> getPlaceDetails(String placeId) async {
    return await remoteDataSource.getPlaceDetails(placeId);
  }

  @override
  Future<List<AddressModel>> getUserAddresses(String userId) async {
    return await remoteDataSource.getUserAddresses(userId);
  }

  @override
  Future<AddressModel> createAddress(CreateAddressRequest request) async {
    final address = await remoteDataSource.createAddress(request);

    // If this is set as default, save it locally
    if (request.isDefault) {
      await localDataSource.saveSelectedAddress(address);
    }

    return address;
  }

  @override
  Future<AddressModel> updateAddress(
    String addressId,
    UpdateAddressRequest request,
  ) async {
    final address = await remoteDataSource.updateAddress(addressId, request);

    // If this is set as default, save it locally
    if (request.isDefault == true) {
      await localDataSource.saveSelectedAddress(address);
    }

    return address;
  }

  @override
  Future<void> deleteAddress(String addressId) async {
    await remoteDataSource.deleteAddress(addressId);

    // Clear local selection if this was the selected address
    final selected = await localDataSource.getSelectedAddress();
    if (selected?.id == addressId) {
      await localDataSource.saveSelectedAddress(
        selected!.copyWith(isDefault: false),
      );
    }
  }

  @override
  Future<AddressModel> setDefaultAddress(String addressId) async {
    final address = await remoteDataSource.setDefaultAddress(addressId);
    await localDataSource.saveSelectedAddress(address);
    return address;
  }

  @override
  Future<void> saveSelectedAddress(AddressModel address) async {
    await localDataSource.saveSelectedAddress(address);
  }

  @override
  Future<AddressModel?> getSelectedAddress() async {
    return await localDataSource.getSelectedAddress();
  }

  @override
  Future<LocationCoordinates?> getLastKnownLocation() async {
    return await localDataSource.getLastKnownLocation();
  }

  @override
  Future<bool> checkServiceability(double latitude, double longitude) async {
    return await remoteDataSource.checkServiceability(latitude, longitude);
  }
}
