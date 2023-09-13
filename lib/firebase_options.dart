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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for android - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBv2ONQy-m-qKYYbGXYexpl3NZS7xmYv2s',
    appId: '1:147609116024:web:da591e3cdfa7d35fd67c8d',
    messagingSenderId: '147609116024',
    projectId: 'rick-and-morty-3b3ef',
    authDomain: 'rick-and-morty-3b3ef.firebaseapp.com',
    storageBucket: 'rick-and-morty-3b3ef.appspot.com',
    measurementId: 'G-BG2CR4VGL9',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC2JArTFxUB9FiJQjXxbLcM4DTchar32vU',
    appId: '1:147609116024:ios:83f8df73c95ca100d67c8d',
    messagingSenderId: '147609116024',
    projectId: 'rick-and-morty-3b3ef',
    storageBucket: 'rick-and-morty-3b3ef.appspot.com',
    iosClientId: '147609116024-bgbhpsm0vctir1akrqgcpf4rn7lr8jsl.apps.googleusercontent.com',
    iosBundleId: 'com.nozhana.rickandmorty',
  );
}