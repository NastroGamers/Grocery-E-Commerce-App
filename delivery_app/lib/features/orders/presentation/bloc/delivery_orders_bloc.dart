import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/assigned_order_model.dart';
import 'package:dio/dio.dart';

// Events
abstract class DeliveryOrdersEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadAssignedOrders extends DeliveryOrdersEvent {
  final String? status;

  LoadAssignedOrders({this.status});

  @override
  List<Object?> get props => [status];
}

class AcceptOrder extends DeliveryOrdersEvent {
  final String orderId;

  AcceptOrder(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class RejectOrder extends DeliveryOrdersEvent {
  final String orderId;
  final String reason;

  RejectOrder({required this.orderId, required this.reason});

  @override
  List<Object?> get props => [orderId, reason];
}

class ConfirmPickup extends DeliveryOrdersEvent {
  final String orderId;
  final int itemsCount;
  final String verificationCode;
  final List<String>? images;

  ConfirmPickup({
    required this.orderId,
    required this.itemsCount,
    required this.verificationCode,
    this.images,
  });

  @override
  List<Object?> get props => [orderId, itemsCount, verificationCode, images];
}

class StartDelivery extends DeliveryOrdersEvent {
  final String orderId;

  StartDelivery(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class ConfirmDelivery extends DeliveryOrdersEvent {
  final String orderId;
  final String otp;
  final String? signature;
  final List<String>? images;

  ConfirmDelivery({
    required this.orderId,
    required this.otp,
    this.signature,
    this.images,
  });

  @override
  List<Object?> get props => [orderId, otp, signature, images];
}

class ReportIssue extends DeliveryOrdersEvent {
  final String orderId;
  final String issue;
  final List<String>? images;

  ReportIssue({required this.orderId, required this.issue, this.images});

  @override
  List<Object?> get props => [orderId, issue, images];
}

// States
abstract class DeliveryOrdersState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DeliveryOrdersInitial extends DeliveryOrdersState {}

class DeliveryOrdersLoading extends DeliveryOrdersState {}

class AssignedOrdersLoaded extends DeliveryOrdersState {
  final List<AssignedOrderModel> orders;

  AssignedOrdersLoaded(this.orders);

  @override
  List<Object?> get props => [orders];
}

class OrderAccepted extends DeliveryOrdersState {
  final String orderId;

  OrderAccepted(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class OrderRejected extends DeliveryOrdersState {
  final String orderId;

  OrderRejected(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class PickupConfirmed extends DeliveryOrdersState {
  final String orderId;

  PickupConfirmed(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class DeliveryStarted extends DeliveryOrdersState {
  final String orderId;

  DeliveryStarted(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class DeliveryCompleted extends DeliveryOrdersState {
  final String orderId;

  DeliveryCompleted(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class IssueReported extends DeliveryOrdersState {
  final String orderId;

  IssueReported(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class DeliveryOrdersError extends DeliveryOrdersState {
  final String message;

  DeliveryOrdersError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class DeliveryOrdersBloc extends Bloc<DeliveryOrdersEvent, DeliveryOrdersState> {
  final Dio dio;

  DeliveryOrdersBloc({required this.dio}) : super(DeliveryOrdersInitial()) {
    on<LoadAssignedOrders>(_onLoadAssignedOrders);
    on<AcceptOrder>(_onAcceptOrder);
    on<RejectOrder>(_onRejectOrder);
    on<ConfirmPickup>(_onConfirmPickup);
    on<StartDelivery>(_onStartDelivery);
    on<ConfirmDelivery>(_onConfirmDelivery);
    on<ReportIssue>(_onReportIssue);
  }

  Future<void> _onLoadAssignedOrders(
    LoadAssignedOrders event,
    Emitter<DeliveryOrdersState> emit,
  ) async {
    emit(DeliveryOrdersLoading());

    try {
      final response = await dio.get(
        '/delivery/orders/assigned',
        queryParameters: {
          if (event.status != null) 'status': event.status,
        },
      );

      final orders = (response.data['data'] as List)
          .map((json) => AssignedOrderModel.fromJson(json))
          .toList();

      emit(AssignedOrdersLoaded(orders));
    } catch (e) {
      emit(DeliveryOrdersError(e.toString()));
    }
  }

  Future<void> _onAcceptOrder(
    AcceptOrder event,
    Emitter<DeliveryOrdersState> emit,
  ) async {
    try {
      await dio.put('/delivery/orders/${event.orderId}/accept');
      emit(OrderAccepted(event.orderId));
    } catch (e) {
      emit(DeliveryOrdersError(e.toString()));
    }
  }

  Future<void> _onRejectOrder(
    RejectOrder event,
    Emitter<DeliveryOrdersState> emit,
  ) async {
    try {
      await dio.put(
        '/delivery/orders/${event.orderId}/reject',
        data: {'reason': event.reason},
      );
      emit(OrderRejected(event.orderId));
    } catch (e) {
      emit(DeliveryOrdersError(e.toString()));
    }
  }

  Future<void> _onConfirmPickup(
    ConfirmPickup event,
    Emitter<DeliveryOrdersState> emit,
  ) async {
    try {
      await dio.post(
        '/delivery/orders/${event.orderId}/pickup',
        data: {
          'itemsCount': event.itemsCount,
          'verificationCode': event.verificationCode,
          'images': event.images,
        },
      );
      emit(PickupConfirmed(event.orderId));
    } catch (e) {
      emit(DeliveryOrdersError(e.toString()));
    }
  }

  Future<void> _onStartDelivery(
    StartDelivery event,
    Emitter<DeliveryOrdersState> emit,
  ) async {
    try {
      await dio.put('/delivery/orders/${event.orderId}/start-delivery');
      emit(DeliveryStarted(event.orderId));
    } catch (e) {
      emit(DeliveryOrdersError(e.toString()));
    }
  }

  Future<void> _onConfirmDelivery(
    ConfirmDelivery event,
    Emitter<DeliveryOrdersState> emit,
  ) async {
    try {
      await dio.post(
        '/delivery/orders/${event.orderId}/complete',
        data: {
          'otp': event.otp,
          'signature': event.signature,
          'images': event.images,
        },
      );
      emit(DeliveryCompleted(event.orderId));
    } catch (e) {
      emit(DeliveryOrdersError(e.toString()));
    }
  }

  Future<void> _onReportIssue(
    ReportIssue event,
    Emitter<DeliveryOrdersState> emit,
  ) async {
    try {
      await dio.post(
        '/delivery/orders/${event.orderId}/issue',
        data: {
          'issue': event.issue,
          'images': event.images,
        },
      );
      emit(IssueReported(event.orderId));
    } catch (e) {
      emit(DeliveryOrdersError(e.toString()));
    }
  }
}
