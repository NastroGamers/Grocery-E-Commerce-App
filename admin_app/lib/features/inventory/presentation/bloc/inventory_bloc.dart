import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/inventory_model.dart';
import 'package:dio/dio.dart';

// Events
abstract class InventoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadInventory extends InventoryEvent {
  final int page;
  final String? filter;

  LoadInventory({this.page = 1, this.filter});

  @override
  List<Object?> get props => [page, filter];
}

class UpdateStock extends InventoryEvent {
  final String productId;
  final int quantity;
  final String type;
  final String reason;

  UpdateStock({
    required this.productId,
    required this.quantity,
    required this.type,
    required this.reason,
  });

  @override
  List<Object?> get props => [productId, quantity, type, reason];
}

class SetStockLimits extends InventoryEvent {
  final String productId;
  final int minStock;
  final int maxStock;

  SetStockLimits({
    required this.productId,
    required this.minStock,
    required this.maxStock,
  });

  @override
  List<Object?> get props => [productId, minStock, maxStock];
}

class LoadLowStockAlerts extends InventoryEvent {}

class LoadStockHistory extends InventoryEvent {
  final String productId;
  final int page;

  LoadStockHistory({required this.productId, this.page = 1});

  @override
  List<Object?> get props => [productId, page];
}

// States
abstract class InventoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InventoryInitial extends InventoryState {}

class InventoryLoading extends InventoryState {}

class InventoryLoaded extends InventoryState {
  final List<InventoryItemModel> items;
  final bool hasMore;

  InventoryLoaded({required this.items, this.hasMore = true});

  @override
  List<Object?> get props => [items, hasMore];
}

class StockUpdated extends InventoryState {
  final String productId;

  StockUpdated(this.productId);

  @override
  List<Object?> get props => [productId];
}

class StockLimitsSet extends InventoryState {
  final String productId;

  StockLimitsSet(this.productId);

  @override
  List<Object?> get props => [productId];
}

class LowStockAlertsLoaded extends InventoryState {
  final List<LowStockAlertModel> alerts;

  LowStockAlertsLoaded(this.alerts);

  @override
  List<Object?> get props => [alerts];
}

class StockHistoryLoaded extends InventoryState {
  final List<StockAdjustmentModel> history;
  final bool hasMore;

  StockHistoryLoaded({required this.history, this.hasMore = true});

  @override
  List<Object?> get props => [history, hasMore];
}

class InventoryError extends InventoryState {
  final String message;

  InventoryError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final Dio dio;

  InventoryBloc({required this.dio}) : super(InventoryInitial()) {
    on<LoadInventory>(_onLoadInventory);
    on<UpdateStock>(_onUpdateStock);
    on<SetStockLimits>(_onSetStockLimits);
    on<LoadLowStockAlerts>(_onLoadLowStockAlerts);
    on<LoadStockHistory>(_onLoadStockHistory);
  }

  Future<void> _onLoadInventory(
    LoadInventory event,
    Emitter<InventoryState> emit,
  ) async {
    emit(InventoryLoading());

    try {
      final response = await dio.get(
        '/admin/inventory',
        queryParameters: {
          'page': event.page,
          'limit': 20,
          if (event.filter != null) 'filter': event.filter,
        },
      );

      final items = (response.data['data'] as List)
          .map((json) => InventoryItemModel.fromJson(json))
          .toList();

      emit(InventoryLoaded(items: items, hasMore: items.length >= 20));
    } catch (e) {
      emit(InventoryError(e.toString()));
    }
  }

  Future<void> _onUpdateStock(
    UpdateStock event,
    Emitter<InventoryState> emit,
  ) async {
    try {
      await dio.put(
        '/admin/inventory/${event.productId}/stock',
        data: {
          'quantity': event.quantity,
          'type': event.type,
          'reason': event.reason,
        },
      );

      emit(StockUpdated(event.productId));
    } catch (e) {
      emit(InventoryError(e.toString()));
    }
  }

  Future<void> _onSetStockLimits(
    SetStockLimits event,
    Emitter<InventoryState> emit,
  ) async {
    try {
      await dio.put(
        '/admin/inventory/${event.productId}/limits',
        data: {
          'minStock': event.minStock,
          'maxStock': event.maxStock,
        },
      );

      emit(StockLimitsSet(event.productId));
    } catch (e) {
      emit(InventoryError(e.toString()));
    }
  }

  Future<void> _onLoadLowStockAlerts(
    LoadLowStockAlerts event,
    Emitter<InventoryState> emit,
  ) async {
    emit(InventoryLoading());

    try {
      final response = await dio.get('/admin/inventory/low-stock-alerts');

      final alerts = (response.data['data'] as List)
          .map((json) => LowStockAlertModel.fromJson(json))
          .toList();

      emit(LowStockAlertsLoaded(alerts));
    } catch (e) {
      emit(InventoryError(e.toString()));
    }
  }

  Future<void> _onLoadStockHistory(
    LoadStockHistory event,
    Emitter<InventoryState> emit,
  ) async {
    emit(InventoryLoading());

    try {
      final response = await dio.get(
        '/admin/inventory/${event.productId}/history',
        queryParameters: {
          'page': event.page,
          'limit': 50,
        },
      );

      final history = (response.data['data'] as List)
          .map((json) => StockAdjustmentModel.fromJson(json))
          .toList();

      emit(StockHistoryLoaded(history: history, hasMore: history.length >= 50));
    } catch (e) {
      emit(InventoryError(e.toString()));
    }
  }
}
