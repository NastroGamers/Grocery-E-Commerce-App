import '../../domain/repositories/search_repository.dart';
import '../datasources/search_local_datasource.dart';
import '../datasources/search_remote_datasource.dart';
import '../models/search_model.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;
  final SearchLocalDataSource localDataSource;

  SearchRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<SearchResult> search(String query, {int limit = 20}) async {
    final result = await remoteDataSource.search(query, limit: limit);

    // Add to history if results found
    if (result.hasResults) {
      await localDataSource.addToHistory(query);
    }

    // Track search analytics
    await remoteDataSource.trackSearch(query);

    return result;
  }

  @override
  Future<List<SearchSuggestion>> getSuggestions(String query) async {
    return await remoteDataSource.getSuggestions(query);
  }

  @override
  Future<List<TrendingSearch>> getTrendingSearches({int limit = 10}) async {
    return await remoteDataSource.getTrendingSearches(limit: limit);
  }

  @override
  Future<List<PopularSearch>> getPopularSearches({int limit = 10}) async {
    return await remoteDataSource.getPopularSearches(limit: limit);
  }

  @override
  Future<List<SearchHistory>> getSearchHistory() async {
    return await localDataSource.getSearchHistory();
  }

  @override
  Future<void> addToHistory(String query) async {
    await localDataSource.addToHistory(query);
  }

  @override
  Future<void> clearHistory() async {
    await localDataSource.clearHistory();
  }

  @override
  Future<void> removeFromHistory(String query) async {
    await localDataSource.removeFromHistory(query);
  }

  @override
  Future<void> trackSearch(String query) async {
    await remoteDataSource.trackSearch(query);
  }
}
