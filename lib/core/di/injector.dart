import 'package:final_flutter/core/network/dio_client.dart';
import 'package:final_flutter/core/router/navigation_key.dart';
import 'package:final_flutter/core/router/route_paths.dart';
import 'package:final_flutter/features/locale/presentation/bloc/locale_cubit.dart';
import 'package:final_flutter/features/notifications/data/datasources/notifications_remote_datasource.dart';
import 'package:final_flutter/features/notifications/data/repositories/notifications_repository_impl.dart';
import 'package:final_flutter/features/notifications/data/services/fcm_service.dart';
import 'package:final_flutter/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:final_flutter/features/notifications/presentation/bloc/notifications_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/auth_cubit.dart';
import '../../features/theme/presentation/bloc/theme_cubit.dart';

final GetIt getIt = GetIt.instance;

void setupDependencies() {
  final authCubit = AuthCubit();
  getIt.registerSingleton(authCubit);

  getIt.registerLazySingleton<DioClient>(
    () => DioClient(
      tokenProvider: () => getIt<AuthCubit>().token,
      onUnauthorized: () {
        getIt<AuthCubit>().logout();
        navigatorKey.currentContext?.go(RoutePaths.login);
      },
    ),
  );

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

  getIt.registerSingleton(ThemeCubit());
  getIt.registerSingleton(LocaleCubit());
}
