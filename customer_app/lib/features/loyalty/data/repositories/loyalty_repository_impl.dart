import '../../domain/repositories/loyalty_repository.dart';
import '../datasources/loyalty_remote_datasource.dart';
import '../models/loyalty_model.dart';

class LoyaltyRepositoryImpl implements LoyaltyRepository {
  final LoyaltyRemoteDataSource remoteDataSource;

  LoyaltyRepositoryImpl(this.remoteDataSource);

  @override
  Future<LoyaltyModel> getLoyaltyInfo() async {
    try {
      return await remoteDataSource.getLoyaltyInfo();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PointsTransactionModel>> getTransactionHistory({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      return await remoteDataSource.getTransactionHistory(page, limit);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<RewardModel>> getAvailableRewards() async {
    try {
      return await remoteDataSource.getAvailableRewards();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<RedeemRewardResponse> redeemReward(RedeemRewardRequest request) async {
    try {
      return await remoteDataSource.redeemReward(request);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getTierInfo() async {
    try {
      return await remoteDataSource.getTierInfo();
    } catch (e) {
      rethrow;
    }
  }
}
