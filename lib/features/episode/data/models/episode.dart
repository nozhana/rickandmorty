import 'package:rickandmorty/features/episode/domain/entities/episode_entity.dart';

class EpisodeModel extends EpisodeEntity {
  const EpisodeModel(
      {int? id,
      String? name,
      String? episode,
      List<String>? characters,
      String? url})
      : super(
          id: id,
          name: name,
          episode: episode,
          characters: characters,
          url: url,
        );

  factory EpisodeModel.fromJson(Map<String, dynamic> map) {
    return EpisodeModel(
        id: map["id"],
        name: map["name"],
        episode: map["episode"],
        characters: List<String>.from(map["characters"]),
        url: map["url"]);
  }
}
