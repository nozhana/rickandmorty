import 'package:rickandmorty/features/character/data/models/embedded_location.dart';
import 'package:rickandmorty/features/character/domain/entities/character_entity.dart';
import 'package:rickandmorty/features/character/domain/entities/types.dart';

class CharacterModel extends CharacterEntity {
  const CharacterModel(
      {int? id,
      String? name,
      CharacterStatus? status,
      String? species,
      String? type,
      CharacterGender? gender,
      EmbeddedLocationModel? origin,
      EmbeddedLocationModel? location,
      String? image,
      List<String>? episode,
      String? url})
      : super(
          id: id,
          name: name,
          status: status,
          type: type,
          gender: gender,
          origin: origin,
          location: location,
          image: image,
          episode: episode,
          url: url,
        );

  factory CharacterModel.fromJson(Map<String, dynamic> map) {
    return CharacterModel(
        id: map["id"],
        name: map["name"],
        status: CharacterStatus.fromString(map["status"]),
        species: map["species"],
        type: map["type"],
        gender: CharacterGender.fromString(map["gender"]),
        origin: EmbeddedLocationModel.fromJson(map["origin"]),
        location: EmbeddedLocationModel.fromJson(map["location"]),
        image: map["image"],
        episode: List<String>.from(map["episode"]),
        url: map["url"]);
  }
}
