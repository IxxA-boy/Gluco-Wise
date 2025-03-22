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
        return macos;
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
    apiKey: 'AIzaSyBd6kgVBES_w3PjxG6lSYR2NMQvjmnDFxQ',
    appId: '1:764014681095:web:47ebb9d336274ffd6d1ea2',
    messagingSenderId: '764014681095',
    projectId: 'assessment-c6420',
    authDomain: 'assessment-c6420.firebaseapp.com',
    storageBucket: 'assessment-c6420.firebasestorage.app',
    measurementId: 'G-KR8HGE76CW',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCFQzIg417RJcXEfY7aEDVFyZdYuEYPk-0',
    appId: '1:764014681095:android:7761c61ce52287956d1ea2',
    messagingSenderId: '764014681095',
    projectId: 'assessment-c6420',
    storageBucket: 'assessment-c6420.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDNMInBiWnLlwwcxHH-jT2usUH_XpB1kVs',
    appId: '1:764014681095:ios:4622b170010fa4ed6d1ea2',
    messagingSenderId: '764014681095',
    projectId: 'assessment-c6420',
    storageBucket: 'assessment-c6420.firebasestorage.app',
    iosBundleId: 'com.example.assesment',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDNMInBiWnLlwwcxHH-jT2usUH_XpB1kVs',
    appId: '1:764014681095:ios:4622b170010fa4ed6d1ea2',
    messagingSenderId: '764014681095',
    projectId: 'assessment-c6420',
    storageBucket: 'assessment-c6420.firebasestorage.app',
    iosBundleId: 'com.example.assesment',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBd6kgVBES_w3PjxG6lSYR2NMQvjmnDFxQ',
    appId: '1:764014681095:web:47ebb9d336274ffd6d1ea2',
    messagingSenderId: '764014681095',
    projectId: 'assessment-c6420',
    authDomain: 'assessment-c6420.firebaseapp.com',
    storageBucket: 'assessment-c6420.firebasestorage.app',
    measurementId: 'G-KR8HGE76CW',
  );

}