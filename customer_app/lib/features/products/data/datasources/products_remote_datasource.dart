import '../../../../core/network/dio_client.dart';
import '../../../../core/config/app_config.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

abstract class ProductsRemoteDataSource {
  // Categories
  Future<List<CategoryModel>> getCategories();
  Future<CategoryModel> getCategoryById(String categoryId);
  Future<List<CategoryModel>> getSubcategories(String parentCategoryId);

  // Products
  Future<ProductListResponse> getProducts(ProductFilter filter);
  Future<ProductModel> getProductById(String productId);
  Future<List<ProductModel>> getFeaturedProducts({int limit = 10});
  Future<List<ProductModel>> getFlashSaleProducts({int limit = 10});
  Future<List<ProductModel>> getSimilarProducts(String productId, {int limit = 10});
  Future<List<String>> getAvailableBrands(String? categoryId);
}

class ProductsRemoteDataSourceImpl implements ProductsRemoteDataSource {
  final DioClient _dioClient;

  ProductsRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _dioClient.get(
        AppConfig.categoriesEndpoint,
      );

      final List<dynamic> data = response.data['data'] as List;
      return data.map((json) => CategoryModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CategoryModel> getCategoryById(String categoryId) async {
    try {
      final response = await _dioClient.get(
        '${AppConfig.categoriesEndpoint}/$categoryId',
      );
      return CategoryModel.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<CategoryModel>> getSubcategories(String parentCategoryId) async {
    try {
      final response = await _dioClient.get(
        '${AppConfig.categoriesEndpoint}/$parentCategoryId/subcategories',
      );

      final List<dynamic> data = response.data['data'] as List;
      return data.map((json) => CategoryModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ProductListResponse> getProducts(ProductFilter filter) async {
    try {
      final response = await _dioClient.get(
        AppConfig.productsEndpoint,
        queryParameters: filter.toQueryParameters(),
      );

      return ProductListResponse.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ProductModel> getProductById(String productId) async {
    try {
      final response = await _dioClient.get(
        '${AppConfig.productsEndpoint}/$productId',
      );
      return ProductModel.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ProductModel>> getFeaturedProducts({int limit = 10}) async {
    try {
      final response = await _dioClient.get(
        '${AppConfig.productsEndpoint}/featured',
        queryParameters: {'limit': limit},
      );

      final List<dynamic> data = response.data['data'] as List;
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ProductModel>> getFlashSaleProducts({int limit = 10}) async {
    try {
      final response = await _dioClient.get(
        '${AppConfig.productsEndpoint}/flash-sale',
        queryParameters: {'limit': limit},
      );

      final List<dynamic> data = response.data['data'] as List;
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ProductModel>> getSimilarProducts(
    String productId, {
    int limit = 10,
  }) async {
    try {
      final response = await _dioClient.get(
        '${AppConfig.productsEndpoint}/$productId/similar',
        queryParameters: {'limit': limit},
      );

      final List<dynamic> data = response.data['data'] as List;
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<String>> getAvailableBrands(String? categoryId) async {
    try {
      final response = await _dioClient.get(
        '${AppConfig.productsEndpoint}/brands',
        queryParameters: categoryId != null ? {'categoryId': categoryId} : null,
      );

      final List<dynamic> data = response.data['data'] as List;
      return data.map((e) => e.toString()).toList();
    } catch (e) {
      rethrow;
    }
  }
}
