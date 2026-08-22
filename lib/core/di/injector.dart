import 'package:final_flutter/features/locale/presentation/bloc/locale_cubit.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/presentation/bloc/auth_cubit.dart';
import '../../features/theme/presentation/bloc/theme_cubit.dart';

//profile
import 'package:dio/dio.dart';

import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/ data/data_sources/profile_remote_data_source.dart';
import '../../features/profile/ data/repositories/profile_repository_impl.dart';
import '../../features/profile/ presentation/cubit/profile_cubit.dart';

final GetIt getIt = GetIt.instance;

void setupDependencies() {
  final authCubit = AuthCubit();

  getIt.registerSingleton(authCubit);

  final themeCubit = ThemeCubit();

  getIt.registerSingleton(themeCubit);

  final localeCubit = LocaleCubit();

  getIt.registerSingleton(localeCubit);

  //profile
  getIt.registerLazySingleton<Dio>(
        () => Dio(),
  );

  getIt.registerLazySingleton<ProfileRemoteDataSource>(
        () => ProfileRemoteDataSource(
      getIt<Dio>(),
    ),
  );

  getIt.registerLazySingleton<ProfileRepository>(
        () => ProfileRepositoryImpl(
      getIt<ProfileRemoteDataSource>(),
    ),
  );

  getIt.registerFactory<ProfileCubit>(
        () => ProfileCubit(
      getIt<ProfileRepository>(),
    ),
  );

}
