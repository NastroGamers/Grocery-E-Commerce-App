import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/qr_payment_model.dart';
import '../../domain/usecases/generate_qr_usecase.dart';
import '../../domain/usecases/scan_qr_usecase.dart';
import '../../domain/repositories/qr_payment_repository.dart';

part 'qr_payment_event.dart';
part 'qr_payment_state.dart';

class QRPaymentBloc extends Bloc<QRPaymentEvent, QRPaymentState> {
  final GenerateQRUseCase generateQRUseCase;
  final ScanQRUseCase scanQRUseCase;
  final QRPaymentRepository repository;

  Timer? _statusCheckTimer;

  QRPaymentBloc({
    required this.generateQRUseCase,
    required this.scanQRUseCase,
    required this.repository,
  }) : super(QRPaymentInitial()) {
    on<GenerateQRCodeEvent>(_onGenerateQRCode);
    on<ScanQRCodeEvent>(_onScanQRCode);
    on<VerifyPaymentEvent>(_onVerifyPayment);
    on<CheckPaymentStatusEvent>(_onCheckPaymentStatus);
    on<StartStatusPollingEvent>(_onStartStatusPolling);
    on<StopStatusPollingEvent>(_onStopStatusPolling);
  }

  Future<void> _onGenerateQRCode(
    GenerateQRCodeEvent event,
    Emitter<QRPaymentState> emit,
  ) async {
    emit(QRPaymentLoading());

    try {
      final response = await generateQRUseCase(event.request);

      emit(QRCodeGenerated(
        payment: response.payment,
        qrCodeData: response.qrCodeData,
      ));

      // Start polling for payment status
      add(StartStatusPollingEvent(response.payment.paymentId));
    } catch (e) {
      emit(QRPaymentError(e.toString()));
    }
  }

  Future<void> _onScanQRCode(
    ScanQRCodeEvent event,
    Emitter<QRPaymentState> emit,
  ) async {
    emit(QRPaymentLoading());

    try {
      final parsedData = await scanQRUseCase(event.qrData);
      emit(QRCodeScanned(parsedData: parsedData));
    } catch (e) {
      emit(QRPaymentError(e.toString()));
    }
  }

  Future<void> _onVerifyPayment(
    VerifyPaymentEvent event,
    Emitter<QRPaymentState> emit,
  ) async {
    emit(QRPaymentLoading());

    try {
      final payment = await repository.verifyPayment(event.request);

      if (payment.status == 'success' || payment.status == 'completed') {
        emit(PaymentVerified(payment: payment));
        add(const StopStatusPollingEvent());
      } else if (payment.status == 'failed') {
        emit(const QRPaymentError('Payment verification failed'));
        add(const StopStatusPollingEvent());
      } else {
        emit(PaymentPending(payment: payment));
      }
    } catch (e) {
      emit(QRPaymentError(e.toString()));
    }
  }

  Future<void> _onCheckPaymentStatus(
    CheckPaymentStatusEvent event,
    Emitter<QRPaymentState> emit,
  ) async {
    try {
      final payment = await repository.getPaymentStatus(event.paymentId);

      if (payment.status == 'success' || payment.status == 'completed') {
        emit(PaymentVerified(payment: payment));
        add(const StopStatusPollingEvent());
      } else if (payment.status == 'failed') {
        emit(const QRPaymentError('Payment failed'));
        add(const StopStatusPollingEvent());
      } else {
        emit(PaymentPending(payment: payment));
      }
    } catch (e) {
      // Don't emit error state during polling, just continue polling
    }
  }

  void _onStartStatusPolling(
    StartStatusPollingEvent event,
    Emitter<QRPaymentState> emit,
  ) {
    _statusCheckTimer?.cancel();
    _statusCheckTimer = Timer.periodic(
      const Duration(seconds: 3),
      (timer) {
        add(CheckPaymentStatusEvent(event.paymentId));
      },
    );
  }

  void _onStopStatusPolling(
    StopStatusPollingEvent event,
    Emitter<QRPaymentState> emit,
  ) {
    _statusCheckTimer?.cancel();
  }

  @override
  Future<void> close() {
    _statusCheckTimer?.cancel();
    return super.close();
  }
}
