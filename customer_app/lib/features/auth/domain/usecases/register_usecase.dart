import '../repositories/auth_repository.dart';
import '../../data/models/user_model.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<AuthResponse> execute(RegisterRequest request) async {
    return await repository.register(request);
  }
}
