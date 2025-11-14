import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/config/app_config.dart';
import '../models/delivery_slot_model.dart';

abstract class DeliverySlotRemoteDataSource {
  /// Get available delivery slots for a specific date and zone
  Future<DeliverySlotsResponse> getDeliverySlots({
    required DateTime date,
    required String zoneId,
  });

  /// Get available dates for delivery in a zone (next 7 days typically)
  Future<AvailableDatesResponse> getAvailableDates({
    required String zoneId,
  });

  /// Check if a specific slot is still available before booking
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

class DeliverySlotRemoteDataSourceImpl implements DeliverySlotRemoteDataSource {
  final DioClient dioClient;

  DeliverySlotRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<DeliverySlotsResponse> getDeliverySlots({
    required DateTime date,
    required String zoneId,
  }) async {
    try {
      final formattedDate = _formatDate(date);
      final response = await dioClient.get(
        '${AppConfig.deliveryEndpoint}/slots',
        queryParameters: {
          'date': formattedDate,
          'zoneId': zoneId,
        },
      );

      if (response.statusCode == 200) {
        return DeliverySlotsResponse.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to load delivery slots: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('No delivery slots available for this date and zone');
      }
      throw Exception('Failed to load delivery slots: ${e.message}');
    }
  }

  @override
  Future<AvailableDatesResponse> getAvailableDates({
    required String zoneId,
  }) async {
    try {
      final response = await dioClient.get(
        '${AppConfig.deliveryEndpoint}/available-dates',
        queryParameters: {
          'zoneId': zoneId,
        },
      );

      if (response.statusCode == 200) {
        return AvailableDatesResponse.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to load available dates: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Failed to load available dates: ${e.message}');
    }
  }

  @override
  Future<CheckSlotAvailabilityResponse> checkSlotAvailability(
    CheckSlotAvailabilityRequest request,
  ) async {
    try {
      final response = await dioClient.post(
        '${AppConfig.deliveryEndpoint}/slots/check-availability',
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return CheckSlotAvailabilityResponse.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to check slot availability: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        // Slot is fully booked
        return CheckSlotAvailabilityResponse(
          isAvailable: false,
          remainingCapacity: 0,
          message: e.response?.data['message'] ?? 'Slot is fully booked',
        );
      }
      throw Exception('Failed to check slot availability: ${e.message}');
    }
  }

  @override
  Future<DeliverySlotModel> bookDeliverySlot(
    BookDeliverySlotRequest request,
  ) async {
    try {
      final response = await dioClient.post(
        '${AppConfig.deliveryEndpoint}/slots/book',
        data: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return DeliverySlotModel.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to book delivery slot: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        throw Exception('Slot is no longer available. Please select another slot.');
      } else if (e.response?.statusCode == 400) {
        throw Exception(e.response?.data['message'] ?? 'Invalid booking request');
      }
      throw Exception('Failed to book delivery slot: ${e.message}');
    }
  }

  @override
  Future<RescheduleDeliveryResponse> rescheduleDelivery(
    RescheduleDeliveryRequest request,
  ) async {
    try {
      final response = await dioClient.post(
        '${AppConfig.deliveryEndpoint}/orders/${request.orderId}/reschedule',
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return RescheduleDeliveryResponse.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to reschedule delivery: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception(
          e.response?.data['message'] ??
          'Reschedule request is outside the allowed time window'
        );
      } else if (e.response?.statusCode == 409) {
        throw Exception('New slot is no longer available. Please select another slot.');
      }
      throw Exception('Failed to reschedule delivery: ${e.message}');
    }
  }

  @override
  Future<DeliveryZoneModel> getDeliveryZoneByPincode(String pincode) async {
    try {
      final response = await dioClient.get(
        '${AppConfig.deliveryEndpoint}/zones/by-pincode',
        queryParameters: {
          'pincode': pincode,
        },
      );

      if (response.statusCode == 200) {
        return DeliveryZoneModel.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to get delivery zone: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Delivery not available in your area (pincode: $pincode)');
      }
      throw Exception('Failed to get delivery zone: ${e.message}');
    }
  }

  @override
  Future<bool> checkDeliveryAvailability(String pincode) async {
    try {
      final response = await dioClient.get(
        '${AppConfig.deliveryEndpoint}/zones/check-availability',
        queryParameters: {
          'pincode': pincode,
        },
      );

      if (response.statusCode == 200) {
        return response.data['data']['isAvailable'] as bool;
      }
      return false;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return false;
      }
      throw Exception('Failed to check delivery availability: ${e.message}');
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
