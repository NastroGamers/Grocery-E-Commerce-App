import '../repositories/recommendations_repository.dart';
import '../../data/models/recommendation_model.dart';

class GetPersonalizedRecommendationsUseCase {
  final RecommendationsRepository repository;

  GetPersonalizedRecommendationsUseCase(this.repository);

  Future<RecommendationsResponse> call({int limit = 10}) async {
    return await repository.getPersonalizedRecommendations(limit: limit);
  }
}
