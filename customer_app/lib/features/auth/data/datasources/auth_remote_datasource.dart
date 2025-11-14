import '../../../../core/network/dio_client.dart';
import '../../../../core/config/app_config.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponse> login(LoginRequest request);
  Future<AuthResponse> register(RegisterRequest request);
  Future<void> sendOtp(OtpRequest request);
  Future<AuthResponse> verifyOtp(VerifyOtpRequest request);
  Future<AuthResponse> googleSignIn(String idToken);
  Future<void> forgotPassword(ForgotPasswordRequest request);
  Future<void> resetPassword(ResetPasswordRequest request);
  Future<AuthResponse> refreshToken(String refreshToken);
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _dioClient;

  AuthRemoteDataSourceImpl(this._dioClient);

  @override
  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await _dioClient.post(
        '${AppConfig.authEndpoint}/login',
        data: request.toJson(),
      );
      return AuthResponse.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AuthResponse> register(RegisterRequest request) async {
    try {
      final response = await _dioClient.post(
        '${AppConfig.authEndpoint}/register',
        data: request.toJson(),
      );
      return AuthResponse.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> sendOtp(OtpRequest request) async {
    try {
      await _dioClient.post(
        '${AppConfig.authEndpoint}/send-otp',
        data: request.toJson(),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AuthResponse> verifyOtp(VerifyOtpRequest request) async {
    try {
      final response = await _dioClient.post(
        '${AppConfig.authEndpoint}/verify-otp',
        data: request.toJson(),
      );
      return AuthResponse.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AuthResponse> googleSignIn(String idToken) async {
    try {
      final response = await _dioClient.post(
        '${AppConfig.authEndpoint}/google-callback',
        data: {'idToken': idToken},
      );
      return AuthResponse.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> forgotPassword(ForgotPasswordRequest request) async {
    try {
      await _dioClient.post(
        '${AppConfig.authEndpoint}/forgot-password',
        data: request.toJson(),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> resetPassword(ResetPasswordRequest request) async {
    try {
      await _dioClient.post(
        '${AppConfig.authEndpoint}/reset-password',
        data: request.toJson(),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AuthResponse> refreshToken(String refreshToken) async {
    try {
      final response = await _dioClient.post(
        '${AppConfig.authEndpoint}/refresh-token',
        data: {'refreshToken': refreshToken},
      );
      return AuthResponse.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _dioClient.post('${AppConfig.authEndpoint}/logout');
    } catch (e) {
      rethrow;
    }
  }
}
