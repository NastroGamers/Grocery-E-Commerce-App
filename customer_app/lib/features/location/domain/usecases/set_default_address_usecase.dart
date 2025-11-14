import '../repositories/location_repository.dart';
import '../../data/models/address_model.dart';

class SetDefaultAddressUseCase {
  final LocationRepository repository;

  SetDefaultAddressUseCase(this.repository);

  Future<AddressModel> execute(String addressId) async {
    return await repository.setDefaultAddress(addressId);
  }
}
