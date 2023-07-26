import 'dart:convert';

import 'package:floor/floor.dart';
import 'package:rickandmorty/features/character/data/models/character.dart';
import 'package:rickandmorty/features/character/data/models/embedded_location.dart';
import 'package:rickandmorty/features/character/domain/entities/types.dart';

@Entity(tableName: 'character')
class CharacterModelInDb {
  @primaryKey
  final int? id;
  final String? name;
  final CharacterStatus? status;
  final String? species;
  final String? type;
  final CharacterGender? gender;
  final String? origin;
  final String? location;
  final String? image;
  final String? episodes;
  final String? url;

  CharacterModelInDb(
      {this.id,
      this.name,
      this.status,
      this.species,
      this.type,
      this.gender,
      this.origin,
      this.location,
      this.image,
      this.episodes,
      this.url});

  factory CharacterModelInDb.fromCharacterModel(
      {required CharacterModel characterModel}) {
    return CharacterModelInDb(
      id: characterModel.id,
      name: characterModel.name,
      status: characterModel.status,
      species: characterModel.species,
      type: characterModel.type,
      gender: characterModel.gender,
      origin: jsonEncode(((characterModel.origin ??
              const EmbeddedLocationModel()) as EmbeddedLocationModel)
          .toJson()),
      location: jsonEncode(((characterModel.location ??
              const EmbeddedLocationModel()) as EmbeddedLocationModel)
          .toJson()),
      image: characterModel.image,
      episodes: characterModel.episode?.join(","),
      url: characterModel.url,
    );
  }

  CharacterModel toCharacterModel() {
    return CharacterModel(
      id: id,
      name: name,
      status: status,
      species: species,
      type: type,
      gender: gender,
      origin: EmbeddedLocationModel.fromJson(
          jsonDecode(origin ?? '{"name": "unknown", "url": ""}')),
      location: EmbeddedLocationModel.fromJson(
          jsonDecode(location ?? '{"name": "unknown", "url": ""}')),
      image: image,
      episode: episodes?.split(","),
      url: url,
    );
  }
}
