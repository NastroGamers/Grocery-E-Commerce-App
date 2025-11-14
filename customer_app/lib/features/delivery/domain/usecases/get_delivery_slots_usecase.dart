import '../repositories/delivery_slot_repository.dart';
import '../../data/models/delivery_slot_model.dart';

class GetDeliverySlotsUseCase {
  final DeliverySlotRepository repository;

  GetDeliverySlotsUseCase(this.repository);

  /// Get available delivery slots for a specific date and zone
  Future<DeliverySlotsResponse> call({
    required DateTime date,
    required String zoneId,
  }) async {
    // Validate date is not in the past
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final requestDate = DateTime(date.year, date.month, date.day);

    if (requestDate.isBefore(today)) {
      throw Exception('Cannot get delivery slots for past dates');
    }

    // Get slots from repository
    final response = await repository.getDeliverySlots(
      date: date,
      zoneId: zoneId,
    );

    // If requesting today's slots, filter out slots that have already passed
    if (requestDate.isAtSameMomentAs(today)) {
      final currentHour = now.hour;
      final currentMinute = now.minute;

      final filteredSlots = response.slots.where((slot) {
        final startTimeParts = slot.startTime.split(':');
        final slotHour = int.parse(startTimeParts[0]);
        final slotMinute = int.parse(startTimeParts[1]);

        // Keep slot if it starts at least 1 hour from now
        if (slotHour > currentHour + 1) {
          return true;
        } else if (slotHour == currentHour + 1) {
          return slotMinute >= currentMinute;
        }
        return false;
      }).toList();

      return DeliverySlotsResponse(
        date: response.date,
        slots: filteredSlots,
        zoneId: response.zoneId,
        zoneName: response.zoneName,
      );
    }

    return response;
  }

  /// Get available dates for delivery booking
  Future<AvailableDatesResponse> getAvailableDates({
    required String zoneId,
  }) async {
    return await repository.getAvailableDates(zoneId: zoneId);
  }

  /// Check if a specific slot is still available
  Future<CheckSlotAvailabilityResponse> checkSlotAvailability({
    required String slotId,
    required DateTime date,
    required String zoneId,
  }) async {
    final request = CheckSlotAvailabilityRequest(
      slotId: slotId,
      date: date,
      zoneId: zoneId,
    );

    return await repository.checkSlotAvailability(request);
  }

  /// Get delivery zone by pincode
  Future<DeliveryZoneModel> getDeliveryZoneByPincode(String pincode) async {
    // Validate pincode format (6 digits for India)
    if (!_isValidPincode(pincode)) {
      throw Exception('Invalid pincode format. Please enter a valid 6-digit pincode.');
    }

    return await repository.getDeliveryZoneByPincode(pincode);
  }

  /// Check if delivery is available for a pincode
  Future<bool> checkDeliveryAvailability(String pincode) async {
    if (!_isValidPincode(pincode)) {
      return false;
    }

    return await repository.checkDeliveryAvailability(pincode);
  }

  bool _isValidPincode(String pincode) {
    // Remove any whitespace
    final cleanPincode = pincode.trim();

    // Check if it's exactly 6 digits
    if (cleanPincode.length != 6) {
      return false;
    }

    // Check if it contains only digits
    return RegExp(r'^\d{6}$').hasMatch(cleanPincode);
  }
}
