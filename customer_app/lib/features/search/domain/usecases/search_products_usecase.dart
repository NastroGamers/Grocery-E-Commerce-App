import '../repositories/search_repository.dart';
import '../../data/models/search_model.dart';

class SearchProductsUseCase {
  final SearchRepository repository;

  SearchProductsUseCase(this.repository);

  Future<SearchResult> execute(String query, {int limit = 20}) async {
    // Validate query
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) {
      throw Exception('Search query cannot be empty');
    }

    if (cleanQuery.length < 2) {
      throw Exception('Search query must be at least 2 characters');
    }

    return await repository.search(cleanQuery, limit: limit);
  }
}
