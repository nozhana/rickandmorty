import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:rickandmorty/features/episode/presentation/pages/episode_list_view.dart';

class EpisodesBeamLocation extends BeamLocation {
  @override
  List<BeamPage> pagesBuilder(BuildContext context, BeamState state) =>
      <BeamPage>[
        BeamPage(
            key: const ValueKey("episodes"),
            name: "Episodes",
            type: BeamPageType.noTransition,
            child: const EpisodeListView()),
        // TODO: EpisodeDetailsView
      ];

  @override
  List<String> get pathBlueprints => ['/episodes/:episodeId'];
}
