import '../../data/models/recommendation_model.dart';

abstract class RecommendationsRepository {
  /// Get personalized recommendations for the user
  Future<RecommendationsResponse> getPersonalizedRecommendations({
    int limit = 10,
  });

  /// Get similar products based on a product ID
  Future<RecommendationsResponse> getSimilarProducts({
    required String productId,
    int limit = 10,
  });

  /// Get frequently bought together products
  Future<RecommendationsResponse> getFrequentlyBoughtTogether({
    required String productId,
    int limit = 5,
  });

  /// Get trending products
  Future<RecommendationsResponse> getTrendingProducts({
    int limit = 10,
  });

  /// Get recommendations based on category
  Future<RecommendationsResponse> getCategoryBasedRecommendations({
    required String categoryId,
    int limit = 10,
  });

  /// Track user interaction for better recommendations
  Future<void> trackInteraction({
    required String productId,
    required String interactionType,
    Map<String, dynamic>? metadata,
  });
}
