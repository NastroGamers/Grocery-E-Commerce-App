import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/coupon_model.dart';
import '../../domain/usecases/manage_coupons_usecase.dart';

// Events
abstract class CouponEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadCouponsEvent extends CouponEvent {}

class ValidateCouponEvent extends CouponEvent {
  final String code;
  final double orderSubtotal;
  final List<String> productIds;
  final List<String> categoryIds;

  ValidateCouponEvent({
    required this.code,
    required this.orderSubtotal,
    required this.productIds,
    required this.categoryIds,
  });

  @override
  List<Object?> get props => [code, orderSubtotal, productIds, categoryIds];
}

class ApplyCouponEvent extends CouponEvent {
  final String code;
  final double orderSubtotal;
  final List<String> productIds;
  final List<String> categoryIds;

  ApplyCouponEvent({
    required this.code,
    required this.orderSubtotal,
    required this.productIds,
    required this.categoryIds,
  });

  @override
  List<Object?> get props => [code, orderSubtotal, productIds, categoryIds];
}

class RemoveCouponEvent extends CouponEvent {
  final String code;

  RemoveCouponEvent({required this.code});

  @override
  List<Object?> get props => [code];
}

class LoadCouponUsageEvent extends CouponEvent {}

class GetCouponByCodeEvent extends CouponEvent {
  final String code;

  GetCouponByCodeEvent({required this.code});

  @override
  List<Object?> get props => [code];
}

class GetBestCouponEvent extends CouponEvent {
  final double orderSubtotal;
  final List<String> productIds;
  final List<String> categoryIds;

  GetBestCouponEvent({
    required this.orderSubtotal,
    required this.productIds,
    required this.categoryIds,
  });

  @override
  List<Object?> get props => [orderSubtotal, productIds, categoryIds];
}

class SelectCouponEvent extends CouponEvent {
  final CouponModel coupon;

  SelectCouponEvent({required this.coupon});

  @override
  List<Object?> get props => [coupon];
}

class ClearCouponSelectionEvent extends CouponEvent {}

// States
abstract class CouponState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CouponInitial extends CouponState {}

class CouponLoading extends CouponState {}

class CouponsLoaded extends CouponState {
  final CouponListResponse response;
  final CouponModel? selectedCoupon;

  CouponsLoaded({
    required this.response,
    this.selectedCoupon,
  });

  @override
  List<Object?> get props => [response, selectedCoupon];

  List<CouponModel> get availableCoupons => response.availableCoupons;
  List<CouponModel> get usedCoupons => response.usedCoupons;
  bool get hasAvailableCoupons => response.availableCoupons.isNotEmpty;
  int get availableCouponCount => response.availableCoupons.length;
}

class CouponValidated extends CouponState {
  final ValidateCouponResponse response;

  CouponValidated({required this.response});

  @override
  List<Object?> get props => [response];

  bool get isValid => response.isValid;
  String get message => response.message;
  CouponModel? get coupon => response.coupon;
  double? get discountAmount => response.discountAmount;
}

class CouponApplied extends CouponState {
  final ApplyCouponResponse response;

  CouponApplied({required this.response});

  @override
  List<Object?> get props => [response];

  CouponModel get coupon => response.coupon;
  double get discountAmount => response.discountAmount;
  double get subtotal => response.subtotal;
  double get finalAmount => response.finalAmount;
  String get message => response.message;
}

class CouponRemoved extends CouponState {
  final String message;

  CouponRemoved({required this.message});

  @override
  List<Object?> get props => [message];
}

class CouponUsageLoaded extends CouponState {
  final List<UserCouponUsage> usage;

  CouponUsageLoaded({required this.usage});

  @override
  List<Object?> get props => [usage];

  int get totalUsedCoupons => usage.length;
}

class CouponDetailsLoaded extends CouponState {
  final CouponModel coupon;

  CouponDetailsLoaded({required this.coupon});

  @override
  List<Object?> get props => [coupon];
}

class BestCouponFound extends CouponState {
  final CouponModel? bestCoupon;
  final double? potentialSavings;
  final String message;

  BestCouponFound({
    this.bestCoupon,
    this.potentialSavings,
    required this.message,
  });

  @override
  List<Object?> get props => [bestCoupon, potentialSavings, message];

  bool get hasBestCoupon => bestCoupon != null;
}

class CouponSelected extends CouponState {
  final CouponModel coupon;

  CouponSelected({required this.coupon});

  @override
  List<Object?> get props => [coupon];
}

class CouponError extends CouponState {
  final String message;

  CouponError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Bloc
class CouponBloc extends Bloc<CouponEvent, CouponState> {
  final ManageCouponsUseCase manageCouponsUseCase;

  CouponBloc({
    required this.manageCouponsUseCase,
  }) : super(CouponInitial()) {
    on<LoadCouponsEvent>(_onLoadCoupons);
    on<ValidateCouponEvent>(_onValidateCoupon);
    on<ApplyCouponEvent>(_onApplyCoupon);
    on<RemoveCouponEvent>(_onRemoveCoupon);
    on<LoadCouponUsageEvent>(_onLoadCouponUsage);
    on<GetCouponByCodeEvent>(_onGetCouponByCode);
    on<GetBestCouponEvent>(_onGetBestCoupon);
    on<SelectCouponEvent>(_onSelectCoupon);
    on<ClearCouponSelectionEvent>(_onClearSelection);
  }

  Future<void> _onLoadCoupons(
    LoadCouponsEvent event,
    Emitter<CouponState> emit,
  ) async {
    emit(CouponLoading());
    try {
      final response = await manageCouponsUseCase.getCoupons();

      emit(CouponsLoaded(response: response));
    } catch (e) {
      emit(CouponError(message: e.toString()));
    }
  }

  Future<void> _onValidateCoupon(
    ValidateCouponEvent event,
    Emitter<CouponState> emit,
  ) async {
    final previousState = state;
    emit(CouponLoading());

    try {
      final response = await manageCouponsUseCase.validateCoupon(
        code: event.code,
        orderSubtotal: event.orderSubtotal,
        productIds: event.productIds,
        categoryIds: event.categoryIds,
      );

      emit(CouponValidated(response: response));

      // Restore previous state after a brief moment
      if (previousState is CouponsLoaded) {
        emit(previousState);
      }
    } catch (e) {
      emit(CouponError(message: e.toString()));

      if (previousState is CouponsLoaded) {
        emit(previousState);
      }
    }
  }

  Future<void> _onApplyCoupon(
    ApplyCouponEvent event,
    Emitter<CouponState> emit,
  ) async {
    emit(CouponLoading());
    try {
      final response = await manageCouponsUseCase.applyCoupon(
        code: event.code,
        orderSubtotal: event.orderSubtotal,
        productIds: event.productIds,
        categoryIds: event.categoryIds,
      );

      emit(CouponApplied(response: response));
    } catch (e) {
      emit(CouponError(message: e.toString()));
    }
  }

  Future<void> _onRemoveCoupon(
    RemoveCouponEvent event,
    Emitter<CouponState> emit,
  ) async {
    emit(CouponLoading());
    try {
      await manageCouponsUseCase.removeCoupon(event.code);

      emit(CouponRemoved(message: 'Coupon removed successfully'));

      // Reload coupons
      add(LoadCouponsEvent());
    } catch (e) {
      emit(CouponError(message: e.toString()));
    }
  }

  Future<void> _onLoadCouponUsage(
    LoadCouponUsageEvent event,
    Emitter<CouponState> emit,
  ) async {
    emit(CouponLoading());
    try {
      final usage = await manageCouponsUseCase.getUserCouponUsage();

      emit(CouponUsageLoaded(usage: usage));
    } catch (e) {
      emit(CouponError(message: e.toString()));
    }
  }

  Future<void> _onGetCouponByCode(
    GetCouponByCodeEvent event,
    Emitter<CouponState> emit,
  ) async {
    emit(CouponLoading());
    try {
      final coupon = await manageCouponsUseCase.getCouponByCode(event.code);

      emit(CouponDetailsLoaded(coupon: coupon));
    } catch (e) {
      emit(CouponError(message: e.toString()));
    }
  }

  Future<void> _onGetBestCoupon(
    GetBestCouponEvent event,
    Emitter<CouponState> emit,
  ) async {
    final previousState = state;
    emit(CouponLoading());

    try {
      // First load all coupons
      final response = await manageCouponsUseCase.getCoupons();

      // Find best coupon
      final bestCoupon = manageCouponsUseCase.getBestCouponForCart(
        coupons: response.availableCoupons,
        orderSubtotal: event.orderSubtotal,
        productIds: event.productIds,
        categoryIds: event.categoryIds,
      );

      double? potentialSavings;
      String message;

      if (bestCoupon != null) {
        potentialSavings = manageCouponsUseCase.calculateDiscountAmount(
          coupon: bestCoupon,
          orderSubtotal: event.orderSubtotal,
        );
        message = 'Save ₹${potentialSavings.toStringAsFixed(0)} with ${bestCoupon.code}';
      } else {
        message = 'No applicable coupons available for your cart';
      }

      emit(BestCouponFound(
        bestCoupon: bestCoupon,
        potentialSavings: potentialSavings,
        message: message,
      ));

      // Restore coupons loaded state
      emit(CouponsLoaded(response: response));
    } catch (e) {
      emit(CouponError(message: e.toString()));

      if (previousState is CouponsLoaded) {
        emit(previousState);
      }
    }
  }

  Future<void> _onSelectCoupon(
    SelectCouponEvent event,
    Emitter<CouponState> emit,
  ) async {
    if (state is CouponsLoaded) {
      final currentState = state as CouponsLoaded;

      emit(CouponsLoaded(
        response: currentState.response,
        selectedCoupon: event.coupon,
      ));

      emit(CouponSelected(coupon: event.coupon));
    } else {
      emit(CouponSelected(coupon: event.coupon));
    }
  }

  Future<void> _onClearSelection(
    ClearCouponSelectionEvent event,
    Emitter<CouponState> emit,
  ) async {
    if (state is CouponsLoaded) {
      final currentState = state as CouponsLoaded;
      emit(CouponsLoaded(
        response: currentState.response,
        selectedCoupon: null,
      ));
    } else {
      emit(CouponInitial());
    }
  }
}
