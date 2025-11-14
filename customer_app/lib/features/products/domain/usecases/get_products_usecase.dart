import '../repositories/products_repository.dart';
import '../../data/models/product_model.dart';

class GetProductsUseCase {
  final ProductsRepository repository;

  GetProductsUseCase(this.repository);

  Future<ProductListResponse> execute(ProductFilter filter) async {
    return await repository.getProducts(filter);
  }
}
