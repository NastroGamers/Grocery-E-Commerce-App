import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/delivery_slot_model.dart';
import '../../domain/usecases/get_delivery_slots_usecase.dart';
import '../../domain/usecases/book_delivery_slot_usecase.dart';
import '../../domain/usecases/reschedule_delivery_usecase.dart';

// Events
abstract class DeliverySlotEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CheckDeliveryAvailabilityEvent extends DeliverySlotEvent {
  final String pincode;

  CheckDeliveryAvailabilityEvent({required this.pincode});

  @override
  List<Object?> get props => [pincode];
}

class LoadDeliveryZoneEvent extends DeliverySlotEvent {
  final String pincode;

  LoadDeliveryZoneEvent({required this.pincode});

  @override
  List<Object?> get props => [pincode];
}

class LoadAvailableDatesEvent extends DeliverySlotEvent {
  final String zoneId;

  LoadAvailableDatesEvent({required this.zoneId});

  @override
  List<Object?> get props => [zoneId];
}

class LoadDeliverySlotsEvent extends DeliverySlotEvent {
  final DateTime date;
  final String zoneId;

  LoadDeliverySlotsEvent({
    required this.date,
    required this.zoneId,
  });

  @override
  List<Object?> get props => [date, zoneId];
}

class SelectDeliverySlotEvent extends DeliverySlotEvent {
  final DeliverySlotModel slot;

  SelectDeliverySlotEvent({required this.slot});

  @override
  List<Object?> get props => [slot];
}

class CheckSlotAvailabilityEvent extends DeliverySlotEvent {
  final String slotId;
  final DateTime date;
  final String zoneId;

  CheckSlotAvailabilityEvent({
    required this.slotId,
    required this.date,
    required this.zoneId,
  });

  @override
  List<Object?> get props => [slotId, date, zoneId];
}

class BookDeliverySlotEvent extends DeliverySlotEvent {
  final String orderId;
  final String slotId;
  final DateTime date;
  final String zoneId;

  BookDeliverySlotEvent({
    required this.orderId,
    required this.slotId,
    required this.date,
    required this.zoneId,
  });

  @override
  List<Object?> get props => [orderId, slotId, date, zoneId];
}

class RescheduleDeliveryEvent extends DeliverySlotEvent {
  final String orderId;
  final String newSlotId;
  final DateTime newDate;
  final String? reason;
  final DeliveryZoneModel zone;
  final DateTime currentDeliveryDate;
  final String currentSlotStartTime;

  RescheduleDeliveryEvent({
    required this.orderId,
    required this.newSlotId,
    required this.newDate,
    this.reason,
    required this.zone,
    required this.currentDeliveryDate,
    required this.currentSlotStartTime,
  });

  @override
  List<Object?> get props => [
    orderId,
    newSlotId,
    newDate,
    reason,
    zone,
    currentDeliveryDate,
    currentSlotStartTime,
  ];
}

class ClearDeliverySlotSelectionEvent extends DeliverySlotEvent {}

// States
abstract class DeliverySlotState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DeliverySlotInitial extends DeliverySlotState {}

class DeliverySlotLoading extends DeliverySlotState {}

class DeliveryAvailabilityChecked extends DeliverySlotState {
  final bool isAvailable;
  final String pincode;

  DeliveryAvailabilityChecked({
    required this.isAvailable,
    required this.pincode,
  });

  @override
  List<Object?> get props => [isAvailable, pincode];
}

class DeliveryZoneLoaded extends DeliverySlotState {
  final DeliveryZoneModel zone;

  DeliveryZoneLoaded({required this.zone});

  @override
  List<Object?> get props => [zone];
}

class AvailableDatesLoaded extends DeliverySlotState {
  final AvailableDatesResponse availableDates;

  AvailableDatesLoaded({required this.availableDates});

  @override
  List<Object?> get props => [availableDates];
}

class DeliverySlotsLoaded extends DeliverySlotState {
  final DeliverySlotsResponse slotsResponse;
  final DateTime selectedDate;
  final DeliverySlotModel? selectedSlot;

  DeliverySlotsLoaded({
    required this.slotsResponse,
    required this.selectedDate,
    this.selectedSlot,
  });

  @override
  List<Object?> get props => [slotsResponse, selectedDate, selectedSlot];

  bool get hasAvailableSlots => slotsResponse.hasAvailableSlots;
  List<DeliverySlotModel> get availableSlots => slotsResponse.availableSlots;
  List<DeliverySlotModel> get expressSlots => slotsResponse.expressSlots;
}

class DeliverySlotSelected extends DeliverySlotState {
  final DeliverySlotModel slot;
  final DateTime date;

  DeliverySlotSelected({
    required this.slot,
    required this.date,
  });

  @override
  List<Object?> get props => [slot, date];
}

class SlotAvailabilityChecked extends DeliverySlotState {
  final CheckSlotAvailabilityResponse availabilityResponse;
  final String slotId;

  SlotAvailabilityChecked({
    required this.availabilityResponse,
    required this.slotId,
  });

  @override
  List<Object?> get props => [availabilityResponse, slotId];
}

class DeliverySlotBooked extends DeliverySlotState {
  final DeliverySlotModel bookedSlot;
  final String message;

  DeliverySlotBooked({
    required this.bookedSlot,
    required this.message,
  });

  @override
  List<Object?> get props => [bookedSlot, message];
}

class DeliveryRescheduled extends DeliverySlotState {
  final RescheduleDeliveryResponse response;

  DeliveryRescheduled({required this.response});

  @override
  List<Object?> get props => [response];
}

class DeliverySlotError extends DeliverySlotState {
  final String message;

  DeliverySlotError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Bloc
class DeliverySlotBloc extends Bloc<DeliverySlotEvent, DeliverySlotState> {
  final GetDeliverySlotsUseCase getDeliverySlotsUseCase;
  final BookDeliverySlotUseCase bookDeliverySlotUseCase;
  final RescheduleDeliveryUseCase rescheduleDeliveryUseCase;

  DeliverySlotBloc({
    required this.getDeliverySlotsUseCase,
    required this.bookDeliverySlotUseCase,
    required this.rescheduleDeliveryUseCase,
  }) : super(DeliverySlotInitial()) {
    on<CheckDeliveryAvailabilityEvent>(_onCheckDeliveryAvailability);
    on<LoadDeliveryZoneEvent>(_onLoadDeliveryZone);
    on<LoadAvailableDatesEvent>(_onLoadAvailableDates);
    on<LoadDeliverySlotsEvent>(_onLoadDeliverySlots);
    on<SelectDeliverySlotEvent>(_onSelectDeliverySlot);
    on<CheckSlotAvailabilityEvent>(_onCheckSlotAvailability);
    on<BookDeliverySlotEvent>(_onBookDeliverySlot);
    on<RescheduleDeliveryEvent>(_onRescheduleDelivery);
    on<ClearDeliverySlotSelectionEvent>(_onClearSelection);
  }

  Future<void> _onCheckDeliveryAvailability(
    CheckDeliveryAvailabilityEvent event,
    Emitter<DeliverySlotState> emit,
  ) async {
    emit(DeliverySlotLoading());
    try {
      final isAvailable = await getDeliverySlotsUseCase.checkDeliveryAvailability(
        event.pincode,
      );

      emit(DeliveryAvailabilityChecked(
        isAvailable: isAvailable,
        pincode: event.pincode,
      ));
    } catch (e) {
      emit(DeliverySlotError(message: e.toString()));
    }
  }

  Future<void> _onLoadDeliveryZone(
    LoadDeliveryZoneEvent event,
    Emitter<DeliverySlotState> emit,
  ) async {
    emit(DeliverySlotLoading());
    try {
      final zone = await getDeliverySlotsUseCase.getDeliveryZoneByPincode(
        event.pincode,
      );

      emit(DeliveryZoneLoaded(zone: zone));
    } catch (e) {
      emit(DeliverySlotError(message: e.toString()));
    }
  }

  Future<void> _onLoadAvailableDates(
    LoadAvailableDatesEvent event,
    Emitter<DeliverySlotState> emit,
  ) async {
    emit(DeliverySlotLoading());
    try {
      final availableDates = await getDeliverySlotsUseCase.getAvailableDates(
        zoneId: event.zoneId,
      );

      emit(AvailableDatesLoaded(availableDates: availableDates));
    } catch (e) {
      emit(DeliverySlotError(message: e.toString()));
    }
  }

  Future<void> _onLoadDeliverySlots(
    LoadDeliverySlotsEvent event,
    Emitter<DeliverySlotState> emit,
  ) async {
    emit(DeliverySlotLoading());
    try {
      final slotsResponse = await getDeliverySlotsUseCase.call(
        date: event.date,
        zoneId: event.zoneId,
      );

      emit(DeliverySlotsLoaded(
        slotsResponse: slotsResponse,
        selectedDate: event.date,
      ));
    } catch (e) {
      emit(DeliverySlotError(message: e.toString()));
    }
  }

  Future<void> _onSelectDeliverySlot(
    SelectDeliverySlotEvent event,
    Emitter<DeliverySlotState> emit,
  ) async {
    if (state is DeliverySlotsLoaded) {
      final currentState = state as DeliverySlotsLoaded;

      emit(DeliverySlotsLoaded(
        slotsResponse: currentState.slotsResponse,
        selectedDate: currentState.selectedDate,
        selectedSlot: event.slot,
      ));

      emit(DeliverySlotSelected(
        slot: event.slot,
        date: currentState.selectedDate,
      ));
    }
  }

  Future<void> _onCheckSlotAvailability(
    CheckSlotAvailabilityEvent event,
    Emitter<DeliverySlotState> emit,
  ) async {
    final previousState = state;
    emit(DeliverySlotLoading());

    try {
      final availabilityResponse = await getDeliverySlotsUseCase.checkSlotAvailability(
        slotId: event.slotId,
        date: event.date,
        zoneId: event.zoneId,
      );

      emit(SlotAvailabilityChecked(
        availabilityResponse: availabilityResponse,
        slotId: event.slotId,
      ));

      // Restore previous state after a brief moment
      if (previousState is DeliverySlotsLoaded) {
        emit(previousState);
      }
    } catch (e) {
      emit(DeliverySlotError(message: e.toString()));
      if (previousState is DeliverySlotsLoaded) {
        emit(previousState);
      }
    }
  }

  Future<void> _onBookDeliverySlot(
    BookDeliverySlotEvent event,
    Emitter<DeliverySlotState> emit,
  ) async {
    final previousState = state;
    emit(DeliverySlotLoading());

    try {
      final bookedSlot = await bookDeliverySlotUseCase.call(
        orderId: event.orderId,
        slotId: event.slotId,
        date: event.date,
        zoneId: event.zoneId,
      );

      emit(DeliverySlotBooked(
        bookedSlot: bookedSlot,
        message: 'Delivery slot booked successfully',
      ));
    } catch (e) {
      emit(DeliverySlotError(message: e.toString()));
      if (previousState is DeliverySlotsLoaded) {
        emit(previousState);
      }
    }
  }

  Future<void> _onRescheduleDelivery(
    RescheduleDeliveryEvent event,
    Emitter<DeliverySlotState> emit,
  ) async {
    emit(DeliverySlotLoading());

    try {
      final response = await rescheduleDeliveryUseCase.call(
        orderId: event.orderId,
        newSlotId: event.newSlotId,
        newDate: event.newDate,
        reason: event.reason,
        zone: event.zone,
        currentDeliveryDate: event.currentDeliveryDate,
        currentSlotStartTime: event.currentSlotStartTime,
      );

      emit(DeliveryRescheduled(response: response));
    } catch (e) {
      emit(DeliverySlotError(message: e.toString()));
    }
  }

  Future<void> _onClearSelection(
    ClearDeliverySlotSelectionEvent event,
    Emitter<DeliverySlotState> emit,
  ) async {
    if (state is DeliverySlotsLoaded) {
      final currentState = state as DeliverySlotsLoaded;
      emit(DeliverySlotsLoaded(
        slotsResponse: currentState.slotsResponse,
        selectedDate: currentState.selectedDate,
        selectedSlot: null,
      ));
    } else {
      emit(DeliverySlotInitial());
    }
  }
}
