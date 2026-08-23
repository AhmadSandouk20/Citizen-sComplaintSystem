import 'package:easy_localization/easy_localization.dart';
import 'package:final_flutter/app_entry.dart';
import 'package:final_flutter/core/di/injector.dart';
import 'package:final_flutter/features/notifications/data/services/fcm_service.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();

  setupDependencies();
  await getIt<FcmService>().initialize();

  runApp(AppEntry());
}
