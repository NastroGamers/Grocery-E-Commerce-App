import '../repositories/location_repository.dart';

class DeleteAddressUseCase {
  final LocationRepository repository;

  DeleteAddressUseCase(this.repository);

  Future<void> execute(String addressId) async {
    return await repository.deleteAddress(addressId);
  }
}
