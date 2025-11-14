import '../../domain/repositories/delivery_slot_repository.dart';
import '../datasources/delivery_slot_remote_datasource.dart';
import '../models/delivery_slot_model.dart';

class DeliverySlotRepositoryImpl implements DeliverySlotRepository {
  final DeliverySlotRemoteDataSource remoteDataSource;

  DeliverySlotRepositoryImpl({required this.remoteDataSource});

  @override
  Future<DeliverySlotsResponse> getDeliverySlots({
    required DateTime date,
    required String zoneId,
  }) async {
    return await remoteDataSource.getDeliverySlots(
      date: date,
      zoneId: zoneId,
    );
  }

  @override
  Future<AvailableDatesResponse> getAvailableDates({
    required String zoneId,
  }) async {
    return await remoteDataSource.getAvailableDates(zoneId: zoneId);
  }

  @override
  Future<CheckSlotAvailabilityResponse> checkSlotAvailability(
    CheckSlotAvailabilityRequest request,
  ) async {
    return await remoteDataSource.checkSlotAvailability(request);
  }

  @override
  Future<DeliverySlotModel> bookDeliverySlot(
    BookDeliverySlotRequest request,
  ) async {
    return await remoteDataSource.bookDeliverySlot(request);
  }

  @override
  Future<RescheduleDeliveryResponse> rescheduleDelivery(
    RescheduleDeliveryRequest request,
  ) async {
    return await remoteDataSource.rescheduleDelivery(request);
  }

  @override
  Future<DeliveryZoneModel> getDeliveryZoneByPincode(String pincode) async {
    return await remoteDataSource.getDeliveryZoneByPincode(pincode);
  }

  @override
  Future<bool> checkDeliveryAvailability(String pincode) async {
    return await remoteDataSource.checkDeliveryAvailability(pincode);
  }
}
