import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/search_model.dart';
import '../../domain/usecases/search_products_usecase.dart';
import '../../domain/usecases/get_search_suggestions_usecase.dart';
import '../../domain/usecases/get_trending_searches_usecase.dart';
import '../../domain/usecases/manage_search_history_usecase.dart';

// Events
abstract class SearchEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchQueryChangedEvent extends SearchEvent {
  final String query;

  SearchQueryChangedEvent({required this.query});

  @override
  List<Object?> get props => [query];
}

class SearchSubmittedEvent extends SearchEvent {
  final String query;

  SearchSubmittedEvent({required this.query});

  @override
  List<Object?> get props => [query];
}

class LoadSearchSuggestionsEvent extends SearchEvent {
  final String query;

  LoadSearchSuggestionsEvent({required this.query});

  @override
  List<Object?> get props => [query];
}

class LoadTrendingSearchesEvent extends SearchEvent {}

class LoadSearchHistoryEvent extends SearchEvent {}

class ClearSearchHistoryEvent extends SearchEvent {}

class RemoveFromHistoryEvent extends SearchEvent {
  final String query;

  RemoveFromHistoryEvent({required this.query});

  @override
  List<Object?> get props => [query];
}

class ClearSearchEvent extends SearchEvent {}

// States
abstract class SearchState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SuggestionsLoading extends SearchState {
  final String query;

  SuggestionsLoading({required this.query});

  @override
  List<Object?> get props => [query];
}

class SuggestionsLoaded extends SearchState {
  final List<SearchSuggestion> suggestions;
  final String query;

  SuggestionsLoaded({
    required this.suggestions,
    required this.query,
  });

  @override
  List<Object?> get props => [suggestions, query];
}

class SearchResultsLoaded extends SearchState {
  final SearchResult results;
  final String query;

  SearchResultsLoaded({
    required this.results,
    required this.query,
  });

  @override
  List<Object?> get props => [results, query];
}

class SearchHistoryLoaded extends SearchState {
  final List<SearchHistory> history;

  SearchHistoryLoaded({required this.history});

  @override
  List<Object?> get props => [history];
}

class TrendingSearchesLoaded extends SearchState {
  final List<TrendingSearch> trending;

  TrendingSearchesLoaded({required this.trending});

  @override
  List<Object?> get props => [trending];
}

class SearchEmpty extends SearchState {
  final String query;
  final String message;

  SearchEmpty({
    required this.query,
    this.message = 'No results found',
  });

  @override
  List<Object?> get props => [query, message];
}

class SearchError extends SearchState {
  final String message;

  SearchError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Bloc with debouncing
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchProductsUseCase searchProductsUseCase;
  final GetSearchSuggestionsUseCase getSearchSuggestionsUseCase;
  final GetTrendingSearchesUseCase getTrendingSearchesUseCase;
  final ManageSearchHistoryUseCase manageSearchHistoryUseCase;

  Timer? _debounceTimer;
  static const Duration _debounceDuration = Duration(milliseconds: 300);

  SearchBloc({
    required this.searchProductsUseCase,
    required this.getSearchSuggestionsUseCase,
    required this.getTrendingSearchesUseCase,
    required this.manageSearchHistoryUseCase,
  }) : super(SearchInitial()) {
    on<SearchQueryChangedEvent>(_onSearchQueryChanged);
    on<SearchSubmittedEvent>(_onSearchSubmitted);
    on<LoadSearchSuggestionsEvent>(_onLoadSearchSuggestions);
    on<LoadTrendingSearchesEvent>(_onLoadTrendingSearches);
    on<LoadSearchHistoryEvent>(_onLoadSearchHistory);
    on<ClearSearchHistoryEvent>(_onClearSearchHistory);
    on<RemoveFromHistoryEvent>(_onRemoveFromHistory);
    on<ClearSearchEvent>(_onClearSearch);
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }

  void _onSearchQueryChanged(
    SearchQueryChangedEvent event,
    Emitter<SearchState> emit,
  ) {
    // Cancel previous timer
    _debounceTimer?.cancel();

    final query = event.query.trim();

    // If query is empty, load trending or history
    if (query.isEmpty) {
      add(LoadTrendingSearchesEvent());
      return;
    }

    // Show loading state with current query
    emit(SuggestionsLoading(query: query));

    // Debounce: wait before making API call
    _debounceTimer = Timer(_debounceDuration, () {
      add(LoadSearchSuggestionsEvent(query: query));
    });
  }

  Future<void> _onLoadSearchSuggestions(
    LoadSearchSuggestionsEvent event,
    Emitter<SearchState> emit,
  ) async {
    try {
      final suggestions = await getSearchSuggestionsUseCase.execute(event.query);

      emit(SuggestionsLoaded(
        suggestions: suggestions,
        query: event.query,
      ));
    } catch (e) {
      emit(SearchError(message: 'Failed to load suggestions'));
    }
  }

  Future<void> _onSearchSubmitted(
    SearchSubmittedEvent event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.query.trim();

    if (query.isEmpty) {
      emit(SearchError(message: 'Please enter a search term'));
      return;
    }

    emit(SearchLoading());

    try {
      final results = await searchProductsUseCase.execute(query);

      if (!results.hasResults) {
        emit(SearchEmpty(
          query: query,
          message: results.hasCorrections
              ? 'Did you mean: ${results.corrections.join(", ")}?'
              : 'No results found for "$query"',
        ));
        return;
      }

      emit(SearchResultsLoaded(
        results: results,
        query: query,
      ));
    } catch (e) {
      emit(SearchError(message: e.toString()));
    }
  }

  Future<void> _onLoadTrendingSearches(
    LoadTrendingSearchesEvent event,
    Emitter<SearchState> emit,
  ) async {
    try {
      final trending = await getTrendingSearchesUseCase.execute(limit: 10);
      emit(TrendingSearchesLoaded(trending: trending));
    } catch (e) {
      // Try loading history instead
      add(LoadSearchHistoryEvent());
    }
  }

  Future<void> _onLoadSearchHistory(
    LoadSearchHistoryEvent event,
    Emitter<SearchState> emit,
  ) async {
    try {
      final history = await manageSearchHistoryUseCase.getHistory();
      emit(SearchHistoryLoaded(history: history));
    } catch (e) {
      emit(SearchError(message: 'Failed to load search history'));
    }
  }

  Future<void> _onClearSearchHistory(
    ClearSearchHistoryEvent event,
    Emitter<SearchState> emit,
  ) async {
    try {
      await manageSearchHistoryUseCase.clearHistory();
      emit(SearchHistoryLoaded(history: []));
    } catch (e) {
      emit(SearchError(message: 'Failed to clear history'));
    }
  }

  Future<void> _onRemoveFromHistory(
    RemoveFromHistoryEvent event,
    Emitter<SearchState> emit,
  ) async {
    try {
      await manageSearchHistoryUseCase.removeFromHistory(event.query);
      final history = await manageSearchHistoryUseCase.getHistory();
      emit(SearchHistoryLoaded(history: history));
    } catch (e) {
      emit(SearchError(message: 'Failed to remove from history'));
    }
  }

  void _onClearSearch(
    ClearSearchEvent event,
    Emitter<SearchState> emit,
  ) {
    _debounceTimer?.cancel();
    emit(SearchInitial());
  }
}
