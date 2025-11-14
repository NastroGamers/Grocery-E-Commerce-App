import '../../data/models/user_model.dart';

abstract class AuthRepository {
  Future<AuthResponse> login(LoginRequest request);
  Future<AuthResponse> register(RegisterRequest request);
  Future<void> sendOtp(OtpRequest request);
  Future<AuthResponse> verifyOtp(VerifyOtpRequest request);
  Future<AuthResponse> googleSignIn(String idToken);
  Future<void> forgotPassword(ForgotPasswordRequest request);
  Future<void> resetPassword(ResetPasswordRequest request);
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
  Future<bool> isLoggedIn();
}
