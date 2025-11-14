import '../repositories/location_repository.dart';
import '../../data/models/address_model.dart';

class GetUserAddressesUseCase {
  final LocationRepository repository;

  GetUserAddressesUseCase(this.repository);

  Future<List<AddressModel>> execute(String userId) async {
    return await repository.getUserAddresses(userId);
  }
}
