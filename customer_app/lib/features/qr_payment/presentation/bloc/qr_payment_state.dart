part of 'qr_payment_bloc.dart';

abstract class QRPaymentState extends Equatable {
  const QRPaymentState();

  @override
  List<Object?> get props => [];
}

class QRPaymentInitial extends QRPaymentState {}

class QRPaymentLoading extends QRPaymentState {}

class QRCodeGenerated extends QRPaymentState {
  final QRPaymentModel payment;
  final String qrCodeData;

  const QRCodeGenerated({
    required this.payment,
    required this.qrCodeData,
  });

  @override
  List<Object?> get props => [payment, qrCodeData];
}

class QRCodeScanned extends QRPaymentState {
  final Map<String, dynamic> parsedData;

  const QRCodeScanned({required this.parsedData});

  @override
  List<Object?> get props => [parsedData];
}

class PaymentPending extends QRPaymentState {
  final QRPaymentModel payment;

  const PaymentPending({required this.payment});

  @override
  List<Object?> get props => [payment];
}

class PaymentVerified extends QRPaymentState {
  final QRPaymentModel payment;

  const PaymentVerified({required this.payment});

  @override
  List<Object?> get props => [payment];
}

class QRPaymentError extends QRPaymentState {
  final String message;

  const QRPaymentError(this.message);

  @override
  List<Object?> get props => [message];
}
