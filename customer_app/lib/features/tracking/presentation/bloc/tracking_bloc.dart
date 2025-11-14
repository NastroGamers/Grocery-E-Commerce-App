import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../data/models/order_tracking_model.dart';
import '../../domain/usecases/track_order_usecase.dart';

// Events
abstract class TrackingEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadOrderTrackingEvent extends TrackingEvent {
  final String orderId;

  LoadOrderTrackingEvent({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class StartLiveTrackingEvent extends TrackingEvent {
  final String orderId;

  StartLiveTrackingEvent({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class StopLiveTrackingEvent extends TrackingEvent {}

class LiveLocationUpdateEvent extends TrackingEvent {
  final LiveLocationUpdate update;

  LiveLocationUpdateEvent({required this.update});

  @override
  List<Object?> get props => [update];
}

class ContactDriverEvent extends TrackingEvent {
  final String orderId;
  final String contactType;
  final String? message;

  ContactDriverEvent({
    required this.orderId,
    required this.contactType,
    this.message,
  });

  @override
  List<Object?> get props => [orderId, contactType, message];
}

class ConfirmDeliveryEvent extends TrackingEvent {
  final String orderId;
  final String verificationCode;

  ConfirmDeliveryEvent({
    required this.orderId,
    required this.verificationCode,
  });

  @override
  List<Object?> get props => [orderId, verificationCode];
}

class RefreshTrackingEvent extends TrackingEvent {
  final String orderId;

  RefreshTrackingEvent({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

// States
abstract class TrackingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TrackingInitial extends TrackingState {}

class TrackingLoading extends TrackingState {}

class TrackingLoaded extends TrackingState {
  final OrderTrackingModel tracking;
  final bool isLiveTrackingActive;

  TrackingLoaded({
    required this.tracking,
    this.isLiveTrackingActive = false,
  });

  @override
  List<Object?> get props => [tracking, isLiveTrackingActive];

  TrackingLoaded copyWith({
    OrderTrackingModel? tracking,
    bool? isLiveTrackingActive,
  }) {
    return TrackingLoaded(
      tracking: tracking ?? this.tracking,
      isLiveTrackingActive: isLiveTrackingActive ?? this.isLiveTrackingActive,
    );
  }
}

class LiveTrackingActive extends TrackingState {
  final OrderTrackingModel tracking;
  final LocationCoordinates currentLocation;

  LiveTrackingActive({
    required this.tracking,
    required this.currentLocation,
  });

  @override
  List<Object?> get props => [tracking, currentLocation];
}

class DriverContactInitiated extends TrackingState {
  final ContactDriverResponse response;

  DriverContactInitiated({required this.response});

  @override
  List<Object?> get props => [response];
}

class DeliveryConfirmed extends TrackingState {
  final String message;

  DeliveryConfirmed({required this.message});

  @override
  List<Object?> get props => [message];
}

class TrackingError extends TrackingState {
  final String message;

  TrackingError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Bloc
class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  final TrackOrderUseCase trackOrderUseCase;
  WebSocketChannel? _wsChannel;
  StreamSubscription? _wsSubscription;

  TrackingBloc({
    required this.trackOrderUseCase,
  }) : super(TrackingInitial()) {
    on<LoadOrderTrackingEvent>(_onLoadOrderTracking);
    on<StartLiveTrackingEvent>(_onStartLiveTracking);
    on<StopLiveTrackingEvent>(_onStopLiveTracking);
    on<LiveLocationUpdateEvent>(_onLiveLocationUpdate);
    on<ContactDriverEvent>(_onContactDriver);
    on<ConfirmDeliveryEvent>(_onConfirmDelivery);
    on<RefreshTrackingEvent>(_onRefreshTracking);
  }

  Future<void> _onLoadOrderTracking(
    LoadOrderTrackingEvent event,
    Emitter<TrackingState> emit,
  ) async {
    emit(TrackingLoading());
    try {
      final tracking = await trackOrderUseCase.call(event.orderId);

      emit(TrackingLoaded(tracking: tracking));
    } catch (e) {
      emit(TrackingError(message: e.toString()));
    }
  }

  Future<void> _onStartLiveTracking(
    StartLiveTrackingEvent event,
    Emitter<TrackingState> emit,
  ) async {
    try {
      // First get current tracking data
      if (state is! TrackingLoaded) {
        final tracking = await trackOrderUseCase.call(event.orderId);
        emit(TrackingLoaded(tracking: tracking));
      }

      final currentState = state as TrackingLoaded;

      // Subscribe to WebSocket
      final wsUrl = await trackOrderUseCase.subscribeLiveTracking(event.orderId);

      _wsChannel = WebSocketChannel.connect(Uri.parse(wsUrl));

      // Listen to WebSocket updates
      _wsSubscription = _wsChannel!.stream.listen(
        (data) {
          if (data is Map<String, dynamic>) {
            final update = LiveLocationUpdate.fromJson(data);
            add(LiveLocationUpdateEvent(update: update));
          }
        },
        onError: (error) {
          add(StopLiveTrackingEvent());
          emit(TrackingError(message: 'Live tracking connection lost'));
        },
      );

      emit(currentState.copyWith(isLiveTrackingActive: true));
    } catch (e) {
      emit(TrackingError(message: e.toString()));
    }
  }

  Future<void> _onStopLiveTracking(
    StopLiveTrackingEvent event,
    Emitter<TrackingState> emit,
  ) async {
    await _wsSubscription?.cancel();
    await _wsChannel?.sink.close();
    _wsSubscription = null;
    _wsChannel = null;

    if (state is TrackingLoaded) {
      final currentState = state as TrackingLoaded;
      emit(currentState.copyWith(isLiveTrackingActive: false));
    }
  }

  Future<void> _onLiveLocationUpdate(
    LiveLocationUpdateEvent event,
    Emitter<TrackingState> emit,
  ) async {
    if (state is TrackingLoaded) {
      final currentState = state as TrackingLoaded;

      // Update tracking with new location
      final updatedTracking = OrderTrackingModel(
        orderId: currentState.tracking.orderId,
        currentStatus: currentState.tracking.currentStatus,
        statusHistory: currentState.tracking.statusHistory,
        estimatedDeliveryTime: currentState.tracking.estimatedDeliveryTime,
        actualDeliveryTime: currentState.tracking.actualDeliveryTime,
        deliveryPerson: currentState.tracking.deliveryPerson,
        currentLocation: event.update.location,
        deliveryLocation: currentState.tracking.deliveryLocation,
        trackingUpdates: currentState.tracking.trackingUpdates,
        distanceRemaining: currentState.tracking.distanceRemaining,
        timeRemaining: currentState.tracking.timeRemaining,
        isLiveTrackingAvailable: currentState.tracking.isLiveTrackingAvailable,
      );

      emit(LiveTrackingActive(
        tracking: updatedTracking,
        currentLocation: event.update.location,
      ));

      // Restore to TrackingLoaded state
      emit(TrackingLoaded(
        tracking: updatedTracking,
        isLiveTrackingActive: true,
      ));
    }
  }

  Future<void> _onContactDriver(
    ContactDriverEvent event,
    Emitter<TrackingState> emit,
  ) async {
    final previousState = state;
    emit(TrackingLoading());

    try {
      final response = await trackOrderUseCase.contactDriver(
        orderId: event.orderId,
        contactType: event.contactType,
        message: event.message,
      );

      emit(DriverContactInitiated(response: response));

      // Restore previous state
      if (previousState is TrackingLoaded) {
        emit(previousState);
      }
    } catch (e) {
      emit(TrackingError(message: e.toString()));

      if (previousState is TrackingLoaded) {
        emit(previousState);
      }
    }
  }

  Future<void> _onConfirmDelivery(
    ConfirmDeliveryEvent event,
    Emitter<TrackingState> emit,
  ) async {
    emit(TrackingLoading());
    try {
      await trackOrderUseCase.confirmDelivery(
        orderId: event.orderId,
        verificationCode: event.verificationCode,
      );

      emit(DeliveryConfirmed(message: 'Delivery confirmed successfully'));

      // Reload tracking data
      add(LoadOrderTrackingEvent(orderId: event.orderId));
    } catch (e) {
      emit(TrackingError(message: e.toString()));
    }
  }

  Future<void> _onRefreshTracking(
    RefreshTrackingEvent event,
    Emitter<TrackingState> emit,
  ) async {
    try {
      final tracking = await trackOrderUseCase.call(event.orderId);

      if (state is TrackingLoaded) {
        final currentState = state as TrackingLoaded;
        emit(TrackingLoaded(
          tracking: tracking,
          isLiveTrackingActive: currentState.isLiveTrackingActive,
        ));
      } else {
        emit(TrackingLoaded(tracking: tracking));
      }
    } catch (e) {
      emit(TrackingError(message: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _wsSubscription?.cancel();
    _wsChannel?.sink.close();
    return super.close();
  }
}
