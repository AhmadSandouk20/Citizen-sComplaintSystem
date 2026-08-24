import 'package:dio/dio.dart';
import 'package:final_flutter/core/api/api_service.dart';
import 'package:final_flutter/features/admin/data/staff_management_repository_implementation.dart';
import 'package:final_flutter/features/admin/data/user_management_repository_implementation.dart';
import 'package:final_flutter/features/admin/domain/agency_repository.dart';
import 'package:final_flutter/features/admin/domain/staff_management_repository.dart';
import 'package:final_flutter/features/admin/domain/user_management_repository.dart';
import 'package:final_flutter/features/admin/presentation/bloc/user/user_management_cubit.dart';
import 'package:final_flutter/features/locale/presentation/bloc/locale_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../features/admin/data/agency_complaints_repository_implementation.dart';
import '../../features/admin/data/agency_repository_implementation.dart';
import '../../features/admin/domain/agency_complaints_repository.dart';
import '../../features/admin/presentation/bloc/agency/agency_complaints_cubit/admin_agency_complaints_cubit.dart';
import '../../features/admin/presentation/bloc/agency/agency_cubit/admin_agency_cubit.dart';
import '../../features/admin/presentation/bloc/staff/staff_management_cubit.dart';
import '../../features/auth/presentation/bloc/auth_cubit.dart';
import '../../features/theme/presentation/bloc/theme_cubit.dart';
import '../network/dio_client.dart';
import '../router/router.dart';

final GetIt getIt = GetIt.instance;

void setupDependencies() {
  final authCubit = AuthCubit();

  getIt.registerSingleton(authCubit);

  getIt.registerLazySingleton<DioClient>(
    () => DioClient(
      tokenProvider: () => "1|wwo8MaV8flBvveYBigonedKHZlxu3GEhagdfFTtm8315f231",
      onUnauthorized: () {
        getIt<AuthCubit>().logout();
        navigatorKey.currentContext?.go(RoutePaths.login);
      },
    ),
  );

  final themeCubit = ThemeCubit();

  getIt.registerSingleton(themeCubit);

  final localeCubit = LocaleCubit();

  getIt.registerSingleton(localeCubit);
  getIt.registerLazySingleton<Dio>(() => getIt<DioClient>().client);
  // Repositories
  getIt.registerLazySingleton<APIService>(() => APIService(getIt<Dio>()));
  getIt.registerLazySingleton<AgencyRepository>(
    () => AgencyRepositoryImplementation(getIt<APIService>()),
  );
  getIt.registerLazySingleton<StaffManagementRepository>(
    () => StaffManagementRepoImplementation(getIt<APIService>()),
  );
  getIt.registerLazySingleton<AgencyComplaintsRepository>(
    () => AgencyComplaintsRepositoryImplementation(getIt<APIService>()),
  );
  getIt.registerLazySingleton<UserManagementRepository>(
    () => UserManagementRepositoryImplementation(getIt<APIService>()),
  );

  // Cubits
  getIt.registerFactory<AdminAgenciesCubit>(
    () => AdminAgenciesCubit(getIt<AgencyRepository>()),
  );
  getIt.registerFactory<StaffManagementCubit>(
    () => StaffManagementCubit(
      getIt<StaffManagementRepository>(),
      getIt<AgencyRepository>(),
    ),
  );
  getIt.registerFactory<AdminAgenciesComplaintCubit>(
    () => AdminAgenciesComplaintCubit(getIt<AgencyComplaintsRepository>()),
  );
  getIt.registerFactory<UserManagementCubit>(
    () => UserManagementCubit(getIt<UserManagementRepository>()),
  );
}
