import 'package:beamer/beamer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rickandmorty/core/navigation/beam_locations/beam_locations.dart';
import 'package:rickandmorty/core/navigation/beam_locations/profile_beam_location.dart';

class BaseNavigationBar extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const BaseNavigationBar({required this.beamerKey});

  final GlobalKey<BeamerState> beamerKey;

  @override
  State<BaseNavigationBar> createState() => BaseNavigationBarState();
}

class BaseNavigationBarState extends State<BaseNavigationBar> {
  late final BeamerRouterDelegate _beamerRouterDelegate;
  int _currentIndex = 0;

  void _setStateListener() => setState(() {});

  @override
  void initState() {
    super.initState();
    _beamerRouterDelegate = widget.beamerKey.currentState!.routerDelegate;
    _beamerRouterDelegate.addListener(_setStateListener);
  }

  @override
  void dispose() {
    _beamerRouterDelegate.removeListener(_setStateListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _currentIndex = _beamerRouterDelegate.currentLocation is ProfileBeamLocation
        ? 3
        : _beamerRouterDelegate.currentLocation is EpisodesBeamLocation
            ? 2
            : _beamerRouterDelegate.currentLocation is LocationsBeamLocation
                ? 1
                : 0;

    return Padding(
      padding: const EdgeInsets.only(bottom: kIsWeb ? 28 : 0),
      child: BottomNavigationBar(
        elevation: 0,
        enableFeedback: true,
        currentIndex: _currentIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).disabledColor,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              label: "Characters", icon: Icon(Icons.people)),
          BottomNavigationBarItem(
              label: "Locations", icon: Icon(Icons.location_on)),
          BottomNavigationBarItem(label: "Episodes", icon: Icon(Icons.tv)),
          BottomNavigationBarItem(label: "Profile", icon: Icon(Icons.person)),
        ],
        onTap: (index) {
          HapticFeedback.lightImpact();
          _beamerRouterDelegate.beamToNamed(index == 3
              ? '/profile'
              : index == 2
                  ? '/episodes'
                  : index == 1
                      ? '/locations'
                      : '/characters');
        },
      ),
    );
  }
}
