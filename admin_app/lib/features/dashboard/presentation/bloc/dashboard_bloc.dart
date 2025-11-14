import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/dashboard_stats_model.dart';
import '../../data/datasources/dashboard_remote_datasource.dart';

// Events
abstract class DashboardEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadDashboardStats extends DashboardEvent {
  final DateTime? startDate;
  final DateTime? endDate;

  LoadDashboardStats({this.startDate, this.endDate});

  @override
  List<Object?> get props => [startDate, endDate];
}

class LoadSalesChart extends DashboardEvent {
  final String period; // 'day', 'week', 'month', 'year'

  LoadSalesChart({this.period = 'week'});

  @override
  List<Object?> get props => [period];
}

class LoadTopProducts extends DashboardEvent {
  final int limit;
  final String period;

  LoadTopProducts({this.limit = 10, this.period = 'month'});

  @override
  List<Object?> get props => [limit, period];
}

class LoadRecentActivities extends DashboardEvent {
  final int page;
  final int limit;

  LoadRecentActivities({this.page = 1, this.limit = 20});

  @override
  List<Object?> get props => [page, limit];
}

class LoadRevenueByCategory extends DashboardEvent {}

class RefreshDashboard extends DashboardEvent {}

// States
abstract class DashboardState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardStatsLoaded extends DashboardState {
  final DashboardStatsModel stats;

  DashboardStatsLoaded(this.stats);

  @override
  List<Object?> get props => [stats];
}

class SalesChartLoaded extends DashboardState {
  final List<SalesChartModel> chartData;
  final String period;

  SalesChartLoaded({required this.chartData, required this.period});

  @override
  List<Object?> get props => [chartData, period];
}

class TopProductsLoaded extends DashboardState {
  final List<TopProductModel> products;

  TopProductsLoaded(this.products);

  @override
  List<Object?> get props => [products];
}

class RecentActivitiesLoaded extends DashboardState {
  final List<RecentActivityModel> activities;
  final bool hasMore;

  RecentActivitiesLoaded({required this.activities, this.hasMore = true});

  @override
  List<Object?> get props => [activities, hasMore];
}

class RevenueByCategoryLoaded extends DashboardState {
  final List<RevenueByCategoryModel> data;

  RevenueByCategoryLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class DashboardError extends DashboardState {
  final String message;

  DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRemoteDataSource dataSource;

  DashboardBloc({required this.dataSource}) : super(DashboardInitial()) {
    on<LoadDashboardStats>(_onLoadDashboardStats);
    on<LoadSalesChart>(_onLoadSalesChart);
    on<LoadTopProducts>(_onLoadTopProducts);
    on<LoadRecentActivities>(_onLoadRecentActivities);
    on<LoadRevenueByCategory>(_onLoadRevenueByCategory);
    on<RefreshDashboard>(_onRefreshDashboard);
  }

  Future<void> _onLoadDashboardStats(
    LoadDashboardStats event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());

    try {
      final stats = await dataSource.getDashboardStats(event.startDate, event.endDate);
      emit(DashboardStatsLoaded(stats));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> _onLoadSalesChart(
    LoadSalesChart event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());

    try {
      final chartData = await dataSource.getSalesChart(event.period);
      emit(SalesChartLoaded(chartData: chartData, period: event.period));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> _onLoadTopProducts(
    LoadTopProducts event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());

    try {
      final products = await dataSource.getTopProducts(event.limit, event.period);
      emit(TopProductsLoaded(products));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> _onLoadRecentActivities(
    LoadRecentActivities event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());

    try {
      final activities = await dataSource.getRecentActivities(event.page, event.limit);
      emit(RecentActivitiesLoaded(
        activities: activities,
        hasMore: activities.length >= event.limit,
      ));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> _onLoadRevenueByCategory(
    LoadRevenueByCategory event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());

    try {
      final data = await dataSource.getRevenueByCategory();
      emit(RevenueByCategoryLoaded(data));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> _onRefreshDashboard(
    RefreshDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    // Trigger reload of all dashboard data
    add(LoadDashboardStats());
  }
}
