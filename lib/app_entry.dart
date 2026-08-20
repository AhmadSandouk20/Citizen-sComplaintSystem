import 'package:easy_localization/easy_localization.dart';
import 'package:final_flutter/core/di/injector.dart';

import 'package:final_flutter/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:final_flutter/features/locale/presentation/bloc/locale_cubit.dart';
import 'package:final_flutter/features/theme/presentation/bloc/theme_cubit.dart';
import 'package:final_flutter/features/theme/presentation/bloc/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/router/route.dart';
import 'core/theme/app_themes.dart';

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
          ],
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
                //  "Citizen's Complaint System"
                title: "CCS",
              );
            },
          ),
        ),
      ),
    );
  }
}

class LocaleInitializer extends StatefulWidget {
  final Widget child;
  const LocaleInitializer({super.key, required this.child});

  @override
  State<LocaleInitializer> createState() => _LocaleInitializerState();
}

class _LocaleInitializerState extends State<LocaleInitializer> {
  @override
  void initState() {
    super.initState();
    // Read the current locale and sync it with LocaleCubit
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
