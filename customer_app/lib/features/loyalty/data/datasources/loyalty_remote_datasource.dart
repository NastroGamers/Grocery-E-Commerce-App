import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/loyalty_model.dart';

part 'loyalty_remote_datasource.g.dart';

@RestApi()
abstract class LoyaltyRemoteDataSource {
  factory LoyaltyRemoteDataSource(Dio dio, {String baseUrl}) =
      _LoyaltyRemoteDataSource;

  @GET('/loyalty/info')
  Future<LoyaltyModel> getLoyaltyInfo();

  @GET('/loyalty/transactions')
  Future<List<PointsTransactionModel>> getTransactionHistory(
    @Query('page') int page,
    @Query('limit') int limit,
  );

  @GET('/loyalty/rewards')
  Future<List<RewardModel>> getAvailableRewards();

  @POST('/loyalty/redeem')
  Future<RedeemRewardResponse> redeemReward(
    @Body() RedeemRewardRequest request,
  );

  @GET('/loyalty/tiers')
  Future<Map<String, dynamic>> getTierInfo();
}
