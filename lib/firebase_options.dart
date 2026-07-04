// Firebase configuration for the Notes app.
//
// `android` is wired from the project's `google-services.json`
// (project `quizlett-b56f2`, package `com.example.cruder`).
// Other platforms still hold placeholders because this build only targets
// Android. Replace them with values from the Firebase console if you later
// add iOS / web / desktop targets.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

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
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        return linux;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'REPLACE_WITH_YOUR_WEB_API_KEY',
    appId: 'REPLACE_WITH_YOUR_WEB_APP_ID',
    messagingSenderId: '992339745121',
    projectId: 'quizlett-b56f2',
    authDomain: 'quizlett-b56f2.firebaseapp.com',
    storageBucket: 'quizlett-b56f2.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCvzSOVL8bOvb_mYpb67DnZ-LRT7f6CyoI',
    appId: '1:992339745121:android:f1f62cbf2480e0c0de8d20',
    messagingSenderId: '992339745121',
    projectId: 'quizlett-b56f2',
    storageBucket: 'quizlett-b56f2.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'REPLACE_WITH_YOUR_IOS_API_KEY',
    appId: 'REPLACE_WITH_YOUR_IOS_APP_ID',
    messagingSenderId: '992339745121',
    projectId: 'quizlett-b56f2',
    iosBundleId: 'com.example.cruder',
    storageBucket: 'quizlett-b56f2.appspot.com',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'REPLACE_WITH_YOUR_MACOS_API_KEY',
    appId: 'REPLACE_WITH_YOUR_MACOS_APP_ID',
    messagingSenderId: '992339745121',
    projectId: 'quizlett-b56f2',
    iosBundleId: 'com.example.cruder',
    storageBucket: 'quizlett-b56f2.appspot.com',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'REPLACE_WITH_YOUR_WINDOWS_API_KEY',
    appId: 'REPLACE_WITH_YOUR_WINDOWS_APP_ID',
    messagingSenderId: '992339745121',
    projectId: 'quizlett-b56f2',
    storageBucket: 'quizlett-b56f2.appspot.com',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'REPLACE_WITH_YOUR_LINUX_API_KEY',
    appId: 'REPLACE_WITH_YOUR_LINUX_APP_ID',
    messagingSenderId: '992339745121',
    projectId: 'quizlett-b56f2',
    storageBucket: 'quizlett-b56f2.appspot.com',
  );
}
