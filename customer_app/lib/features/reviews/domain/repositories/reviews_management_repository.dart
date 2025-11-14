import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../products/data/models/review_model.dart';

abstract class ReviewsManagementRepository {
  Future<Either<Failure, ReviewModel>> submitReview(CreateReviewRequest request, String orderId);
  Future<Either<Failure, ReviewModel>> updateReview(String reviewId, UpdateReviewRequest request);
  Future<Either<Failure, void>> deleteReview(String reviewId);
  Future<Either<Failure, List<ReviewModel>>> getUserReviews(int page);
  Future<Either<Failure, void>> markReviewHelpful(String reviewId, bool isHelpful);
}
