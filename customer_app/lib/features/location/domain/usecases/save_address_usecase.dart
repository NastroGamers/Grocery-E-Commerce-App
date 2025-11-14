import '../repositories/location_repository.dart';
import '../../data/models/address_model.dart';

class SaveAddressUseCase {
  final LocationRepository repository;

  SaveAddressUseCase(this.repository);

  Future<AddressModel> execute(CreateAddressRequest request) async {
    // Check serviceability before saving
    final isServiceable = await repository.checkServiceability(
      request.latitude,
      request.longitude,
    );

    if (!isServiceable) {
      throw Exception(
        'Sorry, we do not deliver to this location yet. Please try a different address.',
      );
    }

    return await repository.createAddress(request);
  }
}
