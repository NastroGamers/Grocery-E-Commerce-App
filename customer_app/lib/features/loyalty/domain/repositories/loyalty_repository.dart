import '../../data/models/loyalty_model.dart';

abstract class LoyaltyRepository {
  /// Get user's loyalty information
  Future<LoyaltyModel> getLoyaltyInfo();

  /// Get points transaction history
  Future<List<PointsTransactionModel>> getTransactionHistory({
    int page = 1,
    int limit = 20,
  });

  /// Get available rewards
  Future<List<RewardModel>> getAvailableRewards();

  /// Redeem reward
  Future<RedeemRewardResponse> redeemReward(RedeemRewardRequest request);

  /// Get tier information
  Future<Map<String, dynamic>> getTierInfo();
}
