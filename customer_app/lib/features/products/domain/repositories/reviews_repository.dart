import '../../data/models/review_model.dart';

abstract class ReviewsRepository {
  Future<List<ReviewModel>> getProductReviews(String productId, {int page = 1, int limit = 10});
  Future<ReviewSummary> getReviewSummary(String productId);
  Future<ReviewModel> createReview(CreateReviewRequest request);
  Future<ReviewModel> updateReview(String reviewId, UpdateReviewRequest request);
  Future<void> deleteReview(String reviewId);
  Future<void> markReviewHelpful(String reviewId, bool isHelpful);
}
