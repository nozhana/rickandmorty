import 'package:flutter/material.dart';
import 'package:rickandmorty/app.dart';
import 'package:rickandmorty/config/app/app_config.dart';
import 'package:url_strategy/url_strategy.dart';
import 'injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  setPathUrlStrategy();
  runApp(RickAndMortyApp(
    appConfig: const AppConfig(
      appName: "Rick And Morty",
      flavor: Flavor.production,
    ),
  ));
}
