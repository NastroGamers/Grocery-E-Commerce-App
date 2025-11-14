import 'package:json_annotation/json_annotation.dart';

part 'delivery_slot_model.g.dart';

enum SlotType {
  @JsonValue('standard')
  standard,
  @JsonValue('express')
  express,
  @JsonValue('premium')
  premium,
}

enum SlotAvailability {
  available,
  limited,
  fullyBooked,
}

@JsonSerializable()
class DeliverySlotModel {
  final String slotId;
  final DateTime date;
  final String startTime; // "08:00"
  final String endTime; // "10:00"
  final int capacity;
  final int bookedCount;
  final bool isExpressAvailable;
  final SlotType slotType;
  final double? surgePricing; // Additional fee for premium slots
  final String zoneId;
  final bool isAvailable;

  DeliverySlotModel({
    required this.slotId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.capacity,
    required this.bookedCount,
    required this.isExpressAvailable,
    required this.slotType,
    this.surgePricing,
    required this.zoneId,
    required this.isAvailable,
  });

  factory DeliverySlotModel.fromJson(Map<String, dynamic> json) =>
      _$DeliverySlotModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeliverySlotModelToJson(this);

  // Computed properties
  SlotAvailability get availabilityStatus {
    if (!isAvailable || bookedCount >= capacity) {
      return SlotAvailability.fullyBooked;
    }
    final remainingCapacity = capacity - bookedCount;
    final capacityPercentage = (remainingCapacity / capacity) * 100;

    if (capacityPercentage <= 20) {
      return SlotAvailability.limited;
    }
    return SlotAvailability.available;
  }

  int get remainingSlots => capacity - bookedCount;

  String get timeRange => '$startTime - $endTime';

  bool get isPremium => slotType == SlotType.premium;
  bool get isExpress => slotType == SlotType.express;
  bool get isStandard => slotType == SlotType.standard;

  double get totalPrice {
    return surgePricing ?? 0.0;
  }
}

@JsonSerializable()
class DeliveryZoneModel {
  final String zoneId;
  final String zoneName;
  final List<String> pincodes;
  final bool isExpressDeliveryAvailable;
  final double standardDeliveryFee;
  final double? expressDeliveryFee;
  final int cutoffHoursForReschedule; // Hours before delivery to allow reschedule
  final int maxAdvanceBookingDays; // Usually 7 days

  DeliveryZoneModel({
    required this.zoneId,
    required this.zoneName,
    required this.pincodes,
    required this.isExpressDeliveryAvailable,
    required this.standardDeliveryFee,
    this.expressDeliveryFee,
    required this.cutoffHoursForReschedule,
    required this.maxAdvanceBookingDays,
  });

  factory DeliveryZoneModel.fromJson(Map<String, dynamic> json) =>
      _$DeliveryZoneModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryZoneModelToJson(this);
}

@JsonSerializable()
class DeliverySlotsResponse {
  final DateTime date;
  final List<DeliverySlotModel> slots;
  final String zoneId;
  final String zoneName;

  DeliverySlotsResponse({
    required this.date,
    required this.slots,
    required this.zoneId,
    required this.zoneName,
  });

  factory DeliverySlotsResponse.fromJson(Map<String, dynamic> json) =>
      _$DeliverySlotsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeliverySlotsResponseToJson(this);

  List<DeliverySlotModel> get availableSlots =>
      slots.where((slot) => slot.availabilityStatus != SlotAvailability.fullyBooked).toList();

  List<DeliverySlotModel> get expressSlots =>
      slots.where((slot) => slot.isExpress).toList();

  bool get hasAvailableSlots => availableSlots.isNotEmpty;
}

@JsonSerializable()
class CheckSlotAvailabilityRequest {
  final String slotId;
  final DateTime date;
  final String zoneId;

  CheckSlotAvailabilityRequest({
    required this.slotId,
    required this.date,
    required this.zoneId,
  });

  factory CheckSlotAvailabilityRequest.fromJson(Map<String, dynamic> json) =>
      _$CheckSlotAvailabilityRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CheckSlotAvailabilityRequestToJson(this);
}

@JsonSerializable()
class CheckSlotAvailabilityResponse {
  final bool isAvailable;
  final int remainingCapacity;
  final String? message; // "Slot is fully booked" or "Slot is available"

  CheckSlotAvailabilityResponse({
    required this.isAvailable,
    required this.remainingCapacity,
    this.message,
  });

  factory CheckSlotAvailabilityResponse.fromJson(Map<String, dynamic> json) =>
      _$CheckSlotAvailabilityResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CheckSlotAvailabilityResponseToJson(this);
}

@JsonSerializable()
class BookDeliverySlotRequest {
  final String orderId;
  final String slotId;
  final DateTime date;
  final String zoneId;

  BookDeliverySlotRequest({
    required this.orderId,
    required this.slotId,
    required this.date,
    required this.zoneId,
  });

  factory BookDeliverySlotRequest.fromJson(Map<String, dynamic> json) =>
      _$BookDeliverySlotRequestFromJson(json);

  Map<String, dynamic> toJson() => _$BookDeliverySlotRequestToJson(this);
}

@JsonSerializable()
class RescheduleDeliveryRequest {
  final String orderId;
  final String newSlotId;
  final DateTime newDate;
  final String? reason;

  RescheduleDeliveryRequest({
    required this.orderId,
    required this.newSlotId,
    required this.newDate,
    this.reason,
  });

  factory RescheduleDeliveryRequest.fromJson(Map<String, dynamic> json) =>
      _$RescheduleDeliveryRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RescheduleDeliveryRequestToJson(this);
}

@JsonSerializable()
class RescheduleDeliveryResponse {
  final bool success;
  final String message;
  final DeliverySlotModel? newSlot;
  final DateTime? newDeliveryDate;

  RescheduleDeliveryResponse({
    required this.success,
    required this.message,
    this.newSlot,
    this.newDeliveryDate,
  });

  factory RescheduleDeliveryResponse.fromJson(Map<String, dynamic> json) =>
      _$RescheduleDeliveryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RescheduleDeliveryResponseToJson(this);
}

@JsonSerializable()
class AvailableDatesResponse {
  final List<DateTime> availableDates;
  final int maxAdvanceBookingDays;
  final String zoneId;

  AvailableDatesResponse({
    required this.availableDates,
    required this.maxAdvanceBookingDays,
    required this.zoneId,
  });

  factory AvailableDatesResponse.fromJson(Map<String, dynamic> json) =>
      _$AvailableDatesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AvailableDatesResponseToJson(this);
}
