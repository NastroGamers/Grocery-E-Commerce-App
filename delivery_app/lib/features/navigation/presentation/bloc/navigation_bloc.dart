import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/navigation_model.dart';
import 'package:dio/dio.dart';

// Events
abstract class NavigationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadRoute extends NavigationEvent {
  final double originLat;
  final double originLng;
  final double destinationLat;
  final double destinationLng;
  final String orderId;

  LoadRoute({
    required this.originLat,
    required this.originLng,
    required this.destinationLat,
    required this.destinationLng,
    required this.orderId,
  });

  @override
  List<Object?> get props => [originLat, originLng, destinationLat, destinationLng, orderId];
}

class UpdateLocation extends NavigationEvent {
  final LocationUpdateModel locationUpdate;

  UpdateLocation(this.locationUpdate);

  @override
  List<Object?> get props => [locationUpdate];
}

class ToggleAvailability extends NavigationEvent {
  final bool isAvailable;

  ToggleAvailability(this.isAvailable);

  @override
  List<Object?> get props => [isAvailable];
}

class StartNavigation extends NavigationEvent {
  final String orderId;

  StartNavigation(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class StopNavigation extends NavigationEvent {}

// States
abstract class NavigationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NavigationInitial extends NavigationState {}

class NavigationLoading extends NavigationState {}

class RouteLoaded extends NavigationState {
  final NavigationRouteModel route;

  RouteLoaded(this.route);

  @override
  List<Object?> get props => [route];
}

class LocationUpdated extends NavigationState {
  final LocationUpdateModel location;

  LocationUpdated(this.location);

  @override
  List<Object?> get props => [location];
}

class AvailabilityToggled extends NavigationState {
  final AvailabilityStatusModel status;

  AvailabilityToggled(this.status);

  @override
  List<Object?> get props => [status];
}

class NavigationActive extends NavigationState {
  final NavigationRouteModel route;
  final LocationUpdateModel? currentLocation;

  NavigationActive({required this.route, this.currentLocation});

  @override
  List<Object?> get props => [route, currentLocation];
}

class NavigationStopped extends NavigationState {}

class NavigationError extends NavigationState {
  final String message;

  NavigationError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  final Dio dio;

  NavigationBloc({required this.dio}) : super(NavigationInitial()) {
    on<LoadRoute>(_onLoadRoute);
    on<UpdateLocation>(_onUpdateLocation);
    on<ToggleAvailability>(_onToggleAvailability);
    on<StartNavigation>(_onStartNavigation);
    on<StopNavigation>(_onStopNavigation);
  }

  Future<void> _onLoadRoute(
    LoadRoute event,
    Emitter<NavigationState> emit,
  ) async {
    emit(NavigationLoading());

    try {
      final response = await dio.post(
        '/delivery/navigation/route',
        data: {
          'originLat': event.originLat,
          'originLng': event.originLng,
          'destinationLat': event.destinationLat,
          'destinationLng': event.destinationLng,
          'orderId': event.orderId,
        },
      );

      final route = NavigationRouteModel.fromJson(response.data['data']);
      emit(RouteLoaded(route));
    } catch (e) {
      emit(NavigationError(e.toString()));
    }
  }

  Future<void> _onUpdateLocation(
    UpdateLocation event,
    Emitter<NavigationState> emit,
  ) async {
    try {
      await dio.put(
        '/delivery/location/update',
        data: event.locationUpdate.toJson(),
      );

      emit(LocationUpdated(event.locationUpdate));
    } catch (e) {
      emit(NavigationError(e.toString()));
    }
  }

  Future<void> _onToggleAvailability(
    ToggleAvailability event,
    Emitter<NavigationState> emit,
  ) async {
    try {
      final response = await dio.put(
        '/delivery/availability/toggle',
        data: {'isAvailable': event.isAvailable},
      );

      final status = AvailabilityStatusModel.fromJson(response.data['data']);
      emit(AvailabilityToggled(status));
    } catch (e) {
      emit(NavigationError(e.toString()));
    }
  }

  Future<void> _onStartNavigation(
    StartNavigation event,
    Emitter<NavigationState> emit,
  ) async {
    // Navigation started - handled by route loading
  }

  Future<void> _onStopNavigation(
    StopNavigation event,
    Emitter<NavigationState> emit,
  ) async {
    emit(NavigationStopped());
  }
}
