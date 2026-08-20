import 'package:final_flutter/features/locale/presentation/bloc/locale_cubit.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/presentation/bloc/auth_cubit.dart';
import '../../features/theme/presentation/bloc/theme_cubit.dart';

final GetIt getIt = GetIt.instance;

void setupDependencies() {
  final authCubit = AuthCubit();

  getIt.registerSingleton(authCubit);

  final themeCubit = ThemeCubit();

  getIt.registerSingleton(themeCubit);

  final localeCubit = LocaleCubit();

  getIt.registerSingleton(localeCubit);
}
