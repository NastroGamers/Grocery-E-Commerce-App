import '../../data/models/category_model.dart';
import '../../data/models/product_model.dart';

abstract class ProductsRepository {
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
