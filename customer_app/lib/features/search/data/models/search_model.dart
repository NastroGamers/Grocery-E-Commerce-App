import 'package:json_annotation/json_annotation.dart';
import '../../../products/data/models/product_model.dart';
import '../../../products/data/models/category_model.dart';

part 'search_model.g.dart';

@JsonSerializable()
class SearchSuggestion {
  final String id;
  final String text;
  final String type; // 'product', 'category', 'brand', 'query'
  final String? productId;
  final String? categoryId;
  final String? imageUrl;
  final int? popularity;

  SearchSuggestion({
    required this.id,
    required this.text,
    required this.type,
    this.productId,
    this.categoryId,
    this.imageUrl,
    this.popularity,
  });

  factory SearchSuggestion.fromJson(Map<String, dynamic> json) =>
      _$SearchSuggestionFromJson(json);

  Map<String, dynamic> toJson() => _$SearchSuggestionToJson(this);

  bool get isProduct => type == 'product';
  bool get isCategory => type == 'category';
  bool get isBrand => type == 'brand';
  bool get isQuery => type == 'query';
}

@JsonSerializable()
class SearchResult {
  final List<ProductModel> products;
  final List<CategoryModel> categories;
  final List<String> brands;
  final int totalProductCount;
  final String query;
  final List<String> corrections; // Did you mean suggestions

  SearchResult({
    required this.products,
    required this.categories,
    required this.brands,
    required this.totalProductCount,
    required this.query,
    this.corrections = const [],
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) =>
      _$SearchResultFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResultToJson(this);

  bool get hasProducts => products.isNotEmpty;
  bool get hasCategories => categories.isNotEmpty;
  bool get hasBrands => brands.isNotEmpty;
  bool get hasResults => hasProducts || hasCategories || hasBrands;
  bool get hasCorrections => corrections.isNotEmpty;
}

@JsonSerializable()
class TrendingSearch {
  final String id;
  final String query;
  final int searchCount;
  final String? categoryId;
  final DateTime? trendingDate;

  TrendingSearch({
    required this.id,
    required this.query,
    required this.searchCount,
    this.categoryId,
    this.trendingDate,
  });

  factory TrendingSearch.fromJson(Map<String, dynamic> json) =>
      _$TrendingSearchFromJson(json);

  Map<String, dynamic> toJson() => _$TrendingSearchToJson(this);
}

@JsonSerializable()
class PopularSearch {
  final String query;
  final int count;

  PopularSearch({
    required this.query,
    required this.count,
  });

  factory PopularSearch.fromJson(Map<String, dynamic> json) =>
      _$PopularSearchFromJson(json);

  Map<String, dynamic> toJson() => _$PopularSearchToJson(this);
}

// Local search history model
@JsonSerializable()
class SearchHistory {
  final String query;
  final DateTime timestamp;

  SearchHistory({
    required this.query,
    required this.timestamp,
  });

  factory SearchHistory.fromJson(Map<String, dynamic> json) =>
      _$SearchHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$SearchHistoryToJson(this);
}
