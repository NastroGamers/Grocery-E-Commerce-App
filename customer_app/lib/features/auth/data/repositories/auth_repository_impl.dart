import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final SharedPreferences sharedPreferences;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.sharedPreferences,
  });

  @override
  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await remoteDataSource.login(request);
      await _saveAuthData(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AuthResponse> register(RegisterRequest request) async {
    try {
      final response = await remoteDataSource.register(request);
      await _saveAuthData(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> sendOtp(OtpRequest request) async {
    try {
      await remoteDataSource.sendOtp(request);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AuthResponse> verifyOtp(VerifyOtpRequest request) async {
    try {
      final response = await remoteDataSource.verifyOtp(request);
      await _saveAuthData(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AuthResponse> googleSignIn(String idToken) async {
    try {
      final response = await remoteDataSource.googleSignIn(idToken);
      await _saveAuthData(response);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> forgotPassword(ForgotPasswordRequest request) async {
    try {
      await remoteDataSource.forgotPassword(request);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> resetPassword(ResetPasswordRequest request) async {
    try {
      await remoteDataSource.resetPassword(request);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await remoteDataSource.logout();
      await _clearAuthData();
    } catch (e) {
      // Clear local data even if remote logout fails
      await _clearAuthData();
      rethrow;
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final userData = sharedPreferences.getString('user_data');
      if (userData != null) {
        return UserModel.fromJson(json.decode(userData));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = sharedPreferences.getString('auth_token');
    return token != null && token.isNotEmpty;
  }

  // Private helper methods
  Future<void> _saveAuthData(AuthResponse response) async {
    await sharedPreferences.setString('auth_token', response.accessToken);
    await sharedPreferences.setString('refresh_token', response.refreshToken);
    await sharedPreferences.setString(
      'user_data',
      json.encode(response.user.toJson()),
    );
  }

  Future<void> _clearAuthData() async {
    await sharedPreferences.remove('auth_token');
    await sharedPreferences.remove('refresh_token');
    await sharedPreferences.remove('user_data');
  }
}
