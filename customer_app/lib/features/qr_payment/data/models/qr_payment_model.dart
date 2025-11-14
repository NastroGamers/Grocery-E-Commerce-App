import 'package:json_annotation/json_annotation.dart';

part 'qr_payment_model.g.dart';

@JsonSerializable()
class QRPaymentModel {
  @JsonKey(name: 'payment_id')
  final String paymentId;

  @JsonKey(name: 'order_id')
  final String orderId;

  @JsonKey(name: 'amount')
  final double amount;

  @JsonKey(name: 'currency')
  final String currency;

  @JsonKey(name: 'status')
  final String status;

  @JsonKey(name: 'qr_data')
  final String? qrData;

  @JsonKey(name: 'upi_id')
  final String? upiId;

  @JsonKey(name: 'merchant_name')
  final String merchantName;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'expires_at')
  final DateTime? expiresAt;

  const QRPaymentModel({
    required this.paymentId,
    required this.orderId,
    required this.amount,
    required this.currency,
    required this.status,
    this.qrData,
    this.upiId,
    required this.merchantName,
    required this.createdAt,
    this.expiresAt,
  });

  factory QRPaymentModel.fromJson(Map<String, dynamic> json) =>
      _$QRPaymentModelFromJson(json);

  Map<String, dynamic> toJson() => _$QRPaymentModelToJson(this);
}

@JsonSerializable()
class GenerateQRRequest {
  @JsonKey(name: 'order_id')
  final String orderId;

  @JsonKey(name: 'amount')
  final double amount;

  @JsonKey(name: 'upi_id')
  final String? upiId;

  const GenerateQRRequest({
    required this.orderId,
    required this.amount,
    this.upiId,
  });

  factory GenerateQRRequest.fromJson(Map<String, dynamic> json) =>
      _$GenerateQRRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GenerateQRRequestToJson(this);
}

@JsonSerializable()
class VerifyQRPaymentRequest {
  @JsonKey(name: 'payment_id')
  final String paymentId;

  @JsonKey(name: 'transaction_reference')
  final String transactionReference;

  const VerifyQRPaymentRequest({
    required this.paymentId,
    required this.transactionReference,
  });

  factory VerifyQRPaymentRequest.fromJson(Map<String, dynamic> json) =>
      _$VerifyQRPaymentRequestFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyQRPaymentRequestToJson(this);
}

@JsonSerializable()
class QRPaymentResponse {
  @JsonKey(name: 'payment')
  final QRPaymentModel payment;

  @JsonKey(name: 'qr_code_data')
  final String qrCodeData;

  @JsonKey(name: 'message')
  final String? message;

  const QRPaymentResponse({
    required this.payment,
    required this.qrCodeData,
    this.message,
  });

  factory QRPaymentResponse.fromJson(Map<String, dynamic> json) =>
      _$QRPaymentResponseFromJson(json);

  Map<String, dynamic> toJson() => _$QRPaymentResponseToJson(this);
}
