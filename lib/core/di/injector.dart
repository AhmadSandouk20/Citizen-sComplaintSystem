import 'package:get_it/get_it.dart';

import '../../features/auth/data/auth_repository_implementation.dart';
import '../../features/auth/domain/auth_repository.dart';
import '../../features/auth/presentation/bloc/auth_cubit.dart';
import '../../features/locale/presentation/bloc/locale_cubit.dart';
import '../../features/notifications/data/datasources/notifications_remote_datasource.dart';
import '../../features/notifications/data/repositories/notifications_repository_impl.dart';
import '../../features/notifications/data/services/fcm_service.dart';
import '../../features/notifications/domain/repositories/notifications_repository.dart';
import '../../features/notifications/presentation/bloc/notifications_cubit.dart';
import '../../features/profile/data/datasources/profile_remote_data_source.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/presentation/cubit/profile_cubit.dart';
import '../../features/theme/presentation/bloc/theme_cubit.dart';
import '../network/dio_client.dart';
import '../services/file_service.dart';

final GetIt getIt = GetIt.instance;

/// Wires the object graph. Called once from `main()` before `runApp`.
///
/// Order matters in one place only: [DioClient] reads the token through a
/// callback, so [AuthCubit] must already be registered when the callback
/// first fires — not when it is created.
void setupDependencies() {
  // ----------------------------- Session ------------------------------------
  // Registered first because everything below reads the token from it.
  getIt.registerLazySingleton<AuthCubit>(
    () => AuthCubit(getIt<AuthRepository>()),
  );

  // ----------------------------- Network ------------------------------------
  getIt.registerLazySingleton<DioClient>(
    () => DioClient(
      tokenProvider: () => getIt<AuthCubit>().token,
      // A 401 means the token is already dead server-side, so drop the session
      // locally. The router's refreshListenable does the redirect.
      onUnauthorized: () => getIt<AuthCubit>().clearSession(),
    ),
  );

  // ------------------------------- Auth -------------------------------------
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImplementation(getIt<DioClient>()),
  );

  // --------------------------- Notifications --------------------------------
  getIt.registerLazySingleton(
    () => NotificationsRemoteDataSource(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<NotificationsRepository>(
    () => NotificationsRepositoryImpl(getIt<NotificationsRemoteDataSource>()),
  );
  getIt.registerLazySingleton(
    () => NotificationsCubit(getIt<NotificationsRepository>()),
  );
  getIt.registerLazySingleton(
    () => FcmService(getIt<NotificationsRepository>()),
  );

  // ------------------------------ Profile -----------------------------------
  getIt.registerLazySingleton(
    () => ProfileRemoteDataSource(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(getIt<ProfileRemoteDataSource>()),
  );
  // Singleton, not a factory: the profile, edit and delete screens are three
  // separate routes and must share one state.
  getIt.registerLazySingleton(
    () => ProfileCubit(getIt<ProfileRepository>(), getIt<AuthCubit>()),
  );

  // ---------------------------- Attachments ---------------------------------
  getIt.registerLazySingleton(() => FileService());

  // ------------------------------- Shell ------------------------------------
  getIt.registerLazySingleton(() => ThemeCubit());
  getIt.registerLazySingleton(() => LocaleCubit());
}
