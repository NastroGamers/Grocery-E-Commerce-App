import '../../domain/repositories/recommendations_repository.dart';
import '../datasources/recommendations_remote_datasource.dart';
import '../models/recommendation_model.dart';

class RecommendationsRepositoryImpl implements RecommendationsRepository {
  final RecommendationsRemoteDataSource remoteDataSource;

  RecommendationsRepositoryImpl(this.remoteDataSource);

  @override
  Future<RecommendationsResponse> getPersonalizedRecommendations({
    int limit = 10,
  }) async {
    try {
      return await remoteDataSource.getPersonalizedRecommendations(limit);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<RecommendationsResponse> getSimilarProducts({
    required String productId,
    int limit = 10,
  }) async {
    try {
      return await remoteDataSource.getSimilarProducts(productId, limit);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<RecommendationsResponse> getFrequentlyBoughtTogether({
    required String productId,
    int limit = 5,
  }) async {
    try {
      return await remoteDataSource.getFrequentlyBoughtTogether(
        productId,
        limit,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<RecommendationsResponse> getTrendingProducts({
    int limit = 10,
  }) async {
    try {
      return await remoteDataSource.getTrendingProducts(limit);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<RecommendationsResponse> getCategoryBasedRecommendations({
    required String categoryId,
    int limit = 10,
  }) async {
    try {
      return await remoteDataSource.getCategoryBasedRecommendations(
        categoryId,
        limit,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> trackInteraction({
    required String productId,
    required String interactionType,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      await remoteDataSource.trackInteraction({
        'product_id': productId,
        'interaction_type': interactionType,
        'metadata': metadata ?? {},
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      rethrow;
    }
  }
}
