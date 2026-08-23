import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injector.dart';
import 'core/router/route.dart';
import 'core/theme/app_themes.dart';
import 'features/auth/presentation/bloc/auth_cubit.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/locale/presentation/bloc/locale_cubit.dart';
import 'features/notifications/data/services/fcm_service.dart';
import 'features/notifications/presentation/bloc/notifications_cubit.dart';
import 'features/profile/presentation/cubit/profile_cubit.dart';
import 'features/theme/presentation/bloc/theme_cubit.dart';
import 'features/theme/presentation/bloc/theme_state.dart';

class AppEntry extends StatelessWidget {
  const AppEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      path: 'assets/translations',
      supportedLocales: const [Locale('en'), Locale('ar')],
      fallbackLocale: const Locale('en'),
      useFallbackTranslations: true,
      saveLocale: true,
      child: LocaleInitializer(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<AuthCubit>.value(value: getIt<AuthCubit>()),
            BlocProvider<ThemeCubit>.value(value: getIt<ThemeCubit>()),
            BlocProvider<LocaleCubit>.value(value: getIt<LocaleCubit>()),
            BlocProvider<NotificationsCubit>.value(
              value: getIt<NotificationsCubit>(),
            ),
            // Provided app-wide so /profile, /profile/edit and /profile/delete
            // share one instance across go_router navigations.
            BlocProvider<ProfileCubit>.value(value: getIt<ProfileCubit>()),
          ],
          child: BlocListener<AuthCubit, AuthState>(
            // Unregister the device from FCM on logout so the next user on
            // this handset does not receive the previous user's push.
            listenWhen: (previous, current) =>
                previous is LoginSuccessState && current is AuthInitState,
            listener: (context, state) => getIt<FcmService>().unregister(),
            child: BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, state) {
                return MaterialApp.router(
                  locale: context.watch<LocaleCubit>().state.locale,
                  supportedLocales: context.supportedLocales,
                  localizationsDelegates: context.localizationDelegates,
                  themeMode: state.themeMode,
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  debugShowCheckedModeBanner: false,
                  routerConfig: routes,
                  // "Citizen's Complaint System"
                  title: 'CCS',
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class LocaleInitializer extends StatefulWidget {
  const LocaleInitializer({super.key, required this.child});

  final Widget child;

  @override
  State<LocaleInitializer> createState() => _LocaleInitializerState();
}

class _LocaleInitializerState extends State<LocaleInitializer> {
  @override
  void initState() {
    super.initState();
    // Read the locale EasyLocalization restored and sync it into LocaleCubit.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final Locale? currentLocale = EasyLocalization.of(context)?.locale;
      if (currentLocale != null) {
        getIt<LocaleCubit>().setLocale(currentLocale);
      }
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
