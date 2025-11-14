import '../repositories/delivery_slot_repository.dart';
import '../../data/models/delivery_slot_model.dart';

class RescheduleDeliveryUseCase {
  final DeliverySlotRepository repository;

  RescheduleDeliveryUseCase(this.repository);

  /// Reschedule an existing order's delivery slot
  Future<RescheduleDeliveryResponse> call({
    required String orderId,
    required String newSlotId,
    required DateTime newDate,
    String? reason,
    required DeliveryZoneModel zone,
    required DateTime currentDeliveryDate,
    required String currentSlotStartTime,
  }) async {
    // Validate inputs
    if (orderId.isEmpty) {
      throw Exception('Order ID is required');
    }

    if (newSlotId.isEmpty) {
      throw Exception('New slot ID is required');
    }

    // Validate new date is not in the past
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final requestDate = DateTime(newDate.year, newDate.month, newDate.day);

    if (requestDate.isBefore(today)) {
      throw Exception('Cannot reschedule to past dates');
    }

    // Check if reschedule is within allowed time window
    final currentDeliveryDateTime = _parseDeliveryDateTime(
      currentDeliveryDate,
      currentSlotStartTime,
    );

    final hoursUntilDelivery = currentDeliveryDateTime.difference(now).inHours;

    if (hoursUntilDelivery < zone.cutoffHoursForReschedule) {
      throw Exception(
        'Reschedule must be done at least ${zone.cutoffHoursForReschedule} hours before delivery. '
        'Your delivery is in $hoursUntilDelivery hours.'
      );
    }

    // Check if the new date is within allowed advance booking window
    final maxBookingDate = today.add(Duration(days: zone.maxAdvanceBookingDays));
    if (requestDate.isAfter(maxBookingDate)) {
      throw Exception(
        'Delivery can only be scheduled up to ${zone.maxAdvanceBookingDays} days in advance'
      );
    }

    // Check if the new slot is available
    final availabilityRequest = CheckSlotAvailabilityRequest(
      slotId: newSlotId,
      date: newDate,
      zoneId: zone.zoneId,
    );

    final availabilityResponse = await repository.checkSlotAvailability(
      availabilityRequest,
    );

    if (!availabilityResponse.isAvailable) {
      throw Exception(
        availabilityResponse.message ??
        'Selected slot is no longer available. Please choose another slot.'
      );
    }

    // Proceed with rescheduling
    final rescheduleRequest = RescheduleDeliveryRequest(
      orderId: orderId,
      newSlotId: newSlotId,
      newDate: newDate,
      reason: reason,
    );

    try {
      return await repository.rescheduleDelivery(rescheduleRequest);
    } catch (e) {
      // Provide user-friendly error messages
      if (e.toString().contains('no longer available')) {
        throw Exception(
          'This slot was just booked by another customer. Please select a different slot.'
        );
      } else if (e.toString().contains('time window')) {
        throw Exception(
          'Reschedule request is outside the allowed time window. '
          'Please contact support for assistance.'
        );
      }
      rethrow;
    }
  }

  /// Validate if an order can be rescheduled
  bool canReschedule({
    required DateTime currentDeliveryDate,
    required String currentSlotStartTime,
    required int cutoffHours,
  }) {
    final now = DateTime.now();
    final deliveryDateTime = _parseDeliveryDateTime(
      currentDeliveryDate,
      currentSlotStartTime,
    );

    final hoursUntilDelivery = deliveryDateTime.difference(now).inHours;
    return hoursUntilDelivery >= cutoffHours;
  }

  /// Calculate how many hours remain until the cutoff time for rescheduling
  int getRemainingRescheduleHours({
    required DateTime currentDeliveryDate,
    required String currentSlotStartTime,
    required int cutoffHours,
  }) {
    final now = DateTime.now();
    final deliveryDateTime = _parseDeliveryDateTime(
      currentDeliveryDate,
      currentSlotStartTime,
    );

    final hoursUntilDelivery = deliveryDateTime.difference(now).inHours;
    final remainingHours = hoursUntilDelivery - cutoffHours;

    return remainingHours > 0 ? remainingHours : 0;
  }

  DateTime _parseDeliveryDateTime(DateTime date, String time) {
    final timeParts = time.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    return DateTime(
      date.year,
      date.month,
      date.day,
      hour,
      minute,
    );
  }
}
