import '../../../../core/network/dio_client.dart';
import '../../../../core/config/app_config.dart';
import '../models/review_model.dart';

abstract class ReviewsRemoteDataSource {
  Future<List<ReviewModel>> getProductReviews(String productId, {int page = 1, int limit = 10});
  Future<ReviewSummary> getReviewSummary(String productId);
  Future<ReviewModel> createReview(CreateReviewRequest request);
  Future<ReviewModel> updateReview(String reviewId, UpdateReviewRequest request);
  Future<void> deleteReview(String reviewId);
  Future<void> markReviewHelpful(String reviewId, bool isHelpful);
}

class ReviewsRemoteDataSourceImpl implements ReviewsRemoteDataSource {
  final DioClient _dioClient;

  ReviewsRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<ReviewModel>> getProductReviews(
    String productId, {
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _dioClient.get(
        '${AppConfig.productsEndpoint}/$productId${AppConfig.reviewsEndpoint}',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      final List<dynamic> data = response.data['data'] as List;
      return data.map((json) => ReviewModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ReviewSummary> getReviewSummary(String productId) async {
    try {
      final response = await _dioClient.get(
        '${AppConfig.productsEndpoint}/$productId${AppConfig.reviewsEndpoint}/summary',
      );

      return ReviewSummary.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ReviewModel> createReview(CreateReviewRequest request) async {
    try {
      final response = await _dioClient.post(
        AppConfig.reviewsEndpoint,
        data: request.toJson(),
      );

      return ReviewModel.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ReviewModel> updateReview(
    String reviewId,
    UpdateReviewRequest request,
  ) async {
    try {
      final response = await _dioClient.put(
        '${AppConfig.reviewsEndpoint}/$reviewId',
        data: request.toJson(),
      );

      return ReviewModel.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteReview(String reviewId) async {
    try {
      await _dioClient.delete('${AppConfig.reviewsEndpoint}/$reviewId');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> markReviewHelpful(String reviewId, bool isHelpful) async {
    try {
      await _dioClient.post(
        '${AppConfig.reviewsEndpoint}/$reviewId/helpful',
        data: {'isHelpful': isHelpful},
      );
    } catch (e) {
      rethrow;
    }
  }
}
