import '../../domain/repositories/products_repository.dart';
import '../datasources/products_remote_datasource.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsRemoteDataSource remoteDataSource;

  ProductsRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<List<CategoryModel>> getCategories() async {
    return await remoteDataSource.getCategories();
  }

  @override
  Future<CategoryModel> getCategoryById(String categoryId) async {
    return await remoteDataSource.getCategoryById(categoryId);
  }

  @override
  Future<List<CategoryModel>> getSubcategories(String parentCategoryId) async {
    return await remoteDataSource.getSubcategories(parentCategoryId);
  }

  @override
  Future<ProductListResponse> getProducts(ProductFilter filter) async {
    return await remoteDataSource.getProducts(filter);
  }

  @override
  Future<ProductModel> getProductById(String productId) async {
    return await remoteDataSource.getProductById(productId);
  }

  @override
  Future<List<ProductModel>> getFeaturedProducts({int limit = 10}) async {
    return await remoteDataSource.getFeaturedProducts(limit: limit);
  }

  @override
  Future<List<ProductModel>> getFlashSaleProducts({int limit = 10}) async {
    return await remoteDataSource.getFlashSaleProducts(limit: limit);
  }

  @override
  Future<List<ProductModel>> getSimilarProducts(
    String productId, {
    int limit = 10,
  }) async {
    return await remoteDataSource.getSimilarProducts(
      productId,
      limit: limit,
    );
  }

  @override
  Future<List<String>> getAvailableBrands(String? categoryId) async {
    return await remoteDataSource.getAvailableBrands(categoryId);
  }
}
