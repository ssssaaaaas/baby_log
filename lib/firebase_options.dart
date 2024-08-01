// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyDlmMeFZaWkX2UH48dgku8YpAV6HTJG1eg',
    appId: '1:521816597990:web:dbbce415975750acfa2227',
    messagingSenderId: '521816597990',
    projectId: 'babylog-67ad6',
    authDomain: 'babylog-67ad6.firebaseapp.com',
    storageBucket: 'babylog-67ad6.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD3_D9o30imM5L_xXmC4u2e7QwLn_JoiCs',
    appId: '1:521816597990:android:ea7c7cacbcbc48d6fa2227',
    messagingSenderId: '521816597990',
    projectId: 'babylog-67ad6',
    storageBucket: 'babylog-67ad6.appspot.com',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDlmMeFZaWkX2UH48dgku8YpAV6HTJG1eg',
    appId: '1:521816597990:web:dff7618a8a85bf51fa2227',
    messagingSenderId: '521816597990',
    projectId: 'babylog-67ad6',
    authDomain: 'babylog-67ad6.firebaseapp.com',
    storageBucket: 'babylog-67ad6.appspot.com',
  );

}