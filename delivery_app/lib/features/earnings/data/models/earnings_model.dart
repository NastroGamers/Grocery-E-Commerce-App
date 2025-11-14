import 'package:json_annotation/json_annotation.dart';

part 'earnings_model.g.dart';

@JsonSerializable()
class EarningsModel {
  final double today;
  final double week;
  final double month;
  final double total;
  final double pendingPayout;
  final double availableForPayout;
  final int deliveriesToday;
  final int deliveriesWeek;
  final int deliveriesMonth;

  EarningsModel({
    required this.today,
    required this.week,
    required this.month,
    required this.total,
    this.pendingPayout = 0.0,
    this.availableForPayout = 0.0,
    this.deliveriesToday = 0,
    this.deliveriesWeek = 0,
    this.deliveriesMonth = 0,
  });

  factory EarningsModel.fromJson(Map<String, dynamic> json) =>
      _$EarningsModelFromJson(json);

  Map<String, dynamic> toJson() => _$EarningsModelToJson(this);

  double get avgEarningsPerDelivery {
    if (deliveriesMonth == 0) return 0.0;
    return month / deliveriesMonth;
  }
}

@JsonSerializable()
class DeliveryStatsModel {
  final int totalDeliveries;
  final double avgRating;
  final double completionRate;
  final double onTimeRate;
  final int totalRatings;
  final Map<int, int> ratingDistribution; // {5: 80, 4: 15, 3: 3, 2: 1, 1: 1}

  DeliveryStatsModel({
    required this.totalDeliveries,
    required this.avgRating,
    this.completionRate = 100.0,
    this.onTimeRate = 100.0,
    this.totalRatings = 0,
    this.ratingDistribution = const {},
  });

  factory DeliveryStatsModel.fromJson(Map<String, dynamic> json) =>
      _$DeliveryStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryStatsModelToJson(this);
}

@JsonSerializable()
class DeliveryRatingModel {
  final String id;
  final String orderId;
  final String customerName;
  final int rating;
  final String? comment;
  final DateTime createdAt;

  DeliveryRatingModel({
    required this.id,
    required this.orderId,
    required this.customerName,
    required this.rating,
    this.comment,
    required this.createdAt,
  });

  factory DeliveryRatingModel.fromJson(Map<String, dynamic> json) =>
      _$DeliveryRatingModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryRatingModelToJson(this);
}

@JsonSerializable()
class PayoutRequestModel {
  final double amount;
  final String? upiId;
  final Map<String, dynamic>? bankDetails;
  final String method; // 'upi', 'bank_transfer'

  PayoutRequestModel({
    required this.amount,
    this.upiId,
    this.bankDetails,
    this.method = 'upi',
  });

  factory PayoutRequestModel.fromJson(Map<String, dynamic> json) =>
      _$PayoutRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$PayoutRequestModelToJson(this);
}

@JsonSerializable()
class PayoutHistoryModel {
  final String id;
  final double amount;
  final String method;
  final String status; // 'pending', 'processing', 'completed', 'failed'
  final DateTime requestedAt;
  final DateTime? completedAt;
  final String? transactionId;

  PayoutHistoryModel({
    required this.id,
    required this.amount,
    required this.method,
    required this.status,
    required this.requestedAt,
    this.completedAt,
    this.transactionId,
  });

  factory PayoutHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$PayoutHistoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$PayoutHistoryModelToJson(this);
}
