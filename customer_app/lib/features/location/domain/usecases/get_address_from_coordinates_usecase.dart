import '../repositories/location_repository.dart';
import '../../data/models/address_model.dart';

class GetAddressFromCoordinatesUseCase {
  final LocationRepository repository;

  GetAddressFromCoordinatesUseCase(this.repository);

  Future<GeocodeResult> execute(double latitude, double longitude) async {
    return await repository.reverseGeocode(latitude, longitude);
  }
}
