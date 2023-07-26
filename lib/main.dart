import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:rickandmorty/config/theme/app_themes.dart';
import 'package:rickandmorty/core/resources/navigation/widgets/base_navigatable_scaffold.dart';
import 'package:url_strategy/url_strategy.dart';
import 'injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  setPathUrlStrategy();
  runApp(RickAndMortyApp());
}

class RickAndMortyApp extends StatelessWidget {
  RickAndMortyApp({Key? key}) : super(key: key);

  final beamerRouterDelegate = BeamerRouterDelegate(
      initialPath: '/characters',
      locationBuilder: SimpleLocationBuilder(routes: {
        '*': (_) => BaseNavigatableScaffold(),
      }));

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: theme(),
      routerDelegate: beamerRouterDelegate,
      routeInformationParser: BeamerRouteInformationParser(),
    );
  }
}
