import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class EpisodeEntity extends Equatable {
  final int? id;
  final String? name;
  final String? airDate;
  final String? episode;
  final List<String>? characters;
  final String? url;

  const EpisodeEntity(
      {this.id,
      this.name,
      this.airDate,
      this.episode,
      this.characters,
      this.url});

  @override
  List<Object?> get props => [
        id,
        name,
        airDate,
        episode,
        url,
      ];

  EpisodeEntity copyWith({
    ValueGetter<int?>? id,
    ValueGetter<String?>? name,
    ValueGetter<String?>? episode,
    ValueGetter<List<String>?>? characters,
    ValueGetter<String?>? url,
  }) {
    return EpisodeEntity(
      id: id != null ? id() : this.id,
      name: name != null ? name() : this.name,
      episode: episode != null ? episode() : this.episode,
      characters: characters != null ? characters() : this.characters,
      url: url != null ? url() : this.url,
    );
  }

  bool get hasValue =>
      (id != null) ||
      (name != null) ||
      (episode != null) ||
      (characters?.isNotEmpty ?? false) ||
      (url != null);
}
