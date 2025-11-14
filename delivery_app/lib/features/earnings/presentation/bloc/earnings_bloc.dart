import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/earnings_model.dart';
import 'package:dio/dio.dart';

// Events
abstract class EarningsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadEarnings extends EarningsEvent {
  final String period; // 'today', 'week', 'month', 'all'

  LoadEarnings({this.period = 'all'});

  @override
  List<Object?> get props => [period];
}

class LoadDeliveryStats extends EarningsEvent {}

class LoadRatings extends EarningsEvent {
  final int page;

  LoadRatings({this.page = 1});

  @override
  List<Object?> get props => [page];
}

class RequestPayout extends EarningsEvent {
  final PayoutRequestModel request;

  RequestPayout(this.request);

  @override
  List<Object?> get props => [request];
}

class LoadPayoutHistory extends EarningsEvent {
  final int page;

  LoadPayoutHistory({this.page = 1});

  @override
  List<Object?> get props => [page];
}

// States
abstract class EarningsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EarningsInitial extends EarningsState {}

class EarningsLoading extends EarningsState {}

class EarningsLoaded extends EarningsState {
  final EarningsModel earnings;

  EarningsLoaded(this.earnings);

  @override
  List<Object?> get props => [earnings];
}

class DeliveryStatsLoaded extends EarningsState {
  final DeliveryStatsModel stats;

  DeliveryStatsLoaded(this.stats);

  @override
  List<Object?> get props => [stats];
}

class RatingsLoaded extends EarningsState {
  final List<DeliveryRatingModel> ratings;
  final bool hasMore;

  RatingsLoaded({required this.ratings, this.hasMore = true});

  @override
  List<Object?> get props => [ratings, hasMore];
}

class PayoutRequested extends EarningsState {
  final String requestId;

  PayoutRequested(this.requestId);

  @override
  List<Object?> get props => [requestId];
}

class PayoutHistoryLoaded extends EarningsState {
  final List<PayoutHistoryModel> history;
  final bool hasMore;

  PayoutHistoryLoaded({required this.history, this.hasMore = true});

  @override
  List<Object?> get props => [history, hasMore];
}

class EarningsError extends EarningsState {
  final String message;

  EarningsError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class EarningsBloc extends Bloc<EarningsEvent, EarningsState> {
  final Dio dio;

  EarningsBloc({required this.dio}) : super(EarningsInitial()) {
    on<LoadEarnings>(_onLoadEarnings);
    on<LoadDeliveryStats>(_onLoadDeliveryStats);
    on<LoadRatings>(_onLoadRatings);
    on<RequestPayout>(_onRequestPayout);
    on<LoadPayoutHistory>(_onLoadPayoutHistory);
  }

  Future<void> _onLoadEarnings(
    LoadEarnings event,
    Emitter<EarningsState> emit,
  ) async {
    emit(EarningsLoading());

    try {
      final response = await dio.get(
        '/delivery/earnings',
        queryParameters: {'period': event.period},
      );

      final earnings = EarningsModel.fromJson(response.data['data']);
      emit(EarningsLoaded(earnings));
    } catch (e) {
      emit(EarningsError(e.toString()));
    }
  }

  Future<void> _onLoadDeliveryStats(
    LoadDeliveryStats event,
    Emitter<EarningsState> emit,
  ) async {
    emit(EarningsLoading());

    try {
      final response = await dio.get('/delivery/stats');
      final stats = DeliveryStatsModel.fromJson(response.data['data']);
      emit(DeliveryStatsLoaded(stats));
    } catch (e) {
      emit(EarningsError(e.toString()));
    }
  }

  Future<void> _onLoadRatings(
    LoadRatings event,
    Emitter<EarningsState> emit,
  ) async {
    emit(EarningsLoading());

    try {
      final response = await dio.get(
        '/delivery/ratings',
        queryParameters: {'page': event.page, 'limit': 20},
      );

      final ratings = (response.data['data'] as List)
          .map((json) => DeliveryRatingModel.fromJson(json))
          .toList();

      emit(RatingsLoaded(ratings: ratings, hasMore: ratings.length >= 20));
    } catch (e) {
      emit(EarningsError(e.toString()));
    }
  }

  Future<void> _onRequestPayout(
    RequestPayout event,
    Emitter<EarningsState> emit,
  ) async {
    try {
      final response = await dio.post(
        '/delivery/payout/request',
        data: event.request.toJson(),
      );

      emit(PayoutRequested(response.data['requestId']));
    } catch (e) {
      emit(EarningsError(e.toString()));
    }
  }

  Future<void> _onLoadPayoutHistory(
    LoadPayoutHistory event,
    Emitter<EarningsState> emit,
  ) async {
    emit(EarningsLoading());

    try {
      final response = await dio.get(
        '/delivery/payout/history',
        queryParameters: {'page': event.page, 'limit': 20},
      );

      final history = (response.data['data'] as List)
          .map((json) => PayoutHistoryModel.fromJson(json))
          .toList();

      emit(PayoutHistoryLoaded(history: history, hasMore: history.length >= 20));
    } catch (e) {
      emit(EarningsError(e.toString()));
    }
  }
}
