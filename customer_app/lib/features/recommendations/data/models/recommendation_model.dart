import 'package:json_annotation/json_annotation.dart';

part 'recommendation_model.g.dart';

@JsonSerializable()
class RecommendationModel {
  @JsonKey(name: 'product_id')
  final String productId;

  @JsonKey(name: 'product_name')
  final String productName;

  @JsonKey(name: 'product_image')
  final String productImage;

  @JsonKey(name: 'price')
  final double price;

  @JsonKey(name: 'mrp')
  final double mrp;

  @JsonKey(name: 'rating')
  final double rating;

  @JsonKey(name: 'recommendation_score')
  final double recommendationScore;

  @JsonKey(name: 'recommendation_reason')
  final String recommendationReason;

  @JsonKey(name: 'category')
  final String category;

  @JsonKey(name: 'in_stock')
  final bool inStock;

  const RecommendationModel({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.mrp,
    required this.rating,
    required this.recommendationScore,
    required this.recommendationReason,
    required this.category,
    required this.inStock,
  });

  factory RecommendationModel.fromJson(Map<String, dynamic> json) =>
      _$RecommendationModelFromJson(json);

  Map<String, dynamic> toJson() => _$RecommendationModelToJson(this);
}

@JsonSerializable()
class RecommendationsResponse {
  @JsonKey(name: 'recommendations')
  final List<RecommendationModel> recommendations;

  @JsonKey(name: 'algorithm')
  final String algorithm;

  @JsonKey(name: 'generated_at')
  final DateTime generatedAt;

  const RecommendationsResponse({
    required this.recommendations,
    required this.algorithm,
    required this.generatedAt,
  });

  factory RecommendationsResponse.fromJson(Map<String, dynamic> json) =>
      _$RecommendationsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RecommendationsResponseToJson(this);
}

enum RecommendationType {
  @JsonValue('personalized')
  personalized,

  @JsonValue('similar_products')
  similarProducts,

  @JsonValue('frequently_bought_together')
  frequentlyBoughtTogether,

  @JsonValue('trending')
  trending,

  @JsonValue('based_on_category')
  basedOnCategory,
}
