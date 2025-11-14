import '../../data/models/address_model.dart';

abstract class LocationRepository {
  // Current Location
  Future<LocationCoordinates> getCurrentLocation();
  Future<bool> requestLocationPermission();
  Future<bool> isLocationServiceEnabled();

  // Geocoding
  Future<GeocodeResult> reverseGeocode(double latitude, double longitude);
  Future<List<AddressSearchResult>> searchAddress(String query);
  Future<GeocodeResult> getPlaceDetails(String placeId);

  // Address Management
  Future<List<AddressModel>> getUserAddresses(String userId);
  Future<AddressModel> createAddress(CreateAddressRequest request);
  Future<AddressModel> updateAddress(String addressId, UpdateAddressRequest request);
  Future<void> deleteAddress(String addressId);
  Future<AddressModel> setDefaultAddress(String addressId);

  // Local Storage
  Future<void> saveSelectedAddress(AddressModel address);
  Future<AddressModel?> getSelectedAddress();
  Future<LocationCoordinates?> getLastKnownLocation();

  // Serviceability
  Future<bool> checkServiceability(double latitude, double longitude);
}
