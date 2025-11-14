import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/app_config.dart';
import '../network/dio_client.dart';
import '../network/api_interceptor.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/domain/usecases/send_otp_usecase.dart';
import '../../features/auth/domain/usecases/verify_otp_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/cart/presentation/bloc/cart_bloc.dart';
import '../../features/location/presentation/bloc/location_bloc.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // Dio
  final dio = Dio(BaseOptions(
    baseUrl: AppConfig.baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));

  dio.interceptors.add(ApiInterceptor(sharedPreferences));
  dio.interceptors.add(LogInterceptor(
    requestBody: true,
    responseBody: true,
    error: true,
  ));

  getIt.registerSingleton<Dio>(dio);
  getIt.registerSingleton<DioClient>(DioClient(dio));

  // Auth Feature
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt<DioClient>()),
  );

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      sharedPreferences: getIt<SharedPreferences>(),
    ),
  );

  getIt.registerLazySingleton(() => LoginUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => RegisterUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => SendOtpUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => VerifyOtpUseCase(getIt<AuthRepository>()));

  getIt.registerFactory(() => AuthBloc(
        loginUseCase: getIt<LoginUseCase>(),
        registerUseCase: getIt<RegisterUseCase>(),
        sendOtpUseCase: getIt<SendOtpUseCase>(),
        verifyOtpUseCase: getIt<VerifyOtpUseCase>(),
      ));

  // Cart Bloc
  getIt.registerFactory(() => CartBloc());

  // Location Bloc
  getIt.registerFactory(() => LocationBloc());
}
