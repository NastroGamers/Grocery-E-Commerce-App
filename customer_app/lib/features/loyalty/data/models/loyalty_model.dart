import 'package:json_annotation/json_annotation.dart';

part 'loyalty_model.g.dart';

@JsonSerializable()
class LoyaltyModel {
  @JsonKey(name: 'user_id')
  final String userId;

  @JsonKey(name: 'total_points')
  final int totalPoints;

  @JsonKey(name: 'available_points')
  final int availablePoints;

  @JsonKey(name: 'redeemed_points')
  final int redeemedPoints;

  @JsonKey(name: 'tier')
  final String tier;

  @JsonKey(name: 'tier_benefits')
  final List<String> tierBenefits;

  @JsonKey(name: 'points_to_next_tier')
  final int? pointsToNextTier;

  @JsonKey(name: 'next_tier')
  final String? nextTier;

  @JsonKey(name: 'member_since')
  final DateTime memberSince;

  @JsonKey(name: 'expiring_points')
  final int expiringPoints;

  @JsonKey(name: 'expiry_date')
  final DateTime? expiryDate;

  const LoyaltyModel({
    required this.userId,
    required this.totalPoints,
    required this.availablePoints,
    required this.redeemedPoints,
    required this.tier,
    required this.tierBenefits,
    this.pointsToNextTier,
    this.nextTier,
    required this.memberSince,
    required this.expiringPoints,
    this.expiryDate,
  });

  factory LoyaltyModel.fromJson(Map<String, dynamic> json) =>
      _$LoyaltyModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoyaltyModelToJson(this);
}

@JsonSerializable()
class PointsTransactionModel {
  @JsonKey(name: 'transaction_id')
  final String transactionId;

  @JsonKey(name: 'user_id')
  final String userId;

  @JsonKey(name: 'points')
  final int points;

  @JsonKey(name: 'type')
  final String type; // 'earned', 'redeemed', 'expired', 'bonus'

  @JsonKey(name: 'description')
  final String description;

  @JsonKey(name: 'order_id')
  final String? orderId;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'expires_at')
  final DateTime? expiresAt;

  const PointsTransactionModel({
    required this.transactionId,
    required this.userId,
    required this.points,
    required this.type,
    required this.description,
    this.orderId,
    required this.createdAt,
    this.expiresAt,
  });

  factory PointsTransactionModel.fromJson(Map<String, dynamic> json) =>
      _$PointsTransactionModelFromJson(json);

  Map<String, dynamic> toJson() => _$PointsTransactionModelToJson(this);
}

@JsonSerializable()
class RewardModel {
  @JsonKey(name: 'reward_id')
  final String rewardId;

  @JsonKey(name: 'title')
  final String title;

  @JsonKey(name: 'description')
  final String description;

  @JsonKey(name: 'points_required')
  final int pointsRequired;

  @JsonKey(name: 'reward_type')
  final String rewardType; // 'discount', 'product', 'shipping'

  @JsonKey(name: 'reward_value')
  final double rewardValue;

  @JsonKey(name: 'image_url')
  final String? imageUrl;

  @JsonKey(name: 'tier_required')
  final String? tierRequired;

  @JsonKey(name: 'is_available')
  final bool isAvailable;

  @JsonKey(name: 'valid_until')
  final DateTime? validUntil;

  const RewardModel({
    required this.rewardId,
    required this.title,
    required this.description,
    required this.pointsRequired,
    required this.rewardType,
    required this.rewardValue,
    this.imageUrl,
    this.tierRequired,
    required this.isAvailable,
    this.validUntil,
  });

  factory RewardModel.fromJson(Map<String, dynamic> json) =>
      _$RewardModelFromJson(json);

  Map<String, dynamic> toJson() => _$RewardModelToJson(this);
}

@JsonSerializable()
class RedeemRewardRequest {
  @JsonKey(name: 'reward_id')
  final String rewardId;

  @JsonKey(name: 'points')
  final int points;

  const RedeemRewardRequest({
    required this.rewardId,
    required this.points,
  });

  factory RedeemRewardRequest.fromJson(Map<String, dynamic> json) =>
      _$RedeemRewardRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RedeemRewardRequestToJson(this);
}

@JsonSerializable()
class RedeemRewardResponse {
  @JsonKey(name: 'coupon_code')
  final String? couponCode;

  @JsonKey(name: 'message')
  final String message;

  @JsonKey(name: 'new_balance')
  final int newBalance;

  const RedeemRewardResponse({
    this.couponCode,
    required this.message,
    required this.newBalance,
  });

  factory RedeemRewardResponse.fromJson(Map<String, dynamic> json) =>
      _$RedeemRewardResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RedeemRewardResponseToJson(this);
}

enum LoyaltyTier {
  @JsonValue('bronze')
  bronze,

  @JsonValue('silver')
  silver,

  @JsonValue('gold')
  gold,

  @JsonValue('platinum')
  platinum,
}
