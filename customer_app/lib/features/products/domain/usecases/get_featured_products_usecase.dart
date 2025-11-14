import '../repositories/products_repository.dart';
import '../../data/models/product_model.dart';

class GetFeaturedProductsUseCase {
  final ProductsRepository repository;

  GetFeaturedProductsUseCase(this.repository);

  Future<List<ProductModel>> execute({int limit = 10}) async {
    return await repository.getFeaturedProducts(limit: limit);
  }
}
