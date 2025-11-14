import '../../../../core/network/dio_client.dart';
import '../../../../core/config/app_config.dart';
import '../models/search_model.dart';

abstract class SearchRemoteDataSource {
  Future<SearchResult> search(String query, {int limit = 20});
  Future<List<SearchSuggestion>> getSuggestions(String query);
  Future<List<TrendingSearch>> getTrendingSearches({int limit = 10});
  Future<List<PopularSearch>> getPopularSearches({int limit = 10});
  Future<void> trackSearch(String query);
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final DioClient _dioClient;

  SearchRemoteDataSourceImpl(this._dioClient);

  @override
  Future<SearchResult> search(String query, {int limit = 20}) async {
    try {
      final response = await _dioClient.get(
        '${AppConfig.productsEndpoint}/search',
        queryParameters: {
          'q': query,
          'limit': limit,
        },
      );

      return SearchResult.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<SearchSuggestion>> getSuggestions(String query) async {
    try {
      final response = await _dioClient.get(
        '${AppConfig.productsEndpoint}/search/suggest',
        queryParameters: {'q': query},
      );

      final List<dynamic> data = response.data['data'] as List;
      return data.map((json) => SearchSuggestion.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<TrendingSearch>> getTrendingSearches({int limit = 10}) async {
    try {
      final response = await _dioClient.get(
        '${AppConfig.productsEndpoint}/search/trending',
        queryParameters: {'limit': limit},
      );

      final List<dynamic> data = response.data['data'] as List;
      return data.map((json) => TrendingSearch.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PopularSearch>> getPopularSearches({int limit = 10}) async {
    try {
      final response = await _dioClient.get(
        '${AppConfig.productsEndpoint}/search/popular',
        queryParameters: {'limit': limit},
      );

      final List<dynamic> data = response.data['data'] as List;
      return data.map((json) => PopularSearch.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> trackSearch(String query) async {
    try {
      await _dioClient.post(
        '${AppConfig.productsEndpoint}/search/track',
        data: {'query': query},
      );
    } catch (e) {
      // Fail silently - tracking is not critical
    }
  }
}
