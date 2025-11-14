import '../../../../core/network/dio_client.dart';
import '../../../../core/config/app_config.dart';
import '../models/address_model.dart';

abstract class LocationRemoteDataSource {
  Future<List<AddressModel>> getUserAddresses(String userId);
  Future<AddressModel> createAddress(CreateAddressRequest request);
  Future<AddressModel> updateAddress(String addressId, UpdateAddressRequest request);
  Future<void> deleteAddress(String addressId);
  Future<AddressModel> setDefaultAddress(String addressId);
  Future<GeocodeResult> reverseGeocode(double latitude, double longitude);
  Future<List<AddressSearchResult>> searchAddress(String query);
  Future<GeocodeResult> getPlaceDetails(String placeId);
  Future<bool> checkServiceability(double latitude, double longitude);
}

class LocationRemoteDataSourceImpl implements LocationRemoteDataSource {
  final DioClient _dioClient;

  LocationRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<AddressModel>> getUserAddresses(String userId) async {
    try {
      final response = await _dioClient.get(
        '${AppConfig.userEndpoint}/$userId${AppConfig.addressEndpoint}',
      );

      final List<dynamic> data = response.data['data'] as List;
      return data.map((json) => AddressModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AddressModel> createAddress(CreateAddressRequest request) async {
    try {
      final response = await _dioClient.post(
        AppConfig.addressEndpoint,
        data: request.toJson(),
      );
      return AddressModel.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AddressModel> updateAddress(
    String addressId,
    UpdateAddressRequest request,
  ) async {
    try {
      final response = await _dioClient.put(
        '${AppConfig.addressEndpoint}/$addressId',
        data: request.toJson(),
      );
      return AddressModel.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteAddress(String addressId) async {
    try {
      await _dioClient.delete('${AppConfig.addressEndpoint}/$addressId');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AddressModel> setDefaultAddress(String addressId) async {
    try {
      final response = await _dioClient.put(
        '${AppConfig.addressEndpoint}/$addressId/set-default',
      );
      return AddressModel.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<GeocodeResult> reverseGeocode(
    double latitude,
    double longitude,
  ) async {
    try {
      final response = await _dioClient.get(
        '/geocode/reverse',
        queryParameters: {
          'lat': latitude,
          'lng': longitude,
        },
      );
      return GeocodeResult.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<AddressSearchResult>> searchAddress(String query) async {
    try {
      final response = await _dioClient.get(
        '/geocode/search',
        queryParameters: {'q': query},
      );

      final List<dynamic> data = response.data['data'] as List;
      return data.map((json) => AddressSearchResult.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<GeocodeResult> getPlaceDetails(String placeId) async {
    try {
      final response = await _dioClient.get(
        '/geocode/place/$placeId',
      );
      return GeocodeResult.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> checkServiceability(double latitude, double longitude) async {
    try {
      final response = await _dioClient.get(
        '/delivery/check-serviceability',
        queryParameters: {
          'lat': latitude,
          'lng': longitude,
        },
      );
      return response.data['data']['serviceable'] as bool;
    } catch (e) {
      rethrow;
    }
  }
}
