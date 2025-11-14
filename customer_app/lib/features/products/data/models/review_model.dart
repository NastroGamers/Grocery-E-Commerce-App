import 'package:json_annotation/json_annotation.dart';

part 'review_model.g.dart';

@JsonSerializable()
class ReviewModel {
  final String id;
  final String productId;
  final String userId;
  final String userName;
  final String? userProfilePic;
  final int rating; // 1-5
  final String? title;
  final String comment;
  final List<String> images;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isVerifiedPurchase;
  final int helpfulCount;
  final bool? isHelpful; // Did current user mark as helpful

  ReviewModel({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    this.userProfilePic,
    required this.rating,
    this.title,
    required this.comment,
    this.images = const [],
    required this.createdAt,
    this.updatedAt,
    this.isVerifiedPurchase = false,
    this.helpfulCount = 0,
    this.isHelpful,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewModelToJson(this);

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}

@JsonSerializable()
class ReviewSummary {
  final double averageRating;
  final int totalReviews;
  final Map<int, int> ratingDistribution; // {5: 120, 4: 45, 3: 10, 2: 5, 1: 2}

  ReviewSummary({
    required this.averageRating,
    required this.totalReviews,
    required this.ratingDistribution,
  });

  factory ReviewSummary.fromJson(Map<String, dynamic> json) =>
      _$ReviewSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewSummaryToJson(this);

  int get fiveStarCount => ratingDistribution[5] ?? 0;
  int get fourStarCount => ratingDistribution[4] ?? 0;
  int get threeStarCount => ratingDistribution[3] ?? 0;
  int get twoStarCount => ratingDistribution[2] ?? 0;
  int get oneStarCount => ratingDistribution[1] ?? 0;

  double getPercentage(int rating) {
    if (totalReviews == 0) return 0;
    final count = ratingDistribution[rating] ?? 0;
    return (count / totalReviews) * 100;
  }
}

@JsonSerializable()
class CreateReviewRequest {
  final String productId;
  final int rating;
  final String? title;
  final String comment;
  final List<String>? imageUrls;

  CreateReviewRequest({
    required this.productId,
    required this.rating,
    this.title,
    required this.comment,
    this.imageUrls,
  });

  Map<String, dynamic> toJson() => _$CreateReviewRequestToJson(this);
}

@JsonSerializable()
class UpdateReviewRequest {
  final int? rating;
  final String? title;
  final String? comment;
  final List<String>? imageUrls;

  UpdateReviewRequest({
    this.rating,
    this.title,
    this.comment,
    this.imageUrls,
  });

  Map<String, dynamic> toJson() => _$UpdateReviewRequestToJson(this);
}
