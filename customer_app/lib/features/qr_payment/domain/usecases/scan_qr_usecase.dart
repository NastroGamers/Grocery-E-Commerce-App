import '../repositories/qr_payment_repository.dart';

class ScanQRUseCase {
  final QRPaymentRepository repository;

  ScanQRUseCase(this.repository);

  Future<Map<String, dynamic>> call(String qrData) async {
    return await repository.parseQRCode(qrData);
  }
}
