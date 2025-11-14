import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/vendor_model.dart';
import 'package:dio/dio.dart';

// Events
abstract class VendorsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadVendors extends VendorsEvent {
  final int page;
  final String? status;

  LoadVendors({this.page = 1, this.status});

  @override
  List<Object?> get props => [page, status];
}

class LoadVendorDetails extends VendorsEvent {
  final String vendorId;

  LoadVendorDetails(this.vendorId);

  @override
  List<Object?> get props => [vendorId];
}

class ApproveVendor extends VendorsEvent {
  final String vendorId;

  ApproveVendor(this.vendorId);

  @override
  List<Object?> get props => [vendorId];
}

class RejectVendor extends VendorsEvent {
  final String vendorId;
  final String reason;

  RejectVendor({required this.vendorId, required this.reason});

  @override
  List<Object?> get props => [vendorId, reason];
}

class SuspendVendor extends VendorsEvent {
  final String vendorId;
  final String reason;

  SuspendVendor({required this.vendorId, required this.reason});

  @override
  List<Object?> get props => [vendorId, reason];
}

// States
abstract class VendorsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VendorsInitial extends VendorsState {}

class VendorsLoading extends VendorsState {}

class VendorsLoaded extends VendorsState {
  final List<VendorModel> vendors;
  final bool hasMore;

  VendorsLoaded({required this.vendors, this.hasMore = true});

  @override
  List<Object?> get props => [vendors, hasMore];
}

class VendorDetailsLoaded extends VendorsState {
  final VendorModel vendor;
  final VendorStatsModel stats;

  VendorDetailsLoaded({required this.vendor, required this.stats});

  @override
  List<Object?> get props => [vendor, stats];
}

class VendorApproved extends VendorsState {
  final String vendorId;

  VendorApproved(this.vendorId);

  @override
  List<Object?> get props => [vendorId];
}

class VendorRejected extends VendorsState {
  final String vendorId;

  VendorRejected(this.vendorId);

  @override
  List<Object?> get props => [vendorId];
}

class VendorSuspended extends VendorsState {
  final String vendorId;

  VendorSuspended(this.vendorId);

  @override
  List<Object?> get props => [vendorId];
}

class VendorsError extends VendorsState {
  final String message;

  VendorsError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class VendorsBloc extends Bloc<VendorsEvent, VendorsState> {
  final Dio dio;

  VendorsBloc({required this.dio}) : super(VendorsInitial()) {
    on<LoadVendors>(_onLoadVendors);
    on<LoadVendorDetails>(_onLoadVendorDetails);
    on<ApproveVendor>(_onApproveVendor);
    on<RejectVendor>(_onRejectVendor);
    on<SuspendVendor>(_onSuspendVendor);
  }

  Future<void> _onLoadVendors(
    LoadVendors event,
    Emitter<VendorsState> emit,
  ) async {
    emit(VendorsLoading());

    try {
      final response = await dio.get(
        '/admin/vendors',
        queryParameters: {
          'page': event.page,
          'limit': 20,
          if (event.status != null) 'status': event.status,
        },
      );

      final vendors = (response.data['data'] as List)
          .map((json) => VendorModel.fromJson(json))
          .toList();

      emit(VendorsLoaded(vendors: vendors, hasMore: vendors.length >= 20));
    } catch (e) {
      emit(VendorsError(e.toString()));
    }
  }

  Future<void> _onLoadVendorDetails(
    LoadVendorDetails event,
    Emitter<VendorsState> emit,
  ) async {
    emit(VendorsLoading());

    try {
      final response = await dio.get('/admin/vendors/${event.vendorId}');
      final vendor = VendorModel.fromJson(response.data['data']);

      final statsResponse = await dio.get('/admin/vendors/${event.vendorId}/stats');
      final stats = VendorStatsModel.fromJson(statsResponse.data['data']);

      emit(VendorDetailsLoaded(vendor: vendor, stats: stats));
    } catch (e) {
      emit(VendorsError(e.toString()));
    }
  }

  Future<void> _onApproveVendor(
    ApproveVendor event,
    Emitter<VendorsState> emit,
  ) async {
    try {
      await dio.put('/admin/vendors/${event.vendorId}/approve');
      emit(VendorApproved(event.vendorId));
    } catch (e) {
      emit(VendorsError(e.toString()));
    }
  }

  Future<void> _onRejectVendor(
    RejectVendor event,
    Emitter<VendorsState> emit,
  ) async {
    try {
      await dio.put(
        '/admin/vendors/${event.vendorId}/reject',
        data: {'reason': event.reason},
      );
      emit(VendorRejected(event.vendorId));
    } catch (e) {
      emit(VendorsError(e.toString()));
    }
  }

  Future<void> _onSuspendVendor(
    SuspendVendor event,
    Emitter<VendorsState> emit,
  ) async {
    try {
      await dio.put(
        '/admin/vendors/${event.vendorId}/suspend',
        data: {'reason': event.reason},
      );
      emit(VendorSuspended(event.vendorId));
    } catch (e) {
      emit(VendorsError(e.toString()));
    }
  }
}
