import '../repositories/search_repository.dart';
import '../../data/models/search_model.dart';

class ManageSearchHistoryUseCase {
  final SearchRepository repository;

  ManageSearchHistoryUseCase(this.repository);

  Future<List<SearchHistory>> getHistory() async {
    return await repository.getSearchHistory();
  }

  Future<void> addToHistory(String query) async {
    await repository.addToHistory(query);
  }

  Future<void> clearHistory() async {
    await repository.clearHistory();
  }

  Future<void> removeFromHistory(String query) async {
    await repository.removeFromHistory(query);
  }
}
