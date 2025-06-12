import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:prueba/domain/usecases/auth/login_user.dart'; // <-- 1. AÑADE ESTE IMPORT

// Data Sources
import '../../data/datasources/remote/auth_remote_data_source.dart';
import '../../data/datasources/remote/user_remote_data_source.dart';
import '../../data/datasources/local/auth_local_data_source.dart';
import '../../data/datasources/local/user_local_data_source.dart';

// Repositories
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/user_repository.dart';

// Use Cases
import '../../domain/usecases/auth/check_auth_status.dart';
import '../../domain/usecases/auth/login_with_biometric.dart';
import '../../domain/usecases/auth/login_with_oauth.dart';
import '../../domain/usecases/auth/logout.dart';
import '../../domain/usecases/auth/verify_invitation.dart';
import '../../domain/usecases/auth/register_user.dart';
import '../../domain/usecases/user/get_user_profile.dart';
import '../../domain/usecases/user/update_user_profile.dart';
import '../../domain/usecases/user/get_user_balance.dart';
import '../../domain/usecases/user/get_affiliate_network.dart';

// BLoCs
import '../../presentation/bloc/auth/auth_bloc.dart';
import '../../presentation/bloc/app/app_bloc.dart';
import '../../presentation/bloc/user/user_bloc.dart';
import '../../presentation/bloc/invitation/invitation_bloc.dart';
import '../../presentation/bloc/registration/registration_bloc.dart';

// Core
import '../network/network_info.dart';
import '../storage/secure_storage.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ===========================================
  // Features - BLoCs
  // ===========================================

  sl.registerFactory(() => AppBloc());

  sl.registerFactory(
    () => AuthBloc(
      checkAuthStatus: sl(),
      loginWithBiometric: sl(),
      loginWithOAuth: sl(),
      logout: sl(),
      loginUser: sl(), // <-- 3. AÑADE LA NUEVA DEPENDENCIA AQUÍ
    ),
  );

  sl.registerFactory(
    () => UserBloc(
      getUserProfile: sl(),
      updateUserProfile: sl(),
      getUserBalance: sl(),
      getAffiliateNetwork: sl(),
    ),
  );

  sl.registerFactory(() => InvitationBloc(verifyInvitation: sl()));

  sl.registerFactory(() => RegistrationBloc(
        registerUser: sl(),
        loginWithOAuth: sl(),
      ));

  // ===========================================
  // Use Cases
  // ===========================================

  // Auth Use Cases
  sl.registerLazySingleton(() => CheckAuthStatus(sl()));
  sl.registerLazySingleton(() => LoginWithBiometric(sl()));
  sl.registerLazySingleton(() => LoginWithOAuth(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => VerifyInvitation(sl()));
  sl.registerLazySingleton(() => RegisterUser(sl()));
  sl.registerLazySingleton(() => LoginUser(sl())); // <-- 2. AÑADE ESTA LÍNEA
  sl.registerLazySingleton(() => VerifyPhoneAndRegister(sl())); // Asumiendo que esta corrección también la aplicaste

  // User Use Cases
  sl.registerLazySingleton(() => GetUserProfile(sl()));
  sl.registerLazySingleton(() => UpdateUserProfile(sl()));
  sl.registerLazySingleton(() => GetUserBalance(sl()));
  sl.registerLazySingleton(() => GetAffiliateNetwork(sl()));

  // ===========================================
  // Repository
  // ===========================================

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // ===========================================
  // Data Sources
  // ===========================================

  // Remote Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      supabaseClient: sl(),
    ),
  );

  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(supabaseClient: sl()),
  );

  // Local Data Sources
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(secureStorage: sl(), sharedPreferences: sl()),
  );

  sl.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // ===========================================
  // Core
  // ===========================================

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  sl.registerLazySingleton<SecureStorage>(() => SecureStorageImpl(sl()));

  // ===========================================
  // External
  // ===========================================

  sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);
  sl.registerLazySingleton<LocalAuthentication>(() => LocalAuthentication());
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<DeviceInfoPlugin>(() => DeviceInfoPlugin());
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock_this_device,
      ),
    ),
  );

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
}