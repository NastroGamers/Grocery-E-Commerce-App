import '../../data/models/search_model.dart';

abstract class SearchRepository {
  // Search
  Future<SearchResult> search(String query, {int limit = 20});
  Future<List<SearchSuggestion>> getSuggestions(String query);

  // Trending & Popular
  Future<List<TrendingSearch>> getTrendingSearches({int limit = 10});
  Future<List<PopularSearch>> getPopularSearches({int limit = 10});

  // History
  Future<List<SearchHistory>> getSearchHistory();
  Future<void> addToHistory(String query);
  Future<void> clearHistory();
  Future<void> removeFromHistory(String query);

  // Tracking
  Future<void> trackSearch(String query);
}
