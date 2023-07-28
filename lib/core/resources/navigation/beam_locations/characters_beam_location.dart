import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:rickandmorty/features/character/presentation/pages/character_details_view.dart';
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
        if (state.pathParameters.containsKey("characterId"))
          BeamPage(
              key: ValueKey("character-${state.pathParameters["characterId"]}"),
              name: "Character-${state.pathParameters["characterId"]}",
              type: BeamPageType.material,
              child: CharacterDetailsView(
                characterId: int.parse(state.pathParameters["characterId"]!),
              ))
      ];

  @override
  List<String> get pathBlueprints => ['/characters/:characterId'];
}
