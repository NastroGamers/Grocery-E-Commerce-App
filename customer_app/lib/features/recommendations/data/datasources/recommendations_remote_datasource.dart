import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/recommendation_model.dart';

part 'recommendations_remote_datasource.g.dart';

@RestApi()
abstract class RecommendationsRemoteDataSource {
  factory RecommendationsRemoteDataSource(Dio dio, {String baseUrl}) =
      _RecommendationsRemoteDataSource;

  @GET('/recommendations/personalized')
  Future<RecommendationsResponse> getPersonalizedRecommendations(
    @Query('limit') int limit,
  );

  @GET('/recommendations/similar/{productId}')
  Future<RecommendationsResponse> getSimilarProducts(
    @Path('productId') String productId,
    @Query('limit') int limit,
  );

  @GET('/recommendations/frequently-bought-together/{productId}')
  Future<RecommendationsResponse> getFrequentlyBoughtTogether(
    @Path('productId') String productId,
    @Query('limit') int limit,
  );

  @GET('/recommendations/trending')
  Future<RecommendationsResponse> getTrendingProducts(
    @Query('limit') int limit,
  );

  @GET('/recommendations/category/{categoryId}')
  Future<RecommendationsResponse> getCategoryBasedRecommendations(
    @Path('categoryId') String categoryId,
    @Query('limit') int limit,
  );

  @POST('/recommendations/track')
  Future<void> trackInteraction(
    @Body() Map<String, dynamic> data,
  );
}
