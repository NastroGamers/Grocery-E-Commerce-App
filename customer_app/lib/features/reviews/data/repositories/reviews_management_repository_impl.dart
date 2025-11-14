import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../products/data/models/review_model.dart';
import '../../domain/repositories/reviews_management_repository.dart';
import '../datasources/reviews_management_datasource.dart';

class ReviewsManagementRepositoryImpl implements ReviewsManagementRepository {
  final ReviewsManagementDataSource dataSource;

  ReviewsManagementRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, ReviewModel>> submitReview(
    CreateReviewRequest request,
    String orderId,
  ) async {
    try {
      // Validate rating
      if (request.rating < 1 || request.rating > 5) {
        return Left(ValidationFailure(message: 'Rating must be between 1 and 5'));
      }

      // Validate comment
      if (request.comment.trim().isEmpty || request.comment.length < 10) {
        return Left(ValidationFailure(message: 'Comment must be at least 10 characters'));
      }

      if (request.comment.length > 500) {
        return Left(ValidationFailure(message: 'Comment must not exceed 500 characters'));
      }

      // Validate images
      if (request.imageUrls != null && request.imageUrls!.length > 5) {
        return Left(ValidationFailure(message: 'Maximum 5 images allowed'));
      }

      final review = await dataSource.submitReview(request, orderId);
      return Right(review);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ReviewModel>> updateReview(
    String reviewId,
    UpdateReviewRequest request,
  ) async {
    try {
      // Validate rating if provided
      if (request.rating != null && (request.rating! < 1 || request.rating! > 5)) {
        return Left(ValidationFailure(message: 'Rating must be between 1 and 5'));
      }

      // Validate comment if provided
      if (request.comment != null) {
        if (request.comment!.trim().isEmpty || request.comment!.length < 10) {
          return Left(ValidationFailure(message: 'Comment must be at least 10 characters'));
        }

        if (request.comment!.length > 500) {
          return Left(ValidationFailure(message: 'Comment must not exceed 500 characters'));
        }
      }

      // Validate images if provided
      if (request.imageUrls != null && request.imageUrls!.length > 5) {
        return Left(ValidationFailure(message: 'Maximum 5 images allowed'));
      }

      final review = await dataSource.updateReview(reviewId, request);
      return Right(review);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteReview(String reviewId) async {
    try {
      await dataSource.deleteReview(reviewId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ReviewModel>>> getUserReviews(int page) async {
    try {
      final reviews = await dataSource.getUserReviews(page);
      return Right(reviews);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markReviewHelpful(String reviewId, bool isHelpful) async {
    try {
      await dataSource.markReviewHelpful(reviewId, isHelpful);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
