import '../repositories/qr_payment_repository.dart';
import '../../data/models/qr_payment_model.dart';

class GenerateQRUseCase {
  final QRPaymentRepository repository;

  GenerateQRUseCase(this.repository);

  Future<QRPaymentResponse> call(GenerateQRRequest request) async {
    return await repository.generateQRCode(request);
  }
}
