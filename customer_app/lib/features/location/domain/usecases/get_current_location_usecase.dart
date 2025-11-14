import '../repositories/location_repository.dart';
import '../../data/models/address_model.dart';

class GetCurrentLocationUseCase {
  final LocationRepository repository;

  GetCurrentLocationUseCase(this.repository);

  Future<LocationCoordinates> execute() async {
    // Check if location service is enabled
    final isEnabled = await repository.isLocationServiceEnabled();
    if (!isEnabled) {
      throw Exception('Please enable location services');
    }

    // Request permission if needed
    final hasPermission = await repository.requestLocationPermission();
    if (!hasPermission) {
      throw Exception('Location permission denied');
    }

    // Get current location
    return await repository.getCurrentLocation();
  }
}
