import '../repositories/delivery_slot_repository.dart';
import '../../data/models/delivery_slot_model.dart';

class BookDeliverySlotUseCase {
  final DeliverySlotRepository repository;

  BookDeliverySlotUseCase(this.repository);

  /// Book a delivery slot for an order
  Future<DeliverySlotModel> call({
    required String orderId,
    required String slotId,
    required DateTime date,
    required String zoneId,
  }) async {
    // Validate inputs
    if (orderId.isEmpty) {
      throw Exception('Order ID is required');
    }

    if (slotId.isEmpty) {
      throw Exception('Slot ID is required');
    }

    if (zoneId.isEmpty) {
      throw Exception('Zone ID is required');
    }

    // Validate date is not in the past
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final requestDate = DateTime(date.year, date.month, date.day);

    if (requestDate.isBefore(today)) {
      throw Exception('Cannot book delivery slots for past dates');
    }

    // First, check if the slot is still available
    final availabilityRequest = CheckSlotAvailabilityRequest(
      slotId: slotId,
      date: date,
      zoneId: zoneId,
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

    // Proceed with booking
    final bookingRequest = BookDeliverySlotRequest(
      orderId: orderId,
      slotId: slotId,
      date: date,
      zoneId: zoneId,
    );

    try {
      return await repository.bookDeliverySlot(bookingRequest);
    } catch (e) {
      // If booking fails due to race condition (slot became full after check),
      // provide a user-friendly error message
      if (e.toString().contains('no longer available')) {
        throw Exception(
          'This slot was just booked by another customer. Please select a different slot.'
        );
      }
      rethrow;
    }
  }
}
