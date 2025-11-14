import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/user_model.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/send_otp_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';

// Events
abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CheckAuthStatusEvent extends AuthEvent {}

class LoginWithEmailEvent extends AuthEvent {
  final String email;
  final String password;

  LoginWithEmailEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class LoginWithPhoneEvent extends AuthEvent {
  final String phone;

  LoginWithPhoneEvent({required this.phone});

  @override
  List<Object?> get props => [phone];
}

class RegisterWithEmailEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;

  RegisterWithEmailEvent({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [name, email, password];
}

class RegisterWithPhoneEvent extends AuthEvent {
  final String name;
  final String phone;

  RegisterWithPhoneEvent({required this.name, required this.phone});

  @override
  List<Object?> get props => [name, phone];
}

class SendOtpEvent extends AuthEvent {
  final String phone;
  final String purpose;

  SendOtpEvent({required this.phone, required this.purpose});

  @override
  List<Object?> get props => [phone, purpose];
}

class VerifyOtpEvent extends AuthEvent {
  final String phone;
  final String otp;
  final String purpose;

  VerifyOtpEvent({
    required this.phone,
    required this.otp,
    required this.purpose,
  });

  @override
  List<Object?> get props => [phone, otp, purpose];
}

class GoogleSignInEvent extends AuthEvent {}

class LogoutEvent extends AuthEvent {}

// States
abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final UserModel user;

  AuthAuthenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class OtpSent extends AuthState {
  final String phone;
  final String message;

  OtpSent({required this.phone, required this.message});

  @override
  List<Object?> get props => [phone, message];
}

class AuthError extends AuthState {
  final String message;

  AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final SendOtpUseCase sendOtpUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.sendOtpUseCase,
    required this.verifyOtpUseCase,
  }) : super(AuthInitial()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<LoginWithEmailEvent>(_onLoginWithEmail);
    on<LoginWithPhoneEvent>(_onLoginWithPhone);
    on<RegisterWithEmailEvent>(_onRegisterWithEmail);
    on<RegisterWithPhoneEvent>(_onRegisterWithPhone);
    on<SendOtpEvent>(_onSendOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      // Check if user is logged in from local storage
      await Future.delayed(const Duration(seconds: 1));
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLoginWithEmail(
    LoginWithEmailEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final request = LoginRequest(
        email: event.email,
        password: event.password,
        loginType: 'email',
      );

      final response = await loginUseCase.execute(request);
      emit(AuthAuthenticated(user: response.user));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onLoginWithPhone(
    LoginWithPhoneEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      // First send OTP
      final otpRequest = OtpRequest(
        phone: event.phone,
        purpose: 'login',
      );
      await sendOtpUseCase.execute(otpRequest);
      emit(OtpSent(
        phone: event.phone,
        message: 'OTP sent successfully to ${event.phone}',
      ));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onRegisterWithEmail(
    RegisterWithEmailEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final request = RegisterRequest(
        name: event.name,
        email: event.email,
        password: event.password,
        registerType: 'email',
      );

      final response = await registerUseCase.execute(request);
      emit(AuthAuthenticated(user: response.user));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onRegisterWithPhone(
    RegisterWithPhoneEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      // First send OTP
      final otpRequest = OtpRequest(
        phone: event.phone,
        purpose: 'register',
      );
      await sendOtpUseCase.execute(otpRequest);
      emit(OtpSent(
        phone: event.phone,
        message: 'OTP sent successfully to ${event.phone}',
      ));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onSendOtp(
    SendOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final request = OtpRequest(
        phone: event.phone,
        purpose: event.purpose,
      );
      await sendOtpUseCase.execute(request);
      emit(OtpSent(
        phone: event.phone,
        message: 'OTP sent successfully to ${event.phone}',
      ));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onVerifyOtp(
    VerifyOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final request = VerifyOtpRequest(
        phone: event.phone,
        otp: event.otp,
        purpose: event.purpose,
      );

      final response = await verifyOtpUseCase.execute(request);
      emit(AuthAuthenticated(user: response.user));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      // Perform logout
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}
