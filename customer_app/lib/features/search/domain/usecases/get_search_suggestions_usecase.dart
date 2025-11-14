import '../repositories/search_repository.dart';
import '../../data/models/search_model.dart';

class GetSearchSuggestionsUseCase {
  final SearchRepository repository;

  GetSearchSuggestionsUseCase(this.repository);

  Future<List<SearchSuggestion>> execute(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }

    return await repository.getSuggestions(query.trim());
  }
}
