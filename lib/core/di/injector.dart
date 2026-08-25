import 'package:final_flutter/core/network/dio_client.dart';
import 'package:final_flutter/core/router/navigation_key.dart';
import 'package:final_flutter/core/router/route_paths.dart';
import 'package:final_flutter/features/admin_analytics/data/datasources/statistics_remote_datasource.dart';
import 'package:final_flutter/features/admin_analytics/data/repositories/statistics_repository_impl.dart';
import 'package:final_flutter/features/admin_analytics/domain/repositories/statistics_repository.dart';
import 'package:final_flutter/features/admin_analytics/presentation/bloc/statistics_cubit.dart';
import 'package:final_flutter/features/admin_reports/data/datasources/reports_remote_datasource.dart';
import 'package:final_flutter/features/admin_reports/data/repositories/reports_repository_impl.dart';
import 'package:final_flutter/features/admin_reports/domain/repositories/reports_repository.dart';
import 'package:final_flutter/features/admin_reports/presentation/bloc/reports_cubit.dart';
import 'package:final_flutter/features/admin_users/data/datasources/admin_users_remote_datasource.dart';
import 'package:final_flutter/features/admin_users/data/repositories/admin_users_repository_impl.dart';
import 'package:final_flutter/features/admin_users/domain/repositories/admin_users_repository.dart';
import 'package:final_flutter/features/admin_users/presentation/bloc/admin_users_cubit.dart';
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

  getIt.registerLazySingleton(
    () => AdminUsersRemoteDataSource(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<AdminUsersRepository>(
    () => AdminUsersRepositoryImpl(getIt<AdminUsersRemoteDataSource>()),
  );
  getIt.registerLazySingleton(
    () => AdminUsersCubit(getIt<AdminUsersRepository>()),
  );

  getIt.registerLazySingleton(
    () => StatisticsRemoteDataSource(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<StatisticsRepository>(
    () => StatisticsRepositoryImpl(getIt<StatisticsRemoteDataSource>()),
  );
  getIt.registerLazySingleton(
    () => StatisticsCubit(getIt<StatisticsRepository>()),
  );

  getIt.registerLazySingleton(
    () => ReportsRemoteDataSource(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<ReportsRepository>(
    () => ReportsRepositoryImpl(getIt<ReportsRemoteDataSource>()),
  );
  getIt.registerLazySingleton(
    () => ReportsCubit(getIt<ReportsRepository>()),
  );

  getIt.registerSingleton(ThemeCubit());
  getIt.registerSingleton(LocaleCubit());
}
