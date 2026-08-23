import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError('Firebase is configured for Android and Web.');
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
