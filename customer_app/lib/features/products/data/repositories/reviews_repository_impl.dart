import '../../domain/repositories/reviews_repository.dart';
import '../datasources/reviews_remote_datasource.dart';
import '../models/review_model.dart';

class ReviewsRepositoryImpl implements ReviewsRepository {
  final ReviewsRemoteDataSource remoteDataSource;

  ReviewsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ReviewModel>> getProductReviews(
    String productId, {
    int page = 1,
    int limit = 10,
  }) async {
    return await remoteDataSource.getProductReviews(
      productId,
      page: page,
      limit: limit,
    );
  }

  @override
  Future<ReviewSummary> getReviewSummary(String productId) async {
    return await remoteDataSource.getReviewSummary(productId);
  }

  @override
  Future<ReviewModel> createReview(CreateReviewRequest request) async {
    return await remoteDataSource.createReview(request);
  }

  @override
  Future<ReviewModel> updateReview(
    String reviewId,
    UpdateReviewRequest request,
  ) async {
    return await remoteDataSource.updateReview(reviewId, request);
  }

  @override
  Future<void> deleteReview(String reviewId) async {
    await remoteDataSource.deleteReview(reviewId);
  }

  @override
  Future<void> markReviewHelpful(String reviewId, bool isHelpful) async {
    await remoteDataSource.markReviewHelpful(reviewId, isHelpful);
  }
}
