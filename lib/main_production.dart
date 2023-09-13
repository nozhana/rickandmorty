// ignore_for_file: depend_on_referenced_packages

import 'package:beamer/beamer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rickandmorty/app.dart';
import 'package:rickandmorty/config/app/app_config.dart';
import 'package:rickandmorty/firebase_options.dart';
import 'injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await _buildHydratedStorage();
  HydratedBlocOverrides.runZoned(
    _runApp,
    storage: storage,
  );
}

void _runApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeFirebase();
  await initializeDependencies();
  Beamer.setPathUrlStrategy();

  runApp(RickAndMortyApp(
      appConfig: const AppConfig(
    appName: "Rick And Morty",
    flavor: Flavor.production,
  )));
}

Future<HydratedStorage> _buildHydratedStorage() async {
  return await HydratedStorage.build(
      storageDirectory: kIsWeb
          ? HydratedStorage.webStorageDirectory
          : await getTemporaryDirectory());
}

Future<void> _initializeFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (kDebugMode) {
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
    await FirebaseStorage.instance.useStorageEmulator('localhost', 9199);
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  }
}
