import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/delivery_person_auth_model.dart';
import 'package:dio/dio.dart';

// Events
abstract class DeliveryAuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class DeliveryLogin extends DeliveryAuthEvent {
  final String emailOrPhone;
  final String password;

  DeliveryLogin({required this.emailOrPhone, required this.password});

  @override
  List<Object?> get props => [emailOrPhone, password];
}

class DeliveryVerifyOTP extends DeliveryAuthEvent {
  final String phone;
  final String otp;

  DeliveryVerifyOTP({required this.phone, required this.otp});

  @override
  List<Object?> get props => [phone, otp];
}

class UpdateDeliveryProfile extends DeliveryAuthEvent {
  final Map<String, dynamic> updates;

  UpdateDeliveryProfile(this.updates);

  @override
  List<Object?> get props => [updates];
}

class UploadDocuments extends DeliveryAuthEvent {
  final String licenseImage;
  final String vehicleImage;

  UploadDocuments({required this.licenseImage, required this.vehicleImage});

  @override
  List<Object?> get props => [licenseImage, vehicleImage];
}

class DeliveryLogout extends DeliveryAuthEvent {}

// States
abstract class DeliveryAuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DeliveryAuthInitial extends DeliveryAuthState {}

class DeliveryAuthLoading extends DeliveryAuthState {}

class DeliveryAuthenticated extends DeliveryAuthState {
  final DeliveryPersonAuthModel user;
  final String token;

  DeliveryAuthenticated({required this.user, required this.token});

  @override
  List<Object?> get props => [user, token];
}

class DeliveryOTPSent extends DeliveryAuthState {
  final String phone;

  DeliveryOTPSent(this.phone);

  @override
  List<Object?> get props => [phone];
}

class DeliveryProfileUpdated extends DeliveryAuthState {
  final DeliveryPersonAuthModel user;

  DeliveryProfileUpdated(this.user);

  @override
  List<Object?> get props => [user];
}

class DeliveryDocumentsUploaded extends DeliveryAuthState {}

class DeliveryUnauthenticated extends DeliveryAuthState {}

class DeliveryAuthError extends DeliveryAuthState {
  final String message;

  DeliveryAuthError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class DeliveryAuthBloc extends Bloc<DeliveryAuthEvent, DeliveryAuthState> {
  final Dio dio;

  DeliveryAuthBloc({required this.dio}) : super(DeliveryAuthInitial()) {
    on<DeliveryLogin>(_onLogin);
    on<DeliveryVerifyOTP>(_onVerifyOTP);
    on<UpdateDeliveryProfile>(_onUpdateProfile);
    on<UploadDocuments>(_onUploadDocuments);
    on<DeliveryLogout>(_onLogout);
  }

  Future<void> _onLogin(
    DeliveryLogin event,
    Emitter<DeliveryAuthState> emit,
  ) async {
    emit(DeliveryAuthLoading());

    try {
      final response = await dio.post(
        '/delivery/auth/login',
        data: {
          'emailOrPhone': event.emailOrPhone,
          'password': event.password,
        },
      );

      final authResponse = DeliveryAuthResponse.fromJson(response.data['data']);
      emit(DeliveryAuthenticated(user: authResponse.user, token: authResponse.token));
    } catch (e) {
      emit(DeliveryAuthError(e.toString()));
    }
  }

  Future<void> _onVerifyOTP(
    DeliveryVerifyOTP event,
    Emitter<DeliveryAuthState> emit,
  ) async {
    emit(DeliveryAuthLoading());

    try {
      final response = await dio.post(
        '/delivery/auth/verify-otp',
        data: {
          'phone': event.phone,
          'otp': event.otp,
        },
      );

      final authResponse = DeliveryAuthResponse.fromJson(response.data['data']);
      emit(DeliveryAuthenticated(user: authResponse.user, token: authResponse.token));
    } catch (e) {
      emit(DeliveryAuthError(e.toString()));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateDeliveryProfile event,
    Emitter<DeliveryAuthState> emit,
  ) async {
    try {
      final response = await dio.put('/delivery/profile', data: event.updates);
      final user = DeliveryPersonAuthModel.fromJson(response.data['data']);
      emit(DeliveryProfileUpdated(user));
    } catch (e) {
      emit(DeliveryAuthError(e.toString()));
    }
  }

  Future<void> _onUploadDocuments(
    UploadDocuments event,
    Emitter<DeliveryAuthState> emit,
  ) async {
    emit(DeliveryAuthLoading());

    try {
      await dio.post(
        '/delivery/documents/upload',
        data: {
          'licenseImage': event.licenseImage,
          'vehicleImage': event.vehicleImage,
        },
      );

      emit(DeliveryDocumentsUploaded());
    } catch (e) {
      emit(DeliveryAuthError(e.toString()));
    }
  }

  Future<void> _onLogout(
    DeliveryLogout event,
    Emitter<DeliveryAuthState> emit,
  ) async {
    emit(DeliveryUnauthenticated());
  }
}
