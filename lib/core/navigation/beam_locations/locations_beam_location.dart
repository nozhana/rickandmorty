import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:rickandmorty/features/location/presentation/pages/location_list_view.dart';

class LocationsBeamLocation extends BeamLocation {
  @override
  List<BeamPage> pagesBuilder(BuildContext context, BeamState state) =>
      <BeamPage>[
        BeamPage(
            key: const ValueKey("locations"),
            name: "Locations",
            type: BeamPageType.noTransition,
            child: const LocationListView()),
        // TODO: LocationDetailsView
      ];

  @override
  List<String> get pathBlueprints => ['/locations/:locationId'];
}
