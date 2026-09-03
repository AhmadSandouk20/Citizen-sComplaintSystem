// import 'dart:convert';

// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:final_flutter/core/config/app_config.dart';
// import 'package:final_flutter/core/di/injector.dart';
// import 'package:final_flutter/features/auth/presentation/bloc/auth_cubit.dart';
// import 'package:final_flutter/features/notifications/domain/repositories/notifications_repository.dart';
// import 'package:final_flutter/features/notifications/presentation/bloc/notifications_cubit.dart';
// import 'package:final_flutter/features/notifications/presentation/notification_navigation.dart';
// import 'package:final_flutter/firebase_options.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// const _channelId = 'gov_complaints_channel';
// const _tokenPrefsKey = 'fcm_token';
// const _deviceIdPrefsKey = 'device_id';

// /// Runs in a separate isolate with no access to the app's state, so Firebase
// /// must be initialised again here.
// ///
// /// It must be initialised **with explicit options**: a bare
// /// `Firebase.initializeApp()` reads `google-services.json`, which is not in the
// /// repo, so every background message was being dropped silently.
// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   try {
//     if (Firebase.apps.isEmpty) {
//       await Firebase.initializeApp(
//         options: DefaultFirebaseOptions.currentPlatform,
//       );
//     }
//   } catch (error) {
//     debugPrint('Background handler could not initialise Firebase: $error');
//   }
// }

// class FcmService {
//   FcmService(this._repository);

//   final NotificationsRepository _repository;
//   final FlutterLocalNotificationsPlugin _local =
//       FlutterLocalNotificationsPlugin();

//   /// True once Firebase started successfully on a platform we support.
//   /// Every other entry point checks this instead of throwing.
//   bool _ready = false;

//   bool get isAvailable => _ready;

//   Future<void> initialize() async {
//     if (!DefaultFirebaseOptions.isSupportedPlatform) {
//       // iOS/desktop have no Firebase app registered yet. Not an error — the
//       // app runs fine with in-app notifications only.
//       debugPrint('Push notifications are not configured for this platform.');
//       return;
//     }

//     try {
//       if (Firebase.apps.isEmpty) {
//         await Firebase.initializeApp(
//           options: DefaultFirebaseOptions.currentPlatform,
//         );
//       }
//       _ready = true;
//     } catch (error) {
//       debugPrint('Firebase is not configured yet: $error');
//       return;
//     }

//     if (!kIsWeb) {
//       FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
//       await _initLocalNotifications();
//     }

//     // Permission is NOT requested here: initialize() runs before the first
//     // frame, which would put the OS permission dialog on top of the login
//     // screen. It is requested from syncToken(), i.e. once there is a session.

//     FirebaseMessaging.instance.onTokenRefresh.listen(_registerToken);

//     FirebaseMessaging.onMessage.listen((message) async {
//       // On the web the local-notifications plugin is never initialised (see
//       // above), and the service worker already draws the banner — calling
//       // `_local.show` there would throw on an unconfigured plugin.
//       if (!kIsWeb) await _showForegroundNotification(message);
//       await getIt<NotificationsCubit>().refreshUnreadCount();
//     });

//     FirebaseMessaging.onMessageOpenedApp.listen(_openFromMessage);

//     final initial = await FirebaseMessaging.instance.getInitialMessage();
//     if (initial != null) {
//       _openFromMessage(initial);
//     }
//   }

//   Future<void> unregister() async {
//     if (!_ready) return;

//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString(_tokenPrefsKey);
//     if (token == null || token.isEmpty) return;

//     try {
//       await _repository.deleteFcmToken(token);
//       await FirebaseMessaging.instance.deleteToken();
//     } catch (error) {
//       debugPrint('Failed to remove FCM token: $error');
//     } finally {
//       // Always drop the local copy. If the server call failed the token is
//       // still stale on this device, and keeping it would make the next login
//       // skip re-registration and leave the user with no push at all.
//       await prefs.remove(_tokenPrefsKey);
//     }
//   }

//   Future<void> syncToken() => _syncToken();

//   Future<void> _initLocalNotifications() async {
//     const android = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const ios = DarwinInitializationSettings();
//     await _local.initialize(
//       const InitializationSettings(android: android, iOS: ios),
//       onDidReceiveNotificationResponse: (response) {
//         final payload = response.payload;
//         if (payload == null || payload.isEmpty) {
//           openFromNotification();
//           return;
//         }
//         try {
//           final data = jsonDecode(payload) as Map<String, dynamic>;
//           openFromNotification(complaintId: complaintIdFromData(data));
//         } catch (_) {
//           openFromNotification();
//         }
//       },
//     );

//     const channel = AndroidNotificationChannel(
//       _channelId,
//       'Complaint notifications',
//       description: 'Updates about government complaints',
//       importance: Importance.high,
//     );
//     await _local
//         .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin
//         >()
//         ?.createNotificationChannel(channel);
//   }

//   Future<void> _requestPermission() async {
//     await FirebaseMessaging.instance.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//           alert: true,
//           badge: true,
//           sound: true,
//         );
//     await _local
//         .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin
//         >()
//         ?.requestNotificationsPermission();
//   }

//   Future<void> _syncToken() async {
//     if (!_ready) return;
//     if (getIt<AuthCubit>().token == null) return;
//     try {
//       // Asked here rather than at startup, so the OS dialog appears once the
//       // user is signed in and the request has visible context.
//       await _requestPermission();

//       String? token;
//       if (kIsWeb) {
//         token = await FirebaseMessaging.instance.getToken(
//           vapidKey: AppConfig.vapidKey,
//         );
//       } else {
//         token = await FirebaseMessaging.instance.getToken();
//       }
//       if (token == null || token.isEmpty) return;
//       await _registerToken(token);
//     } catch (error) {
//       debugPrint('Failed to fetch FCM token: $error');
//     }
//   }

//   Future<void> _registerToken(String token) async {
//     if (getIt<AuthCubit>().token == null) return;
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_tokenPrefsKey, token);
//     final deviceId = await _deviceId(prefs);
//     try {
//       await _repository.saveFcmToken(
//         token: token,
//         deviceType: _deviceType,
//         deviceId: deviceId,
//       );
//     } catch (error) {
//       debugPrint('Failed to save FCM token on API: $error');
//     }
//   }

//   Future<String> _deviceId(SharedPreferences prefs) async {
//     final existing = prefs.getString(_deviceIdPrefsKey);
//     if (existing != null && existing.isNotEmpty) return existing;
//     final created = DateTime.now().microsecondsSinceEpoch.toString();
//     await prefs.setString(_deviceIdPrefsKey, created);
//     return created;
//   }

//   String get _deviceType {
//     if (kIsWeb) return 'web';
//     switch (defaultTargetPlatform) {
//       case TargetPlatform.iOS:
//         return 'ios';
//       default:
//         return 'android';
//     }
//   }

//   Future<void> _showForegroundNotification(RemoteMessage message) async {
//     final title = message.notification?.title ?? message.data['title'] ?? '';
//     final body = message.notification?.body ?? message.data['body'] ?? '';
//     if (title.toString().isEmpty && body.toString().isEmpty) return;

//     await _local.show(
//       _notificationId(message),
//       title.toString(),
//       body.toString(),
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           _channelId,
//           'Complaint notifications',
//           channelDescription: 'Updates about government complaints',
//           importance: Importance.high,
//           priority: Priority.high,
//         ),
//         iOS: DarwinNotificationDetails(),
//       ),
//       payload: jsonEncode(message.data),
//     );
//   }

//   /// Android requires a signed 32-bit notification id.
//   ///
//   /// `message.hashCode` is a Dart object hash that can exceed that range and
//   /// makes the platform call fail, so it is masked into 31 bits. Keyed on
//   /// `messageId` so a redelivered message replaces its banner instead of
//   /// stacking a duplicate.
//   int _notificationId(RemoteMessage message) {
//     final seed = message.messageId ?? message.data.toString();
//     return seed.hashCode & 0x7FFFFFFF;
//   }

//   void _openFromMessage(RemoteMessage message) {
//     openFromNotification(complaintId: complaintIdFromData(message.data));
//   }
// }
