import '../repositories/recommendations_repository.dart';

class TrackInteractionUseCase {
  final RecommendationsRepository repository;

  TrackInteractionUseCase(this.repository);

  Future<void> call({
    required String productId,
    required String interactionType,
    Map<String, dynamic>? metadata,
  }) async {
    return await repository.trackInteraction(
      productId: productId,
      interactionType: interactionType,
      metadata: metadata,
    );
  }
}
