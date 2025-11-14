import '../repositories/products_repository.dart';
import '../../data/models/category_model.dart';

class GetCategoriesUseCase {
  final ProductsRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<List<CategoryModel>> execute() async {
    final categories = await repository.getCategories();

    // Sort by display order
    categories.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

    // Filter only active categories
    return categories.where((cat) => cat.isActive).toList();
  }
}
