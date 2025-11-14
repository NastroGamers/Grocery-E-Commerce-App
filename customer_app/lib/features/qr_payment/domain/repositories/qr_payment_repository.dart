import '../../data/models/qr_payment_model.dart';

abstract class QRPaymentRepository {
  /// Generate QR code for payment
  Future<QRPaymentResponse> generateQRCode(GenerateQRRequest request);

  /// Verify QR payment
  Future<QRPaymentModel> verifyPayment(VerifyQRPaymentRequest request);

  /// Get payment status
  Future<QRPaymentModel> getPaymentStatus(String paymentId);

  /// Scan and parse QR code data
  Future<Map<String, dynamic>> parseQRCode(String qrData);
}
