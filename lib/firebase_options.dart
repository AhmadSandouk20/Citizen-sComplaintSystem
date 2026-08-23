import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Firebase client configuration.
///
/// These values are public client identifiers, not secrets — a Firebase web
/// or Android API key is designed to ship inside the client, and access is
/// controlled by Firebase security rules and the app's SHA fingerprint. They
/// are safe in the repo; the file is kept hand-written (rather than generated
/// by `flutterfire configure`) so it can be reviewed.
///
/// NOTE: Android also needs `android/app/google-services.json`, which is NOT
/// in the repo. Without it `android/app/build.gradle.kts` skips the Google
/// Services plugin and push delivery silently does nothing on Android.
class DefaultFirebaseOptions {
  DefaultFirebaseOptions._();

  /// Whether a Firebase app is configured for the platform we are running on.
  ///
  /// Callers check this instead of catching [UnsupportedError] — the previous
  /// version made an unconfigured platform look like a crash in the logs.
  static bool get isSupportedPlatform =>
      kIsWeb || defaultTargetPlatform == TargetPlatform.android;

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'Firebase is configured for Android and Web only. '
          'Run `flutterfire configure` and add the iOS app before enabling '
          'push on iOS.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCyZRUUridlpANUKorr7o5WdqLYhialJg0',
    appId: '1:283212099098:android:5def938bab8e4b2f7baba3',
    messagingSenderId: '283212099098',
    projectId: 'gov-complaints-project-8f5b7',
    storageBucket: 'gov-complaints-project-8f5b7.firebasestorage.app',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB67uKgbbMKyRhoj-Lk-A4gHoPaY-lpqpg',
    appId: '1:283212099098:web:0272fa9592563f6f7baba3',
    messagingSenderId: '283212099098',
    projectId: 'gov-complaints-project-8f5b7',
    authDomain: 'gov-complaints-project-8f5b7.firebaseapp.com',
    storageBucket: 'gov-complaints-project-8f5b7.firebasestorage.app',
  );
}
