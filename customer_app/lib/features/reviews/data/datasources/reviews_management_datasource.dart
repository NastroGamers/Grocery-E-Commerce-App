import 'package:dio/dio.dart';
import '../../../products/data/models/review_model.dart';

abstract class ReviewsManagementDataSource {
  Future<ReviewModel> submitReview(CreateReviewRequest request, String orderId);
  Future<ReviewModel> updateReview(String reviewId, UpdateReviewRequest request);
  Future<void> deleteReview(String reviewId);
  Future<List<ReviewModel>> getUserReviews(int page);
  Future<void> markReviewHelpful(String reviewId, bool isHelpful);
}

class ReviewsManagementDataSourceImpl implements ReviewsManagementDataSource {
  final Dio dio;

  ReviewsManagementDataSourceImpl({required this.dio});

  @override
  Future<ReviewModel> submitReview(CreateReviewRequest request, String orderId) async {
    final response = await dio.post(
      '/reviews',
      data: {
        ...request.toJson(),
        'orderId': orderId,
      },
    );

    return ReviewModel.fromJson(response.data['data']);
  }

  @override
  Future<ReviewModel> updateReview(String reviewId, UpdateReviewRequest request) async {
    final response = await dio.put(
      '/reviews/$reviewId',
      data: request.toJson(),
    );

    return ReviewModel.fromJson(response.data['data']);
  }

  @override
  Future<void> deleteReview(String reviewId) async {
    await dio.delete('/reviews/$reviewId');
  }

  @override
  Future<List<ReviewModel>> getUserReviews(int page) async {
    final response = await dio.get(
      '/user/reviews',
      queryParameters: {'page': page, 'limit': 20},
    );

    return (response.data['data'] as List)
        .map((json) => ReviewModel.fromJson(json))
        .toList();
  }

  @override
  Future<void> markReviewHelpful(String reviewId, bool isHelpful) async {
    await dio.post(
      '/reviews/$reviewId/helpful',
      data: {'isHelpful': isHelpful},
    );
  }
}
