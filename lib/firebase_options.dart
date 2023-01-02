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
    apiKey: 'AIzaSyAqEPHEt_nARQZChiUw9zzb8DFbRln0Wog',
    appId: '1:416498051212:web:db6d5e820aa21d328c33a9',
    messagingSenderId: '416498051212',
    projectId: 'anonim-io-server',
    authDomain: 'anonim-io-server.firebaseapp.com',
    databaseURL: 'https://anonim-io-server-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'anonim-io-server.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCzPpgr1rtCZYeVYeN_5fEW-nPixEzIzWs',
    appId: '1:416498051212:android:4fe4e0a63d8950bc8c33a9',
    messagingSenderId: '416498051212',
    projectId: 'anonim-io-server',
    databaseURL: 'https://anonim-io-server-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'anonim-io-server.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCxj5jb08njS0KJ9fBtWLcGKqjNAkbOqz0',
    appId: '1:416498051212:ios:2e8b96d39a2d4ff88c33a9',
    messagingSenderId: '416498051212',
    projectId: 'anonim-io-server',
    databaseURL: 'https://anonim-io-server-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'anonim-io-server.appspot.com',
    iosClientId: '416498051212-7t0ade6hn6sb0nfk7mmkra14vfdva1mm.apps.googleusercontent.com',
    iosBundleId: 'com.example.anonimIo',
  );
}