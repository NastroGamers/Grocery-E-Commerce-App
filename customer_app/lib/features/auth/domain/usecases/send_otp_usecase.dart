import '../repositories/auth_repository.dart';
import '../../data/models/user_model.dart';

class SendOtpUseCase {
  final AuthRepository repository;

  SendOtpUseCase(this.repository);

  Future<void> execute(OtpRequest request) async {
    return await repository.sendOtp(request);
  }
}
