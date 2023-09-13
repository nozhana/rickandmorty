import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:rickandmorty/core/resources/navigation/beam_locations/beam_locations.dart';
import 'package:rickandmorty/core/resources/navigation/beam_locations/profile_beam_location.dart';
import 'package:rickandmorty/core/resources/navigation/widgets/base_navigation_bar.dart';
import 'package:rickandmorty/core/resources/navigation/widgets/base_navigation_rail.dart';

class BaseNavigatableScaffold extends StatefulWidget {
  BaseNavigatableScaffold({super.key});

  final beamerKey = GlobalKey<BeamerState>();
  static const int breakingPoint = 640;
  static const int desktopBreakingPoint = 980;

  @override
  State<BaseNavigatableScaffold> createState() =>
      _BaseNavigatableScaffoldState();
}

class _BaseNavigatableScaffoldState extends State<BaseNavigatableScaffold> {
  late BeamerRouterDelegate _beamerRouterDelegate;

  @override
  void initState() {
    super.initState();
    _beamerRouterDelegate = _buildRouterDelegate();
  }

  BeamerRouterDelegate _buildRouterDelegate() => BeamerRouterDelegate(
        locationBuilder: BeamerLocationBuilder(
          beamLocations: <BeamLocation>[
            CharactersBeamLocation(),
            LocationsBeamLocation(),
            EpisodesBeamLocation(),
            ProfileBeamLocation(),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery.of(context).size.width <
              BaseNavigatableScaffold.breakingPoint
          ? Beamer(
              key: widget.beamerKey,
              routerDelegate: _beamerRouterDelegate,
            )
          : Row(
              children: [
                SafeArea(
                  right: false,
                  child: BaseNavigationRail(
                    beamerKey: widget.beamerKey,
                  ),
                ),
                VerticalDivider(
                    thickness: 2,
                    width: 2,
                    color: Theme.of(context).dividerColor),
                Expanded(
                    child: Beamer(
                        key: widget.beamerKey,
                        routerDelegate: _beamerRouterDelegate)),
              ],
            ),
      bottomNavigationBar: MediaQuery.of(context).size.width <
              BaseNavigatableScaffold.breakingPoint
          ? BaseNavigationBar(beamerKey: widget.beamerKey)
          : null,
    );
  }
}
