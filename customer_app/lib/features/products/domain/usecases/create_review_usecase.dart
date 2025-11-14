import '../repositories/reviews_repository.dart';
import '../../data/models/review_model.dart';

class CreateReviewUseCase {
  final ReviewsRepository repository;

  CreateReviewUseCase(this.repository);

  Future<ReviewModel> execute(CreateReviewRequest request) async {
    // Validate rating
    if (request.rating < 1 || request.rating > 5) {
      throw Exception('Rating must be between 1 and 5');
    }

    // Validate comment
    if (request.comment.trim().isEmpty) {
      throw Exception('Review comment is required');
    }

    if (request.comment.trim().length < 10) {
      throw Exception('Review comment must be at least 10 characters');
    }

    return await repository.createReview(request);
  }
}
