import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel {
  final String id;
  final String name;
  final String sku;
  final String description;
  final List<String> images;
  final double price;
  final double mrp;
  final String? brand;
  final String categoryId;
  final String? subcategoryId;
  final List<String> tags;
  final int stockQuantity;
  final String unit; // 'kg', 'pcs', 'ml', 'g', 'l'
  final double? weight;
  final Map<String, dynamic>? attributes; // organic, gluten-free, etc.
  final double ratingAverage;
  final int reviewsCount;
  final bool isFeatured;
  final bool isFlashSale;
  final String? vendorId;
  final List<ProductVariant>? variants;
  final DateTime? expiryDate;
  final String? storageInstructions;
  final String? manufacturer;
  final String? countryOfOrigin;
  final int? maxQuantityPerOrder;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.sku,
    required this.description,
    required this.images,
    required this.price,
    required this.mrp,
    this.brand,
    required this.categoryId,
    this.subcategoryId,
    this.tags = const [],
    required this.stockQuantity,
    required this.unit,
    this.weight,
    this.attributes,
    this.ratingAverage = 0.0,
    this.reviewsCount = 0,
    this.isFeatured = false,
    this.isFlashSale = false,
    this.vendorId,
    this.variants,
    this.expiryDate,
    this.storageInstructions,
    this.manufacturer,
    this.countryOfOrigin,
    this.maxQuantityPerOrder,
    required this.createdAt,
    this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

  // Computed properties
  bool get isInStock => stockQuantity > 0;

  bool get isLowStock => stockQuantity > 0 && stockQuantity <= 10;

  bool get isOutOfStock => stockQuantity <= 0;

  double get discountPercentage {
    if (mrp > 0 && price < mrp) {
      return ((mrp - price) / mrp) * 100;
    }
    return 0.0;
  }

  bool get hasDiscount => discountPercentage > 0;

  String get stockStatus {
    if (isOutOfStock) return 'Out of Stock';
    if (isLowStock) return 'Low Stock';
    return 'In Stock';
  }

  String get displayPrice => '₹${price.toStringAsFixed(2)}';

  String get displayMrp => '₹${mrp.toStringAsFixed(2)}';

  bool get hasVariants => variants != null && variants!.isNotEmpty;

  ProductModel copyWith({
    String? id,
    String? name,
    String? sku,
    String? description,
    List<String>? images,
    double? price,
    double? mrp,
    String? brand,
    String? categoryId,
    String? subcategoryId,
    List<String>? tags,
    int? stockQuantity,
    String? unit,
    double? weight,
    Map<String, dynamic>? attributes,
    double? ratingAverage,
    int? reviewsCount,
    bool? isFeatured,
    bool? isFlashSale,
    String? vendorId,
    List<ProductVariant>? variants,
    DateTime? expiryDate,
    String? storageInstructions,
    String? manufacturer,
    String? countryOfOrigin,
    int? maxQuantityPerOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      description: description ?? this.description,
      images: images ?? this.images,
      price: price ?? this.price,
      mrp: mrp ?? this.mrp,
      brand: brand ?? this.brand,
      categoryId: categoryId ?? this.categoryId,
      subcategoryId: subcategoryId ?? this.subcategoryId,
      tags: tags ?? this.tags,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      unit: unit ?? this.unit,
      weight: weight ?? this.weight,
      attributes: attributes ?? this.attributes,
      ratingAverage: ratingAverage ?? this.ratingAverage,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      isFeatured: isFeatured ?? this.isFeatured,
      isFlashSale: isFlashSale ?? this.isFlashSale,
      vendorId: vendorId ?? this.vendorId,
      variants: variants ?? this.variants,
      expiryDate: expiryDate ?? this.expiryDate,
      storageInstructions: storageInstructions ?? this.storageInstructions,
      manufacturer: manufacturer ?? this.manufacturer,
      countryOfOrigin: countryOfOrigin ?? this.countryOfOrigin,
      maxQuantityPerOrder: maxQuantityPerOrder ?? this.maxQuantityPerOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

@JsonSerializable()
class ProductVariant {
  final String id;
  final String productId;
  final String name; // e.g., "500g", "1kg", "Pack of 6"
  final double price;
  final double mrp;
  final int stockQuantity;
  final String? sku;
  final Map<String, dynamic>? attributes;

  ProductVariant({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.mrp,
    required this.stockQuantity,
    this.sku,
    this.attributes,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) =>
      _$ProductVariantFromJson(json);

  Map<String, dynamic> toJson() => _$ProductVariantToJson(this);

  bool get isInStock => stockQuantity > 0;

  double get discountPercentage {
    if (mrp > 0 && price < mrp) {
      return ((mrp - price) / mrp) * 100;
    }
    return 0.0;
  }
}

// Filter and Sort models
enum ProductSortOption {
  relevance,
  priceLowToHigh,
  priceHighToLow,
  ratingHighToLow,
  newestFirst,
  popularity,
  discount,
}

enum StockFilter {
  all,
  inStock,
  lowStock,
  outOfStock,
}

@JsonSerializable()
class ProductFilter {
  final String? categoryId;
  final String? subcategoryId;
  final double? minPrice;
  final double? maxPrice;
  final List<String>? brands;
  final double? minRating;
  final bool? isFeatured;
  final bool? isFlashSale;
  final StockFilter stockFilter;
  final List<String>? tags;
  final ProductSortOption sortBy;
  final int page;
  final int limit;

  ProductFilter({
    this.categoryId,
    this.subcategoryId,
    this.minPrice,
    this.maxPrice,
    this.brands,
    this.minRating,
    this.isFeatured,
    this.isFlashSale,
    this.stockFilter = StockFilter.all,
    this.tags,
    this.sortBy = ProductSortOption.relevance,
    this.page = 1,
    this.limit = 20,
  });

  Map<String, dynamic> toQueryParameters() {
    final params = <String, dynamic>{
      'page': page,
      'limit': limit,
      'sortBy': sortBy.name,
    };

    if (categoryId != null) params['categoryId'] = categoryId;
    if (subcategoryId != null) params['subcategoryId'] = subcategoryId;
    if (minPrice != null) params['minPrice'] = minPrice;
    if (maxPrice != null) params['maxPrice'] = maxPrice;
    if (brands != null && brands!.isNotEmpty) {
      params['brands'] = brands!.join(',');
    }
    if (minRating != null) params['minRating'] = minRating;
    if (isFeatured != null) params['isFeatured'] = isFeatured;
    if (isFlashSale != null) params['isFlashSale'] = isFlashSale;
    if (stockFilter != StockFilter.all) {
      params['stockFilter'] = stockFilter.name;
    }
    if (tags != null && tags!.isNotEmpty) {
      params['tags'] = tags!.join(',');
    }

    return params;
  }

  ProductFilter copyWith({
    String? categoryId,
    String? subcategoryId,
    double? minPrice,
    double? maxPrice,
    List<String>? brands,
    double? minRating,
    bool? isFeatured,
    bool? isFlashSale,
    StockFilter? stockFilter,
    List<String>? tags,
    ProductSortOption? sortBy,
    int? page,
    int? limit,
  }) {
    return ProductFilter(
      categoryId: categoryId ?? this.categoryId,
      subcategoryId: subcategoryId ?? this.subcategoryId,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      brands: brands ?? this.brands,
      minRating: minRating ?? this.minRating,
      isFeatured: isFeatured ?? this.isFeatured,
      isFlashSale: isFlashSale ?? this.isFlashSale,
      stockFilter: stockFilter ?? this.stockFilter,
      tags: tags ?? this.tags,
      sortBy: sortBy ?? this.sortBy,
      page: page ?? this.page,
      limit: limit ?? this.limit,
    );
  }
}

@JsonSerializable()
class ProductListResponse {
  final List<ProductModel> products;
  final int totalCount;
  final int page;
  final int limit;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  ProductListResponse({
    required this.products,
    required this.totalCount,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory ProductListResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProductListResponseToJson(this);
}
