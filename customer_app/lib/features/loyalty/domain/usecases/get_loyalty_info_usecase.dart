import '../repositories/loyalty_repository.dart';
import '../../data/models/loyalty_model.dart';

class GetLoyaltyInfoUseCase {
  final LoyaltyRepository repository;

  GetLoyaltyInfoUseCase(this.repository);

  Future<LoyaltyModel> call() async {
    return await repository.getLoyaltyInfo();
  }
}
