import '../repositories/products_repository.dart';
import '../../data/models/product_model.dart';

class GetProductDetailsUseCase {
  final ProductsRepository repository;

  GetProductDetailsUseCase(this.repository);

  Future<ProductModel> execute(String productId) async {
    return await repository.getProductById(productId);
  }
}
