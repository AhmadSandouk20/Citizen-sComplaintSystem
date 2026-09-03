import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app_entry.dart';
import 'core/di/injector.dart';
import 'features/auth/presentation/bloc/auth_cubit.dart';
import 'features/notifications/data/services/fcm_service.dart';
import 'features/notifications/presentation/bloc/notifications_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // easy_localization logs every build, delegate init and asset load. That
  // noise buries the request logs we actually read while debugging, so keep
  // only warnings and errors.
  EasyLocalization.logger.enableBuildModes = [];

  // Loads the symbols DateFormat needs for non-English locales. Without this
  // any Arabic date format throws at runtime rather than at build time.
  await initializeDateFormatting();

  setupDependencies();

  // Restore a saved session before the first frame so the router makes its
  // redirect decision once, instead of flashing the login screen and bouncing.
  await getIt<AuthCubit>().restoreSession();

  // await getIt<FcmService>().initialize();

  if (getIt<AuthCubit>().isAuthenticated) {
    // Register this device and fill the badge for a restored session — this
    // used to happen only on an explicit login, so a cold start showed 0.
    // await getIt<FcmService>().syncToken();
    await getIt<NotificationsCubit>().refreshUnreadCount();
  }

  runApp(const AppEntry());
}
