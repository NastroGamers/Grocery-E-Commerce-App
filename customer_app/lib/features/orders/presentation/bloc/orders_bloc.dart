import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../checkout/data/models/order_model.dart';
import '../../data/models/order_history_model.dart';
import '../../domain/usecases/manage_orders_usecase.dart';

// Events
abstract class OrdersEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadOrdersEvent extends OrdersEvent {
  final int page;
  final int limit;
  final OrderFilter? filter;

  LoadOrdersEvent({
    this.page = 1,
    this.limit = 10,
    this.filter,
  });

  @override
  List<Object?> get props => [page, limit, filter];
}

class LoadMoreOrdersEvent extends OrdersEvent {}

class LoadOrderDetailsEvent extends OrdersEvent {
  final String orderId;

  LoadOrderDetailsEvent({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class ReorderEvent extends OrdersEvent {
  final String orderId;
  final List<String>? excludeProductIds;

  ReorderEvent({
    required this.orderId,
    this.excludeProductIds,
  });

  @override
  List<Object?> get props => [orderId, excludeProductIds];
}

class LoadRecentOrdersEvent extends OrdersEvent {
  final int limit;

  LoadRecentOrdersEvent({this.limit = 5});

  @override
  List<Object?> get props => [limit];
}

class FilterOrdersEvent extends OrdersEvent {
  final OrderFilter filter;

  FilterOrdersEvent({required this.filter});

  @override
  List<Object?> get props => [filter];
}

class RefreshOrdersEvent extends OrdersEvent {}

// States
abstract class OrdersState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OrdersInitial extends OrdersState {}

class OrdersLoading extends OrdersState {}

class OrdersLoaded extends OrdersState {
  final List<OrderModel> orders;
  final int total;
  final int page;
  final bool hasMore;
  final OrderFilter? activeFilter;

  OrdersLoaded({
    required this.orders,
    required this.total,
    required this.page,
    required this.hasMore,
    this.activeFilter,
  });

  @override
  List<Object?> get props => [orders, total, page, hasMore, activeFilter];

  OrdersLoaded copyWith({
    List<OrderModel>? orders,
    int? total,
    int? page,
    bool? hasMore,
    OrderFilter? activeFilter,
  }) {
    return OrdersLoaded(
      orders: orders ?? this.orders,
      total: total ?? this.total,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      activeFilter: activeFilter ?? this.activeFilter,
    );
  }
}

class OrdersLoadingMore extends OrdersState {
  final List<OrderModel> currentOrders;

  OrdersLoadingMore({required this.currentOrders});

  @override
  List<Object?> get props => [currentOrders];
}

class OrderDetailsLoaded extends OrdersState {
  final OrderModel order;

  OrderDetailsLoaded({required this.order});

  @override
  List<Object?> get props => [order];
}

class ReorderSuccess extends OrdersState {
  final ReorderResponse response;

  ReorderSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

class RecentOrdersLoaded extends OrdersState {
  final List<OrderModel> orders;

  RecentOrdersLoaded({required this.orders});

  @override
  List<Object?> get props => [orders];
}

class OrdersError extends OrdersState {
  final String message;

  OrdersError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Bloc
class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final ManageOrdersUseCase manageOrdersUseCase;

  OrdersBloc({
    required this.manageOrdersUseCase,
  }) : super(OrdersInitial()) {
    on<LoadOrdersEvent>(_onLoadOrders);
    on<LoadMoreOrdersEvent>(_onLoadMoreOrders);
    on<LoadOrderDetailsEvent>(_onLoadOrderDetails);
    on<ReorderEvent>(_onReorder);
    on<LoadRecentOrdersEvent>(_onLoadRecentOrders);
    on<FilterOrdersEvent>(_onFilterOrders);
    on<RefreshOrdersEvent>(_onRefreshOrders);
  }

  Future<void> _onLoadOrders(
    LoadOrdersEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(OrdersLoading());
    try {
      final response = await manageOrdersUseCase.getOrderHistory(
        page: event.page,
        limit: event.limit,
        filter: event.filter,
      );

      emit(OrdersLoaded(
        orders: response.orders,
        total: response.total,
        page: response.page,
        hasMore: response.hasMore,
        activeFilter: event.filter,
      ));
    } catch (e) {
      emit(OrdersError(message: e.toString()));
    }
  }

  Future<void> _onLoadMoreOrders(
    LoadMoreOrdersEvent event,
    Emitter<OrdersState> emit,
  ) async {
    if (state is OrdersLoaded) {
      final currentState = state as OrdersLoaded;

      if (!currentState.hasMore) {
        return;
      }

      emit(OrdersLoadingMore(currentOrders: currentState.orders));

      try {
        final response = await manageOrdersUseCase.getOrderHistory(
          page: currentState.page + 1,
          limit: 10,
          filter: currentState.activeFilter,
        );

        emit(OrdersLoaded(
          orders: [...currentState.orders, ...response.orders],
          total: response.total,
          page: response.page,
          hasMore: response.hasMore,
          activeFilter: currentState.activeFilter,
        ));
      } catch (e) {
        emit(OrdersError(message: e.toString()));
        emit(currentState);
      }
    }
  }

  Future<void> _onLoadOrderDetails(
    LoadOrderDetailsEvent event,
    Emitter<OrdersState> emit,
  ) async {
    final previousState = state;
    emit(OrdersLoading());

    try {
      final order = await manageOrdersUseCase.getOrderDetails(event.orderId);

      emit(OrderDetailsLoaded(order: order));

      if (previousState is OrdersLoaded) {
        emit(previousState);
      }
    } catch (e) {
      emit(OrdersError(message: e.toString()));

      if (previousState is OrdersLoaded) {
        emit(previousState);
      }
    }
  }

  Future<void> _onReorder(
    ReorderEvent event,
    Emitter<OrdersState> emit,
  ) async {
    final previousState = state;
    emit(OrdersLoading());

    try {
      final response = await manageOrdersUseCase.reorder(
        orderId: event.orderId,
        excludeProductIds: event.excludeProductIds,
      );

      emit(ReorderSuccess(response: response));

      if (previousState is OrdersLoaded) {
        emit(previousState);
      }
    } catch (e) {
      emit(OrdersError(message: e.toString()));

      if (previousState is OrdersLoaded) {
        emit(previousState);
      }
    }
  }

  Future<void> _onLoadRecentOrders(
    LoadRecentOrdersEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(OrdersLoading());
    try {
      final orders = await manageOrdersUseCase.getRecentOrders(
        limit: event.limit,
      );

      emit(RecentOrdersLoaded(orders: orders));
    } catch (e) {
      emit(OrdersError(message: e.toString()));
    }
  }

  Future<void> _onFilterOrders(
    FilterOrdersEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(OrdersLoading());
    try {
      final response = await manageOrdersUseCase.getOrderHistory(
        page: 1,
        limit: 10,
        filter: event.filter,
      );

      emit(OrdersLoaded(
        orders: response.orders,
        total: response.total,
        page: response.page,
        hasMore: response.hasMore,
        activeFilter: event.filter,
      ));
    } catch (e) {
      emit(OrdersError(message: e.toString()));
    }
  }

  Future<void> _onRefreshOrders(
    RefreshOrdersEvent event,
    Emitter<OrdersState> emit,
  ) async {
    if (state is OrdersLoaded) {
      final currentState = state as OrdersLoaded;

      try {
        final response = await manageOrdersUseCase.getOrderHistory(
          page: 1,
          limit: 10,
          filter: currentState.activeFilter,
        );

        emit(OrdersLoaded(
          orders: response.orders,
          total: response.total,
          page: response.page,
          hasMore: response.hasMore,
          activeFilter: currentState.activeFilter,
        ));
      } catch (e) {
        emit(OrdersError(message: e.toString()));
        emit(currentState);
      }
    } else {
      add(LoadOrdersEvent());
    }
  }
}
