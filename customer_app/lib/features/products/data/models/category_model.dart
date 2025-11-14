import 'package:json_annotation/json_annotation.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryModel {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final String? iconUrl;
  final int displayOrder;
  final bool isActive;
  final String? parentCategoryId;
  final List<CategoryModel>? subcategories;
  final int? productCount;
  final DateTime createdAt;
  final DateTime? updatedAt;

  CategoryModel({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    this.iconUrl,
    this.displayOrder = 0,
    this.isActive = true,
    this.parentCategoryId,
    this.subcategories,
    this.productCount,
    required this.createdAt,
    this.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);

  bool get hasSubcategories =>
      subcategories != null && subcategories!.isNotEmpty;

  bool get isParentCategory => parentCategoryId == null;

  CategoryModel copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    String? iconUrl,
    int? displayOrder,
    bool? isActive,
    String? parentCategoryId,
    List<CategoryModel>? subcategories,
    int? productCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      iconUrl: iconUrl ?? this.iconUrl,
      displayOrder: displayOrder ?? this.displayOrder,
      isActive: isActive ?? this.isActive,
      parentCategoryId: parentCategoryId ?? this.parentCategoryId,
      subcategories: subcategories ?? this.subcategories,
      productCount: productCount ?? this.productCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
