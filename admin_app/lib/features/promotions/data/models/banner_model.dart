import 'package:json_annotation/json_annotation.dart';

part 'banner_model.g.dart';

@JsonSerializable()
class BannerModel {
  final String id;
  final String imageUrl;
  final String title;
  final String? description;
  final String targetType; // 'product', 'category', 'url', 'none'
  final String? targetId;
  final String? targetUrl;
  final int priority;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final int clickCount;
  final int viewCount;
  final DateTime createdAt;

  BannerModel({
    required this.id,
    required this.imageUrl,
    required this.title,
    this.description,
    required this.targetType,
    this.targetId,
    this.targetUrl,
    this.priority = 0,
    required this.startDate,
    required this.endDate,
    this.isActive = true,
    this.clickCount = 0,
    this.viewCount = 0,
    required this.createdAt,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) =>
      _$BannerModelFromJson(json);

  Map<String, dynamic> toJson() => _$BannerModelToJson(this);

  bool get isScheduled => DateTime.now().isBefore(startDate);
  bool get isExpired => DateTime.now().isAfter(endDate);
  bool get isLive => !isScheduled && !isExpired && isActive;
}

@JsonSerializable()
class PromotionModel {
  final String id;
  final String code;
  final String description;
  final String type; // 'percentage', 'fixed', 'free_delivery'
  final double value;
  final double? minOrderValue;
  final double? maxDiscount;
  final int? usageLimit;
  final int usageCount;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final List<String>? applicableCategories;
  final List<String>? applicableProducts;

  PromotionModel({
    required this.id,
    required this.code,
    required this.description,
    required this.type,
    required this.value,
    this.minOrderValue,
    this.maxDiscount,
    this.usageLimit,
    this.usageCount = 0,
    required this.startDate,
    required this.endDate,
    this.isActive = true,
    this.applicableCategories,
    this.applicableProducts,
  });

  factory PromotionModel.fromJson(Map<String, dynamic> json) =>
      _$PromotionModelFromJson(json);

  Map<String, dynamic> toJson() => _$PromotionModelToJson(this);
}
