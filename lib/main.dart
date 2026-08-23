import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'app_entry.dart';
import 'core/di/injector.dart';
import 'features/auth/presentation/bloc/auth_cubit.dart';
import 'features/notifications/data/services/fcm_service.dart';
import 'features/notifications/presentation/bloc/notifications_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  setupDependencies();

  // Restore a saved session before the first frame so the router makes its
  // redirect decision once, instead of flashing the login screen and bouncing.
  await getIt<AuthCubit>().restoreSession();

  await getIt<FcmService>().initialize();

  if (getIt<AuthCubit>().isAuthenticated) {
    // Register this device and fill the badge for a restored session — this
    // used to happen only on an explicit login, so a cold start showed 0.
    await getIt<FcmService>().syncToken();
    await getIt<NotificationsCubit>().refreshUnreadCount();
  }

  runApp(const AppEntry());
}
