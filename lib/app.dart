import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:rickandmorty/core/resources/widgets/banners/custom_banner.dart';

import 'config/app/app_config.dart';
import 'config/theme/app_themes.dart';
import 'core/resources/navigation/widgets/base_navigatable_scaffold.dart';

class RickAndMortyApp extends StatelessWidget {
  RickAndMortyApp({super.key, required this.appConfig}) {
    beamerRouterDelegate = BeamerRouterDelegate(
      initialPath: '/characters',
      locationBuilder: SimpleLocationBuilder(routes: {
        '*': (_) => (appConfig.flavor == Flavor.staging)
            ? CustomBanner(
                message: "Staging".toUpperCase(),
                color: Colors.purple,
                textStyle: const TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                location: BannerLocation.bottomStart,
                child: BaseNavigatableScaffold(),
              )
            : BaseNavigatableScaffold()
      }),
    );
  }

  final AppConfig appConfig;
  late final BeamerRouterDelegate beamerRouterDelegate;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Rick & Morty",
      theme: theme(),
      routerDelegate: beamerRouterDelegate,
      routeInformationParser: BeamerRouteInformationParser(),
    );
  }
}
