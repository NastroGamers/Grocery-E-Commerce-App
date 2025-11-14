import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/search_model.dart';

abstract class SearchLocalDataSource {
  Future<List<SearchHistory>> getSearchHistory();
  Future<void> addToHistory(String query);
  Future<void> clearHistory();
  Future<void> removeFromHistory(String query);
}

class SearchLocalDataSourceImpl implements SearchLocalDataSource {
  final SharedPreferences _sharedPreferences;
  static const String _searchHistoryKey = 'search_history';
  static const int _maxHistoryItems = 20;

  SearchLocalDataSourceImpl(this._sharedPreferences);

  @override
  Future<List<SearchHistory>> getSearchHistory() async {
    try {
      final historyJson = _sharedPreferences.getStringList(_searchHistoryKey);
      if (historyJson == null) return [];

      return historyJson
          .map((item) => SearchHistory.fromJson(json.decode(item)))
          .toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp)); // Most recent first
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> addToHistory(String query) async {
    try {
      if (query.trim().isEmpty) return;

      final history = await getSearchHistory();

      // Remove duplicate if exists
      history.removeWhere((item) => item.query.toLowerCase() == query.toLowerCase());

      // Add new item at the beginning
      history.insert(
        0,
        SearchHistory(
          query: query.trim(),
          timestamp: DateTime.now(),
        ),
      );

      // Limit history size
      if (history.length > _maxHistoryItems) {
        history.removeRange(_maxHistoryItems, history.length);
      }

      // Save to storage
      final historyJson = history.map((item) => json.encode(item.toJson())).toList();
      await _sharedPreferences.setStringList(_searchHistoryKey, historyJson);
    } catch (e) {
      // Fail silently
    }
  }

  @override
  Future<void> clearHistory() async {
    try {
      await _sharedPreferences.remove(_searchHistoryKey);
    } catch (e) {
      // Fail silently
    }
  }

  @override
  Future<void> removeFromHistory(String query) async {
    try {
      final history = await getSearchHistory();
      history.removeWhere((item) => item.query.toLowerCase() == query.toLowerCase());

      final historyJson = history.map((item) => json.encode(item.toJson())).toList();
      await _sharedPreferences.setStringList(_searchHistoryKey, historyJson);
    } catch (e) {
      // Fail silently
    }
  }
}
