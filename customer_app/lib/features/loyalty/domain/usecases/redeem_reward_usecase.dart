import '../repositories/loyalty_repository.dart';
import '../../data/models/loyalty_model.dart';

class RedeemRewardUseCase {
  final LoyaltyRepository repository;

  RedeemRewardUseCase(this.repository);

  Future<RedeemRewardResponse> call(RedeemRewardRequest request) async {
    return await repository.redeemReward(request);
  }
}
