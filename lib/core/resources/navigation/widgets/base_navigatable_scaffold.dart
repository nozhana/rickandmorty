import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:rickandmorty/core/resources/navigation/beam_locations/beam_locations.dart';
import 'package:rickandmorty/config/theme/app_themes.dart';
import 'package:rickandmorty/core/resources/navigation/widgets/base_navigation_bar.dart';

class BaseNavigatableScaffold extends StatefulWidget {
  BaseNavigatableScaffold({Key? key}) : super(key: key);

  final beamerKey = GlobalKey<BeamerState>();
  static const int breakingPoint = 640;

  @override
  State<BaseNavigatableScaffold> createState() =>
      _BaseNavigatableScaffoldState();
}

class _BaseNavigatableScaffoldState extends State<BaseNavigatableScaffold> {
  final _beamerRouterDelegate = BeamerRouterDelegate(
    locationBuilder: BeamerLocationBuilder(
      beamLocations: <BeamLocation>[
        CharactersBeamLocation(),
        LocationsBeamLocation(),
        EpisodesBeamLocation(),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    int selectedIndex =
        _beamerRouterDelegate.currentLocation is EpisodesBeamLocation
            ? 2
            : _beamerRouterDelegate.currentLocation is LocationsBeamLocation
                ? 1
                : 0;

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
                  child: NavigationRail(
                    extended: MediaQuery.of(context).size.width > 1000,
                    selectedLabelTextStyle: theme().textTheme.bodyLarge,
                    unselectedLabelTextStyle: theme()
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.grey),
                    selectedIconTheme: theme().iconTheme,
                    unselectedIconTheme:
                        theme().iconTheme.copyWith(color: Colors.grey),
                    destinations: const <NavigationRailDestination>[
                      NavigationRailDestination(
                          padding: EdgeInsets.only(top: 16.0),
                          icon: Icon(Icons.people),
                          label: Text("Characters")),
                      NavigationRailDestination(
                          padding: EdgeInsets.only(top: 8.0),
                          icon: Icon(Icons.location_on),
                          label: Text("Locations")),
                      NavigationRailDestination(
                          padding: EdgeInsets.only(top: 8.0),
                          icon: Icon(Icons.tv),
                          label: Text("Episodes")),
                    ],
                    selectedIndex: selectedIndex,
                    onDestinationSelected: ((index) {
                      if (index != selectedIndex) {
                        setState(() {
                          selectedIndex = index;
                        });
                        switch (index) {
                          case 2:
                            _beamerRouterDelegate.beamToNamed('/episodes');
                            break;
                          case 1:
                            _beamerRouterDelegate.beamToNamed('/locations');
                            break;
                          case 0:
                          default:
                            _beamerRouterDelegate.beamToNamed('/characters');
                            break;
                        }
                      }
                    }),
                  ),
                ),
                const VerticalDivider(thickness: 1, width: 1),
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
