import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/order_model.dart';
import '../../domain/usecases/validate_checkout_usecase.dart';
import '../../domain/usecases/create_order_usecase.dart';
import '../../domain/usecases/process_payment_usecase.dart';

// Events
abstract class CheckoutEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CalculateOrderSummaryEvent extends CheckoutEvent {
  final List<OrderItemModel> items;
  final String deliveryAddressId;
  final String? couponCode;

  CalculateOrderSummaryEvent({
    required this.items,
    required this.deliveryAddressId,
    this.couponCode,
  });

  @override
  List<Object?> get props => [items, deliveryAddressId, couponCode];
}

class CheckStockAvailabilityEvent extends CheckoutEvent {
  final List<OrderItemModel> items;

  CheckStockAvailabilityEvent({required this.items});

  @override
  List<Object?> get props => [items];
}

class ValidateCheckoutEvent extends CheckoutEvent {
  final List<OrderItemModel> items;
  final String deliveryAddressId;
  final String deliverySlotId;
  final DateTime deliveryDate;
  final PaymentMethod paymentMethod;

  ValidateCheckoutEvent({
    required this.items,
    required this.deliveryAddressId,
    required this.deliverySlotId,
    required this.deliveryDate,
    required this.paymentMethod,
  });

  @override
  List<Object?> get props => [
    items,
    deliveryAddressId,
    deliverySlotId,
    deliveryDate,
    paymentMethod,
  ];
}

class CreateOrderEvent extends CheckoutEvent {
  final List<OrderItemModel> items;
  final String deliveryAddressId;
  final String deliverySlotId;
  final DateTime deliveryDate;
  final PaymentMethod paymentMethod;
  final String? appliedCouponCode;
  final String? deliveryInstructions;

  CreateOrderEvent({
    required this.items,
    required this.deliveryAddressId,
    required this.deliverySlotId,
    required this.deliveryDate,
    required this.paymentMethod,
    this.appliedCouponCode,
    this.deliveryInstructions,
  });

  @override
  List<Object?> get props => [
    items,
    deliveryAddressId,
    deliverySlotId,
    deliveryDate,
    paymentMethod,
    appliedCouponCode,
    deliveryInstructions,
  ];
}

class InitiatePaymentEvent extends CheckoutEvent {
  final String orderId;
  final double amount;
  final PaymentMethod paymentMethod;
  final String currency;
  final Map<String, dynamic>? metadata;

  InitiatePaymentEvent({
    required this.orderId,
    required this.amount,
    required this.paymentMethod,
    this.currency = 'INR',
    this.metadata,
  });

  @override
  List<Object?> get props => [orderId, amount, paymentMethod, currency, metadata];
}

class VerifyPaymentEvent extends CheckoutEvent {
  final String orderId;
  final String paymentId;
  final String? gatewayPaymentId;
  final String? gatewaySignature;
  final PaymentStatus status;
  final String? errorMessage;

  VerifyPaymentEvent({
    required this.orderId,
    required this.paymentId,
    this.gatewayPaymentId,
    this.gatewaySignature,
    required this.status,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
    orderId,
    paymentId,
    gatewayPaymentId,
    gatewaySignature,
    status,
    errorMessage,
  ];
}

class RetryPaymentEvent extends CheckoutEvent {
  final String orderId;
  final double amount;
  final PaymentMethod paymentMethod;

  RetryPaymentEvent({
    required this.orderId,
    required this.amount,
    required this.paymentMethod,
  });

  @override
  List<Object?> get props => [orderId, amount, paymentMethod];
}

class LoadOrderDetailsEvent extends CheckoutEvent {
  final String orderId;

  LoadOrderDetailsEvent({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class CancelOrderEvent extends CheckoutEvent {
  final String orderId;
  final String reason;

  CancelOrderEvent({
    required this.orderId,
    required this.reason,
  });

  @override
  List<Object?> get props => [orderId, reason];
}

class ResetCheckoutEvent extends CheckoutEvent {}

// States
abstract class CheckoutState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CheckoutInitial extends CheckoutState {}

class CheckoutLoading extends CheckoutState {}

class OrderSummaryCalculated extends CheckoutState {
  final OrderSummary summary;

  OrderSummaryCalculated({required this.summary});

  @override
  List<Object?> get props => [summary];
}

class StockAvailabilityChecked extends CheckoutState {
  final CheckStockAvailabilityResponse response;

  StockAvailabilityChecked({required this.response});

  @override
  List<Object?> get props => [response];

  bool get allAvailable => response.allAvailable;
}

class CheckoutValidated extends CheckoutState {
  final String message;

  CheckoutValidated({required this.message});

  @override
  List<Object?> get props => [message];
}

class OrderCreated extends CheckoutState {
  final CreateOrderResponse response;

  OrderCreated({required this.response});

  @override
  List<Object?> get props => [response];

  OrderModel get order => response.order;
  bool get requiresPaymentGateway =>
      response.paymentGatewayOrderId != null &&
      response.order.paymentMethod != PaymentMethod.cod;
}

class PaymentInitiated extends CheckoutState {
  final PaymentInitiateResponse response;

  PaymentInitiated({required this.response});

  @override
  List<Object?> get props => [response];
}

class PaymentVerified extends CheckoutState {
  final PaymentVerifyResponse response;

  PaymentVerified({required this.response});

  @override
  List<Object?> get props => [response];

  bool get success => response.success;
  OrderModel get order => response.order;
  PaymentStatus get paymentStatus => response.paymentStatus;
}

class OrderDetailsLoaded extends CheckoutState {
  final OrderModel order;

  OrderDetailsLoaded({required this.order});

  @override
  List<Object?> get props => [order];
}

class OrderCancelled extends CheckoutState {
  final OrderModel order;
  final String message;

  OrderCancelled({
    required this.order,
    required this.message,
  });

  @override
  List<Object?> get props => [order, message];
}

class CheckoutError extends CheckoutState {
  final String message;
  final String? errorType; // 'stock', 'payment', 'order', 'validation'

  CheckoutError({
    required this.message,
    this.errorType,
  });

  @override
  List<Object?> get props => [message, errorType];

  bool get isStockError => errorType == 'stock';
  bool get isPaymentError => errorType == 'payment';
  bool get isOrderError => errorType == 'order';
  bool get isValidationError => errorType == 'validation';
}

// Bloc
class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final ValidateCheckoutUseCase validateCheckoutUseCase;
  final CreateOrderUseCase createOrderUseCase;
  final ProcessPaymentUseCase processPaymentUseCase;

  CheckoutBloc({
    required this.validateCheckoutUseCase,
    required this.createOrderUseCase,
    required this.processPaymentUseCase,
  }) : super(CheckoutInitial()) {
    on<CalculateOrderSummaryEvent>(_onCalculateOrderSummary);
    on<CheckStockAvailabilityEvent>(_onCheckStockAvailability);
    on<ValidateCheckoutEvent>(_onValidateCheckout);
    on<CreateOrderEvent>(_onCreateOrder);
    on<InitiatePaymentEvent>(_onInitiatePayment);
    on<VerifyPaymentEvent>(_onVerifyPayment);
    on<RetryPaymentEvent>(_onRetryPayment);
    on<LoadOrderDetailsEvent>(_onLoadOrderDetails);
    on<CancelOrderEvent>(_onCancelOrder);
    on<ResetCheckoutEvent>(_onResetCheckout);
  }

  Future<void> _onCalculateOrderSummary(
    CalculateOrderSummaryEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(CheckoutLoading());
    try {
      final summary = await validateCheckoutUseCase.calculateOrderSummary(
        items: event.items,
        deliveryAddressId: event.deliveryAddressId,
        couponCode: event.couponCode,
      );

      emit(OrderSummaryCalculated(summary: summary));
    } catch (e) {
      emit(CheckoutError(
        message: e.toString(),
        errorType: 'validation',
      ));
    }
  }

  Future<void> _onCheckStockAvailability(
    CheckStockAvailabilityEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    final previousState = state;
    emit(CheckoutLoading());

    try {
      final response = await validateCheckoutUseCase.checkStockAvailability(
        items: event.items,
      );

      emit(StockAvailabilityChecked(response: response));

      // Restore previous state if it was order summary
      if (previousState is OrderSummaryCalculated) {
        emit(previousState);
      }
    } catch (e) {
      emit(CheckoutError(
        message: e.toString(),
        errorType: 'stock',
      ));

      if (previousState is OrderSummaryCalculated) {
        emit(previousState);
      }
    }
  }

  Future<void> _onValidateCheckout(
    ValidateCheckoutEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(CheckoutLoading());
    try {
      await validateCheckoutUseCase.validateCheckout(
        items: event.items,
        deliveryAddressId: event.deliveryAddressId,
        deliverySlotId: event.deliverySlotId,
        deliveryDate: event.deliveryDate,
        paymentMethod: event.paymentMethod,
      );

      emit(CheckoutValidated(message: 'Checkout validated successfully'));
    } catch (e) {
      emit(CheckoutError(
        message: e.toString(),
        errorType: 'validation',
      ));
    }
  }

  Future<void> _onCreateOrder(
    CreateOrderEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(CheckoutLoading());
    try {
      final response = await createOrderUseCase.call(
        items: event.items,
        deliveryAddressId: event.deliveryAddressId,
        deliverySlotId: event.deliverySlotId,
        deliveryDate: event.deliveryDate,
        paymentMethod: event.paymentMethod,
        appliedCouponCode: event.appliedCouponCode,
        deliveryInstructions: event.deliveryInstructions,
      );

      emit(OrderCreated(response: response));

      // If payment method is not COD, automatically initiate payment
      if (event.paymentMethod != PaymentMethod.cod) {
        add(InitiatePaymentEvent(
          orderId: response.order.orderId,
          amount: response.order.total,
          paymentMethod: event.paymentMethod,
        ));
      }
    } catch (e) {
      emit(CheckoutError(
        message: e.toString(),
        errorType: 'order',
      ));
    }
  }

  Future<void> _onInitiatePayment(
    InitiatePaymentEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    final previousState = state;
    emit(CheckoutLoading());

    try {
      final response = await processPaymentUseCase.initiatePayment(
        orderId: event.orderId,
        amount: event.amount,
        paymentMethod: event.paymentMethod,
        currency: event.currency,
        metadata: event.metadata,
      );

      emit(PaymentInitiated(response: response));

      // For COD, automatically verify as completed
      if (event.paymentMethod == PaymentMethod.cod) {
        add(VerifyPaymentEvent(
          orderId: event.orderId,
          paymentId: response.paymentId,
          status: PaymentStatus.completed,
        ));
      }
    } catch (e) {
      emit(CheckoutError(
        message: e.toString(),
        errorType: 'payment',
      ));

      if (previousState is OrderCreated) {
        emit(previousState);
      }
    }
  }

  Future<void> _onVerifyPayment(
    VerifyPaymentEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(CheckoutLoading());
    try {
      final response = await processPaymentUseCase.verifyPayment(
        orderId: event.orderId,
        paymentId: event.paymentId,
        gatewayPaymentId: event.gatewayPaymentId,
        gatewaySignature: event.gatewaySignature,
        status: event.status,
        errorMessage: event.errorMessage,
      );

      emit(PaymentVerified(response: response));
    } catch (e) {
      emit(CheckoutError(
        message: e.toString(),
        errorType: 'payment',
      ));
    }
  }

  Future<void> _onRetryPayment(
    RetryPaymentEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(CheckoutLoading());
    try {
      final response = await processPaymentUseCase.retryPayment(
        orderId: event.orderId,
        amount: event.amount,
        paymentMethod: event.paymentMethod,
      );

      emit(PaymentInitiated(response: response));
    } catch (e) {
      emit(CheckoutError(
        message: e.toString(),
        errorType: 'payment',
      ));
    }
  }

  Future<void> _onLoadOrderDetails(
    LoadOrderDetailsEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(CheckoutLoading());
    try {
      final order = await createOrderUseCase.getOrderById(event.orderId);

      emit(OrderDetailsLoaded(order: order));
    } catch (e) {
      emit(CheckoutError(
        message: e.toString(),
        errorType: 'order',
      ));
    }
  }

  Future<void> _onCancelOrder(
    CancelOrderEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(CheckoutLoading());
    try {
      final order = await createOrderUseCase.cancelOrder(
        orderId: event.orderId,
        reason: event.reason,
      );

      emit(OrderCancelled(
        order: order,
        message: 'Order cancelled successfully',
      ));
    } catch (e) {
      emit(CheckoutError(
        message: e.toString(),
        errorType: 'order',
      ));
    }
  }

  Future<void> _onResetCheckout(
    ResetCheckoutEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(CheckoutInitial());
  }
}
