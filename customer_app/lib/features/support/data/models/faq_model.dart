import 'package:json_annotation/json_annotation.dart';

part 'faq_model.g.dart';

@JsonSerializable()
class FAQModel {
  final String id;
  final String question;
  final String answer;
  final String category; // 'general', 'orders', 'payment', 'delivery', 'account'
  final int helpfulCount;
  final int notHelpfulCount;
  final int viewCount;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<String>? tags;
  final int sortOrder;
  final bool isActive;

  FAQModel({
    required this.id,
    required this.question,
    required this.answer,
    required this.category,
    this.helpfulCount = 0,
    this.notHelpfulCount = 0,
    this.viewCount = 0,
    required this.createdAt,
    this.updatedAt,
    this.tags,
    this.sortOrder = 0,
    this.isActive = true,
  });

  factory FAQModel.fromJson(Map<String, dynamic> json) =>
      _$FAQModelFromJson(json);

  Map<String, dynamic> toJson() => _$FAQModelToJson(this);

  double get helpfulnessRatio {
    final total = helpfulCount + notHelpfulCount;
    if (total == 0) return 0.0;
    return helpfulCount / total;
  }

  FAQModel copyWith({
    String? id,
    String? question,
    String? answer,
    String? category,
    int? helpfulCount,
    int? notHelpfulCount,
    int? viewCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? tags,
    int? sortOrder,
    bool? isActive,
  }) {
    return FAQModel(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      category: category ?? this.category,
      helpfulCount: helpfulCount ?? this.helpfulCount,
      notHelpfulCount: notHelpfulCount ?? this.notHelpfulCount,
      viewCount: viewCount ?? this.viewCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tags: tags ?? this.tags,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
    );
  }
}
