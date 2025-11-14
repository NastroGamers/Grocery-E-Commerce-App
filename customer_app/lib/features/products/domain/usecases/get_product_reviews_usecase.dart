import '../repositories/reviews_repository.dart';
import '../../data/models/review_model.dart';

class GetProductReviewsUseCase {
  final ReviewsRepository repository;

  GetProductReviewsUseCase(this.repository);

  Future<List<ReviewModel>> execute(
    String productId, {
    int page = 1,
    int limit = 10,
  }) async {
    return await repository.getProductReviews(
      productId,
      page: page,
      limit: limit,
    );
  }
}
