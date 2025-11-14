part of 'qr_payment_bloc.dart';

abstract class QRPaymentEvent extends Equatable {
  const QRPaymentEvent();

  @override
  List<Object?> get props => [];
}

class GenerateQRCodeEvent extends QRPaymentEvent {
  final GenerateQRRequest request;

  const GenerateQRCodeEvent(this.request);

  @override
  List<Object?> get props => [request];
}

class ScanQRCodeEvent extends QRPaymentEvent {
  final String qrData;

  const ScanQRCodeEvent(this.qrData);

  @override
  List<Object?> get props => [qrData];
}

class VerifyPaymentEvent extends QRPaymentEvent {
  final VerifyQRPaymentRequest request;

  const VerifyPaymentEvent(this.request);

  @override
  List<Object?> get props => [request];
}

class CheckPaymentStatusEvent extends QRPaymentEvent {
  final String paymentId;

  const CheckPaymentStatusEvent(this.paymentId);

  @override
  List<Object?> get props => [paymentId];
}

class StartStatusPollingEvent extends QRPaymentEvent {
  final String paymentId;

  const StartStatusPollingEvent(this.paymentId);

  @override
  List<Object?> get props => [paymentId];
}

class StopStatusPollingEvent extends QRPaymentEvent {
  const StopStatusPollingEvent();
}
