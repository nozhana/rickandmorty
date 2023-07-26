import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:rickandmorty/features/character/presentation/pages/character_list_view.dart';

class CharactersBeamLocation extends BeamLocation<BeamState> {
  @override
  List<BeamPage> pagesBuilder(BuildContext context, BeamState state) =>
      <BeamPage>[
        BeamPage(
            key: const ValueKey("characters"),
            name: "Characters",
            type: BeamPageType.noTransition,
            child: const CharacterListView()),
        // TODO: CharacterDetailsView
      ];

  @override
  List<String> get pathBlueprints => ['/characters/:characterId'];
}
