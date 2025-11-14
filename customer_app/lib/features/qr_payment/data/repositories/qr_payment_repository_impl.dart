import '../../domain/repositories/qr_payment_repository.dart';
import '../datasources/qr_payment_remote_datasource.dart';
import '../models/qr_payment_model.dart';

class QRPaymentRepositoryImpl implements QRPaymentRepository {
  final QRPaymentRemoteDataSource remoteDataSource;

  QRPaymentRepositoryImpl(this.remoteDataSource);

  @override
  Future<QRPaymentResponse> generateQRCode(GenerateQRRequest request) async {
    try {
      return await remoteDataSource.generateQRCode(request);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<QRPaymentModel> verifyPayment(VerifyQRPaymentRequest request) async {
    try {
      return await remoteDataSource.verifyPayment(request);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<QRPaymentModel> getPaymentStatus(String paymentId) async {
    try {
      return await remoteDataSource.getPaymentStatus(paymentId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> parseQRCode(String qrData) async {
    try {
      // Parse UPI QR code format
      // Format: upi://pay?pa=merchant@upi&pn=MerchantName&am=100.00&cu=INR&tn=OrderID
      final uri = Uri.parse(qrData);

      if (uri.scheme != 'upi') {
        throw Exception('Invalid QR code format');
      }

      final queryParams = uri.queryParameters;

      return {
        'upi_id': queryParams['pa'],
        'merchant_name': queryParams['pn'],
        'amount': double.tryParse(queryParams['am'] ?? '0') ?? 0.0,
        'currency': queryParams['cu'] ?? 'INR',
        'transaction_note': queryParams['tn'],
        'transaction_ref': queryParams['tr'],
      };
    } catch (e) {
      rethrow;
    }
  }
}
