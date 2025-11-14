import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/address_model.dart';
import '../../domain/usecases/get_current_location_usecase.dart';
import '../../domain/usecases/get_address_from_coordinates_usecase.dart';
import '../../domain/usecases/search_address_usecase.dart';
import '../../domain/usecases/save_address_usecase.dart';
import '../../domain/usecases/get_user_addresses_usecase.dart';
import '../../domain/usecases/delete_address_usecase.dart';
import '../../domain/usecases/set_default_address_usecase.dart';

// Events
abstract class LocationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetCurrentLocationEvent extends LocationEvent {}

class GetAddressFromCoordinatesEvent extends LocationEvent {
  final double latitude;
  final double longitude;

  GetAddressFromCoordinatesEvent({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [latitude, longitude];
}

class SearchAddressEvent extends LocationEvent {
  final String query;

  SearchAddressEvent({required this.query});

  @override
  List<Object?> get props => [query];
}

class SelectAddressEvent extends LocationEvent {
  final AddressModel address;

  SelectAddressEvent({required this.address});

  @override
  List<Object?> get props => [address];
}

class LoadUserAddressesEvent extends LocationEvent {
  final String userId;

  LoadUserAddressesEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class SaveAddressEvent extends LocationEvent {
  final CreateAddressRequest request;

  SaveAddressEvent({required this.request});

  @override
  List<Object?> get props => [request];
}

class DeleteAddressEvent extends LocationEvent {
  final String addressId;

  DeleteAddressEvent({required this.addressId});

  @override
  List<Object?> get props => [addressId];
}

class SetDefaultAddressEvent extends LocationEvent {
  final String addressId;

  SetDefaultAddressEvent({required this.addressId});

  @override
  List<Object?> get props => [addressId];
}

class UpdateMapLocationEvent extends LocationEvent {
  final double latitude;
  final double longitude;

  UpdateMapLocationEvent({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [latitude, longitude];
}

// States
abstract class LocationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationPermissionDenied extends LocationState {
  final String message;

  LocationPermissionDenied({required this.message});

  @override
  List<Object?> get props => [message];
}

class CurrentLocationLoaded extends LocationState {
  final LocationCoordinates coordinates;
  final GeocodeResult? address;

  CurrentLocationLoaded({
    required this.coordinates,
    this.address,
  });

  @override
  List<Object?> get props => [coordinates, address];
}

class AddressSearchResultsLoaded extends LocationState {
  final List<AddressSearchResult> results;

  AddressSearchResultsLoaded({required this.results});

  @override
  List<Object?> get props => [results];
}

class UserAddressesLoaded extends LocationState {
  final List<AddressModel> addresses;
  final AddressModel? selectedAddress;

  UserAddressesLoaded({
    required this.addresses,
    this.selectedAddress,
  });

  @override
  List<Object?> get props => [addresses, selectedAddress];
}

class AddressSelected extends LocationState {
  final AddressModel address;

  AddressSelected({required this.address});

  @override
  List<Object?> get props => [address];
}

class AddressSaved extends LocationState {
  final AddressModel address;
  final String message;

  AddressSaved({
    required this.address,
    required this.message,
  });

  @override
  List<Object?> get props => [address, message];
}

class AddressDeleted extends LocationState {
  final String message;

  AddressDeleted({required this.message});

  @override
  List<Object?> get props => [message];
}

class MapLocationUpdated extends LocationState {
  final LocationCoordinates coordinates;
  final GeocodeResult address;

  MapLocationUpdated({
    required this.coordinates,
    required this.address,
  });

  @override
  List<Object?> get props => [coordinates, address];
}

class LocationError extends LocationState {
  final String message;

  LocationError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Bloc
class LocationBlocNew extends Bloc<LocationEvent, LocationState> {
  final GetCurrentLocationUseCase getCurrentLocationUseCase;
  final GetAddressFromCoordinatesUseCase getAddressFromCoordinatesUseCase;
  final SearchAddressUseCase searchAddressUseCase;
  final SaveAddressUseCase saveAddressUseCase;
  final GetUserAddressesUseCase getUserAddressesUseCase;
  final DeleteAddressUseCase deleteAddressUseCase;
  final SetDefaultAddressUseCase setDefaultAddressUseCase;

  LocationBlocNew({
    required this.getCurrentLocationUseCase,
    required this.getAddressFromCoordinatesUseCase,
    required this.searchAddressUseCase,
    required this.saveAddressUseCase,
    required this.getUserAddressesUseCase,
    required this.deleteAddressUseCase,
    required this.setDefaultAddressUseCase,
  }) : super(LocationInitial()) {
    on<GetCurrentLocationEvent>(_onGetCurrentLocation);
    on<GetAddressFromCoordinatesEvent>(_onGetAddressFromCoordinates);
    on<SearchAddressEvent>(_onSearchAddress);
    on<SelectAddressEvent>(_onSelectAddress);
    on<LoadUserAddressesEvent>(_onLoadUserAddresses);
    on<SaveAddressEvent>(_onSaveAddress);
    on<DeleteAddressEvent>(_onDeleteAddress);
    on<SetDefaultAddressEvent>(_onSetDefaultAddress);
    on<UpdateMapLocationEvent>(_onUpdateMapLocation);
  }

  Future<void> _onGetCurrentLocation(
    GetCurrentLocationEvent event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationLoading());
    try {
      final coordinates = await getCurrentLocationUseCase.execute();

      // Get address from coordinates
      try {
        final address = await getAddressFromCoordinatesUseCase.execute(
          coordinates.latitude,
          coordinates.longitude,
        );
        emit(CurrentLocationLoaded(
          coordinates: coordinates,
          address: address,
        ));
      } catch (e) {
        // If address fetch fails, still emit coordinates
        emit(CurrentLocationLoaded(coordinates: coordinates));
      }
    } catch (e) {
      if (e.toString().contains('permission')) {
        emit(LocationPermissionDenied(
          message: 'Location permission is required to continue',
        ));
      } else {
        emit(LocationError(message: e.toString()));
      }
    }
  }

  Future<void> _onGetAddressFromCoordinates(
    GetAddressFromCoordinatesEvent event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationLoading());
    try {
      final address = await getAddressFromCoordinatesUseCase.execute(
        event.latitude,
        event.longitude,
      );
      emit(MapLocationUpdated(
        coordinates: LocationCoordinates(
          latitude: event.latitude,
          longitude: event.longitude,
        ),
        address: address,
      ));
    } catch (e) {
      emit(LocationError(message: e.toString()));
    }
  }

  Future<void> _onSearchAddress(
    SearchAddressEvent event,
    Emitter<LocationState> emit,
  ) async {
    if (event.query.trim().isEmpty) {
      emit(AddressSearchResultsLoaded(results: []));
      return;
    }

    emit(LocationLoading());
    try {
      final results = await searchAddressUseCase.execute(event.query);
      emit(AddressSearchResultsLoaded(results: results));
    } catch (e) {
      emit(LocationError(message: e.toString()));
    }
  }

  Future<void> _onSelectAddress(
    SelectAddressEvent event,
    Emitter<LocationState> emit,
  ) async {
    emit(AddressSelected(address: event.address));
  }

  Future<void> _onLoadUserAddresses(
    LoadUserAddressesEvent event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationLoading());
    try {
      final addresses = await getUserAddressesUseCase.execute(event.userId);

      // Find default address
      final defaultAddress = addresses.firstWhere(
        (addr) => addr.isDefault,
        orElse: () => addresses.isNotEmpty ? addresses.first : null as AddressModel,
      );

      emit(UserAddressesLoaded(
        addresses: addresses,
        selectedAddress: defaultAddress,
      ));
    } catch (e) {
      emit(LocationError(message: e.toString()));
    }
  }

  Future<void> _onSaveAddress(
    SaveAddressEvent event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationLoading());
    try {
      final address = await saveAddressUseCase.execute(event.request);
      emit(AddressSaved(
        address: address,
        message: 'Address saved successfully',
      ));
    } catch (e) {
      emit(LocationError(message: e.toString()));
    }
  }

  Future<void> _onDeleteAddress(
    DeleteAddressEvent event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationLoading());
    try {
      await deleteAddressUseCase.execute(event.addressId);
      emit(AddressDeleted(message: 'Address deleted successfully'));
    } catch (e) {
      emit(LocationError(message: e.toString()));
    }
  }

  Future<void> _onSetDefaultAddress(
    SetDefaultAddressEvent event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationLoading());
    try {
      final address = await setDefaultAddressUseCase.execute(event.addressId);
      emit(AddressSelected(address: address));
    } catch (e) {
      emit(LocationError(message: e.toString()));
    }
  }

  Future<void> _onUpdateMapLocation(
    UpdateMapLocationEvent event,
    Emitter<LocationState> emit,
  ) async {
    try {
      final address = await getAddressFromCoordinatesUseCase.execute(
        event.latitude,
        event.longitude,
      );
      emit(MapLocationUpdated(
        coordinates: LocationCoordinates(
          latitude: event.latitude,
          longitude: event.longitude,
        ),
        address: address,
      ));
    } catch (e) {
      emit(LocationError(message: e.toString()));
    }
  }
}
