import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/admin_order_model.dart';
import 'package:dio/dio.dart';

// Events
abstract class AdminOrdersEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadOrders extends AdminOrdersEvent {
  final int page;
  final String? status;
  final String? dateFilter;

  LoadOrders({this.page = 1, this.status, this.dateFilter});

  @override
  List<Object?> get props => [page, status, dateFilter];
}

class LoadOrderDetails extends AdminOrdersEvent {
  final String orderId;

  LoadOrderDetails(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class UpdateOrderStatus extends AdminOrdersEvent {
  final String orderId;
  final String status;

  UpdateOrderStatus({required this.orderId, required this.status});

  @override
  List<Object?> get props => [orderId, status];
}

class AssignDeliveryPerson extends AdminOrdersEvent {
  final String orderId;
  final String deliveryPersonId;

  AssignDeliveryPerson({required this.orderId, required this.deliveryPersonId});

  @override
  List<Object?> get props => [orderId, deliveryPersonId];
}

class CancelOrder extends AdminOrdersEvent {
  final String orderId;
  final String reason;
  final double refundAmount;

  CancelOrder({
    required this.orderId,
    required this.reason,
    required this.refundAmount,
  });

  @override
  List<Object?> get props => [orderId, reason, refundAmount];
}

// States
abstract class AdminOrdersState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AdminOrdersInitial extends AdminOrdersState {}

class AdminOrdersLoading extends AdminOrdersState {}

class OrdersLoaded extends AdminOrdersState {
  final List<AdminOrderModel> orders;
  final bool hasMore;

  OrdersLoaded({required this.orders, this.hasMore = true});

  @override
  List<Object?> get props => [orders, hasMore];
}

class OrderDetailsLoaded extends AdminOrdersState {
  final AdminOrderModel order;

  OrderDetailsLoaded(this.order);

  @override
  List<Object?> get props => [order];
}

class OrderStatusUpdated extends AdminOrdersState {
  final String orderId;
  final String status;

  OrderStatusUpdated({required this.orderId, required this.status});

  @override
  List<Object?> get props => [orderId, status];
}

class DeliveryPersonAssigned extends AdminOrdersState {
  final String orderId;

  DeliveryPersonAssigned(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class OrderCancelled extends AdminOrdersState {
  final String orderId;

  OrderCancelled(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class AdminOrdersError extends AdminOrdersState {
  final String message;

  AdminOrdersError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class AdminOrdersBloc extends Bloc<AdminOrdersEvent, AdminOrdersState> {
  final Dio dio;

  AdminOrdersBloc({required this.dio}) : super(AdminOrdersInitial()) {
    on<LoadOrders>(_onLoadOrders);
    on<LoadOrderDetails>(_onLoadOrderDetails);
    on<UpdateOrderStatus>(_onUpdateOrderStatus);
    on<AssignDeliveryPerson>(_onAssignDeliveryPerson);
    on<CancelOrder>(_onCancelOrder);
  }

  Future<void> _onLoadOrders(
    LoadOrders event,
    Emitter<AdminOrdersState> emit,
  ) async {
    emit(AdminOrdersLoading());

    try {
      final response = await dio.get(
        '/admin/orders',
        queryParameters: {
          'page': event.page,
          'limit': 20,
          if (event.status != null) 'status': event.status,
          if (event.dateFilter != null) 'date': event.dateFilter,
        },
      );

      final orders = (response.data['data'] as List)
          .map((json) => AdminOrderModel.fromJson(json))
          .toList();

      emit(OrdersLoaded(orders: orders, hasMore: orders.length >= 20));
    } catch (e) {
      emit(AdminOrdersError(e.toString()));
    }
  }

  Future<void> _onLoadOrderDetails(
    LoadOrderDetails event,
    Emitter<AdminOrdersState> emit,
  ) async {
    emit(AdminOrdersLoading());

    try {
      final response = await dio.get('/admin/orders/${event.orderId}');
      final order = AdminOrderModel.fromJson(response.data['data']);
      emit(OrderDetailsLoaded(order));
    } catch (e) {
      emit(AdminOrdersError(e.toString()));
    }
  }

  Future<void> _onUpdateOrderStatus(
    UpdateOrderStatus event,
    Emitter<AdminOrdersState> emit,
  ) async {
    try {
      await dio.put(
        '/admin/orders/${event.orderId}/status',
        data: {'status': event.status},
      );

      emit(OrderStatusUpdated(orderId: event.orderId, status: event.status));
    } catch (e) {
      emit(AdminOrdersError(e.toString()));
    }
  }

  Future<void> _onAssignDeliveryPerson(
    AssignDeliveryPerson event,
    Emitter<AdminOrdersState> emit,
  ) async {
    try {
      await dio.put(
        '/admin/orders/${event.orderId}/assign',
        data: {'deliveryPersonId': event.deliveryPersonId},
      );

      emit(DeliveryPersonAssigned(event.orderId));
    } catch (e) {
      emit(AdminOrdersError(e.toString()));
    }
  }

  Future<void> _onCancelOrder(
    CancelOrder event,
    Emitter<AdminOrdersState> emit,
  ) async {
    try {
      await dio.put(
        '/admin/orders/${event.orderId}/cancel',
        data: {
          'reason': event.reason,
          'refundAmount': event.refundAmount,
        },
      );

      emit(OrderCancelled(event.orderId));
    } catch (e) {
      emit(AdminOrdersError(e.toString()));
    }
  }
}
