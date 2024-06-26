// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAR4iULUyKB7Ks10oqjnlPyU4hJYoMCtGw',
    appId: '1:987239160672:web:140897ff64fca23f0fdc05',
    messagingSenderId: '987239160672',
    projectId: 'instagram-flutter-ac132',
    authDomain: 'instagram-flutter-ac132.firebaseapp.com',
    storageBucket: 'instagram-flutter-ac132.appspot.com',
    measurementId: 'G-DQP41F8V1H',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBTvmOueMfc6YOyXhae-gxp_h276l_63cE',
    appId: '1:987239160672:android:434abff517b450310fdc05',
    messagingSenderId: '987239160672',
    projectId: 'instagram-flutter-ac132',
    storageBucket: 'instagram-flutter-ac132.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDnc0fX4QzxdJSf-x_4YoMzYzgZp7iNzOY',
    appId: '1:987239160672:ios:f57e6165608a12f90fdc05',
    messagingSenderId: '987239160672',
    projectId: 'instagram-flutter-ac132',
    storageBucket: 'instagram-flutter-ac132.appspot.com',
    iosBundleId: 'com.example.instagramzFlutter',
  );
}
