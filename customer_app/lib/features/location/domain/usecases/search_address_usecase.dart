import '../repositories/location_repository.dart';
import '../../data/models/address_model.dart';

class SearchAddressUseCase {
  final LocationRepository repository;

  SearchAddressUseCase(this.repository);

  Future<List<AddressSearchResult>> execute(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }
    return await repository.searchAddress(query);
  }
}
