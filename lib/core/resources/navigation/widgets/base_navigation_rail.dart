import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rickandmorty/core/resources/navigation/beam_locations/beam_locations.dart';
import 'package:rickandmorty/core/resources/navigation/beam_locations/profile_beam_location.dart';
import 'package:rickandmorty/core/resources/navigation/widgets/base_navigatable_scaffold.dart';

class BaseNavigationRail extends StatefulWidget {
  const BaseNavigationRail({super.key, required this.beamerKey});

  final GlobalKey<BeamerState> beamerKey;

  @override
  State<BaseNavigationRail> createState() => _BaseNavigationRailState();
}

class _BaseNavigationRailState extends State<BaseNavigationRail> {
  BeamerRouterDelegate? _beamerRouterDelegate;
  int _currentIndex = 0;

  void _setStateListener() => setState(() {});

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _beamerRouterDelegate = widget.beamerKey.currentState?.routerDelegate;
      _beamerRouterDelegate?.addListener(_setStateListener);
    });
  }

  @override
  void dispose() {
    _beamerRouterDelegate?.removeListener(_setStateListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final BeamLocation currentLocation =
        widget.beamerKey.currentState?.currentLocation ??
            _beamerRouterDelegate?.currentLocation ??
            (Uri.base.pathSegments.contains('profile') ||
                    Uri.base.pathSegments.contains('signup') ||
                    Uri.base.pathSegments.contains('login')
                ? ProfileBeamLocation()
                : Uri.base.pathSegments.contains('episodes')
                    ? EpisodesBeamLocation()
                    : Uri.base.pathSegments.contains('locations')
                        ? LocationsBeamLocation()
                        : CharactersBeamLocation());

    _currentIndex = currentLocation is ProfileBeamLocation
        ? 3
        : currentLocation is EpisodesBeamLocation
            ? 2
            : currentLocation is LocationsBeamLocation
                ? 1
                : 0;

    return NavigationRail(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extended: MediaQuery.of(context).size.width >
          BaseNavigatableScaffold.desktopBreakingPoint,
      selectedLabelTextStyle: Theme.of(context).textTheme.bodyLarge,
      unselectedLabelTextStyle: Theme.of(context)
          .textTheme
          .bodyLarge
          ?.copyWith(color: Theme.of(context).disabledColor),
      selectedIconTheme: Theme.of(context).iconTheme,
      unselectedIconTheme: Theme.of(context)
          .iconTheme
          .copyWith(color: Theme.of(context).disabledColor),
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
        NavigationRailDestination(
            padding: EdgeInsets.only(top: 8.0),
            icon: Icon(Icons.person),
            label: Text("Profile")),
      ],
      selectedIndex: _currentIndex,
      onDestinationSelected: ((index) {
        HapticFeedback.lightImpact();
        if (_currentIndex != index) setState(() => _currentIndex = index);
        switch (index) {
          case 3:
            _beamerRouterDelegate?.beamToNamed('/profile');
            break;
          case 2:
            _beamerRouterDelegate?.beamToNamed('/episodes');
            break;
          case 1:
            _beamerRouterDelegate?.beamToNamed('/locations');
            break;
          case 0:
          default:
            _beamerRouterDelegate?.beamToNamed('/characters');
            break;
        }
      }),
    );
  }
}
