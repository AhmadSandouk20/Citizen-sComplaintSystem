import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:final_flutter/core/config/app_config.dart';
import 'package:final_flutter/core/di/injector.dart';
import 'package:final_flutter/core/router/route_paths.dart';
import 'package:final_flutter/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:final_flutter/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:final_flutter/features/notifications/presentation/bloc/notifications_cubit.dart';
import 'package:final_flutter/features/notifications/presentation/notification_navigation.dart';
import 'package:final_flutter/firebase_options.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _channelId = 'gov_complaints_channel';
const _tokenPrefsKey = 'fcm_token';
const _deviceIdPrefsKey = 'device_id';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp();
  } catch (_) {}
}

class FcmService {
  FcmService(this._repository);

  final NotificationsRepository _repository;
  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
    } catch (error) {
      debugPrint('Firebase is not configured yet: $error');
      return;
    }

    if (!kIsWeb) {
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      await _initLocalNotifications();
    }
    await _requestPermission();

    FirebaseMessaging.instance.onTokenRefresh.listen(_registerToken);

    FirebaseMessaging.onMessage.listen((message) async {
      await _showForegroundNotification(message);
      await getIt<NotificationsCubit>().refreshUnreadCount();
    });

    FirebaseMessaging.onMessageOpenedApp.listen(_openFromMessage);

    final initial = await FirebaseMessaging.instance.getInitialMessage();
    if (initial != null) {
      _openFromMessage(initial);
    }
  }

  Future<void> unregister() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenPrefsKey);
    if (token == null || token.isEmpty) return;
    try {
      await _repository.deleteFcmToken(token);
      await FirebaseMessaging.instance.deleteToken();
      await prefs.remove(_tokenPrefsKey);
    } catch (error) {
      debugPrint('Failed to remove FCM token: $error');
    }
  }

  Future<void> syncToken() => _syncToken();

  Future<void> _initLocalNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    await _local.initialize(
      const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload == null || payload.isEmpty) {
          openFromNotification();
          return;
        }
        try {
          final data = jsonDecode(payload) as Map<String, dynamic>;
          openFromNotification(complaintId: complaintIdFromData(data));
        } catch (_) {
          openFromNotification();
        }
      },
    );

    const channel = AndroidNotificationChannel(
      _channelId,
      'Complaint notifications',
      description: 'Updates about government complaints',
      importance: Importance.high,
    );
    await _local
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  Future<void> _requestPermission() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
    await _local
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  Future<void> _syncToken() async {
    if (getIt<AuthCubit>().token == null) return;
    try {
      String? token;
      if (kIsWeb) {
        token = await FirebaseMessaging.instance.getToken(
          vapidKey: AppConfig.vapidKey,
        );
      } else {
        token = await FirebaseMessaging.instance.getToken();
      }
      if (token == null || token.isEmpty) return;
      await _registerToken(token);
    } catch (error) {
      debugPrint('Failed to fetch FCM token: $error');
    }
  }

  Future<void> _registerToken(String token) async {
    if (getIt<AuthCubit>().token == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenPrefsKey, token);
    final deviceId = await _deviceId(prefs);
    try {
      await _repository.saveFcmToken(
        token: token,
        deviceType: _deviceType,
        deviceId: deviceId,
      );
    } catch (error) {
      debugPrint('Failed to save FCM token on API: $error');
    }
  }

  Future<String> _deviceId(SharedPreferences prefs) async {
    final existing = prefs.getString(_deviceIdPrefsKey);
    if (existing != null && existing.isNotEmpty) return existing;
    final created = DateTime.now().microsecondsSinceEpoch.toString();
    await prefs.setString(_deviceIdPrefsKey, created);
    return created;
  }

  String get _deviceType {
    if (kIsWeb) return 'web';
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return 'ios';
      default:
        return 'android';
    }
  }

  Future<void> _showForegroundNotification(RemoteMessage message) async {
    final title = message.notification?.title ?? message.data['title'] ?? '';
    final body = message.notification?.body ?? message.data['body'] ?? '';
    if (title.toString().isEmpty && body.toString().isEmpty) return;

    await _local.show(
      message.hashCode,
      title.toString(),
      body.toString(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          'Complaint notifications',
          channelDescription: 'Updates about government complaints',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: jsonEncode(message.data),
    );
  }

  void _openFromMessage(RemoteMessage message) {
    openFromNotification(complaintId: complaintIdFromData(message.data));
  }

  void _openNotificationsScreen() {
    openFromNotification();
  }
}
