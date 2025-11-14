import '../repositories/search_repository.dart';
import '../../data/models/search_model.dart';

class GetTrendingSearchesUseCase {
  final SearchRepository repository;

  GetTrendingSearchesUseCase(this.repository);

  Future<List<TrendingSearch>> execute({int limit = 10}) async {
    return await repository.getTrendingSearches(limit: limit);
  }
}
