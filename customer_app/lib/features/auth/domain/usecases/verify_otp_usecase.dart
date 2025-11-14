import '../repositories/auth_repository.dart';
import '../../data/models/user_model.dart';

class VerifyOtpUseCase {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<AuthResponse> execute(VerifyOtpRequest request) async {
    return await repository.verifyOtp(request);
  }
}
