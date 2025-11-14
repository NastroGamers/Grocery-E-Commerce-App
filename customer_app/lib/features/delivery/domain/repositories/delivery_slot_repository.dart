import '../../data/models/delivery_slot_model.dart';

abstract class DeliverySlotRepository {
  /// Get available delivery slots for a specific date and zone
  Future<DeliverySlotsResponse> getDeliverySlots({
    required DateTime date,
    required String zoneId,
  });

  /// Get available dates for delivery in a zone
  Future<AvailableDatesResponse> getAvailableDates({
    required String zoneId,
  });

  /// Check if a specific slot is still available
  Future<CheckSlotAvailabilityResponse> checkSlotAvailability(
    CheckSlotAvailabilityRequest request,
  );

  /// Book a delivery slot for an order
  Future<DeliverySlotModel> bookDeliverySlot(
    BookDeliverySlotRequest request,
  );

  /// Reschedule an existing order's delivery slot
  Future<RescheduleDeliveryResponse> rescheduleDelivery(
    RescheduleDeliveryRequest request,
  );

  /// Get delivery zone information by pincode
  Future<DeliveryZoneModel> getDeliveryZoneByPincode(String pincode);

  /// Check if delivery is available for a pincode
  Future<bool> checkDeliveryAvailability(String pincode);
}
