import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? googleId;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final String? profilePicUrl;
  final DateTime createdAt;
  final DateTime? lastLogin;

  UserModel({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.googleId,
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    this.profilePicUrl,
    required this.createdAt,
    this.lastLogin,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? googleId,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    String? profilePicUrl,
    DateTime? createdAt,
    DateTime? lastLogin,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      googleId: googleId ?? this.googleId,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      profilePicUrl: profilePicUrl ?? this.profilePicUrl,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }
}

@JsonSerializable()
class AuthResponse {
  final UserModel user;
  final String accessToken;
  final String refreshToken;

  AuthResponse({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}

@JsonSerializable()
class LoginRequest {
  final String? email;
  final String? phone;
  final String? password;
  final String? loginType; // 'email', 'phone', 'google'

  LoginRequest({
    this.email,
    this.phone,
    this.password,
    this.loginType,
  });

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

@JsonSerializable()
class RegisterRequest {
  final String name;
  final String? email;
  final String? phone;
  final String? password;
  final String? googleId;
  final String registerType; // 'email', 'phone', 'google'

  RegisterRequest({
    required this.name,
    this.email,
    this.phone,
    this.password,
    this.googleId,
    required this.registerType,
  });

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}

@JsonSerializable()
class OtpRequest {
  final String phone;
  final String purpose; // 'login', 'register', 'forgot_password'

  OtpRequest({
    required this.phone,
    required this.purpose,
  });

  Map<String, dynamic> toJson() => _$OtpRequestToJson(this);
}

@JsonSerializable()
class VerifyOtpRequest {
  final String phone;
  final String otp;
  final String purpose;

  VerifyOtpRequest({
    required this.phone,
    required this.otp,
    required this.purpose,
  });

  Map<String, dynamic> toJson() => _$VerifyOtpRequestToJson(this);
}

@JsonSerializable()
class ForgotPasswordRequest {
  final String email;

  ForgotPasswordRequest({required this.email});

  Map<String, dynamic> toJson() => _$ForgotPasswordRequestToJson(this);
}

@JsonSerializable()
class ResetPasswordRequest {
  final String email;
  final String resetToken;
  final String newPassword;

  ResetPasswordRequest({
    required this.email,
    required this.resetToken,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() => _$ResetPasswordRequestToJson(this);
}
