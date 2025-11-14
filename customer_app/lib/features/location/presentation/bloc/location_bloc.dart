import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class LocationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetCurrentLocationEvent extends LocationEvent {}

class SearchLocationEvent extends LocationEvent {
  final String query;

  SearchLocationEvent({required this.query});

  @override
  List<Object?> get props => [query];
}

class SelectLocationEvent extends LocationEvent {
  final double latitude;
  final double longitude;
  final String address;

  SelectLocationEvent({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  @override
  List<Object?> get props => [latitude, longitude, address];
}

// States
abstract class LocationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationLoaded extends LocationState {
  final double latitude;
  final double longitude;
  final String address;

  LocationLoaded({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  @override
  List<Object?> get props => [latitude, longitude, address];
}

class LocationError extends LocationState {
  final String message;

  LocationError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Bloc
class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(LocationInitial()) {
    on<GetCurrentLocationEvent>(_onGetCurrentLocation);
    on<SearchLocationEvent>(_onSearchLocation);
    on<SelectLocationEvent>(_onSelectLocation);
  }

  Future<void> _onGetCurrentLocation(
    GetCurrentLocationEvent event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationLoading());
    try {
      // Get current location using geolocator
      // For now, emit a placeholder
      emit(LocationLoaded(
        latitude: 0.0,
        longitude: 0.0,
        address: 'Current Location',
      ));
    } catch (e) {
      emit(LocationError(message: e.toString()));
    }
  }

  Future<void> _onSearchLocation(
    SearchLocationEvent event,
    Emitter<LocationState> emit,
  ) async {
    // Implement location search logic
  }

  Future<void> _onSelectLocation(
    SelectLocationEvent event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationLoaded(
      latitude: event.latitude,
      longitude: event.longitude,
      address: event.address,
    ));
  }
}
