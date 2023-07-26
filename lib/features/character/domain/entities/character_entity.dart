import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rickandmorty/features/character/domain/entities/embedded_location_entity.dart';
import 'package:rickandmorty/features/character/domain/entities/types.dart';

class CharacterEntity extends Equatable {
  final int? id;
  final String? name;
  final CharacterStatus? status;
  final String? species;
  final String? type;
  final CharacterGender? gender;
  final EmbeddedLocationEntity? origin;
  final EmbeddedLocationEntity? location;
  final String? image;
  final List<String>? episode;
  final String? url;

  const CharacterEntity(
      {this.id,
      this.name,
      this.status,
      this.species,
      this.type,
      this.gender,
      this.origin,
      this.location,
      this.image,
      this.episode,
      this.url});

  @override
  List<Object?> get props => [
        id,
        name,
        status,
        species,
        type,
        gender,
        origin,
        location,
        image,
        episode,
        url
      ];

  CharacterEntity copyWith({
    ValueGetter<int?>? id,
    ValueGetter<String?>? name,
    ValueGetter<CharacterStatus?>? status,
    ValueGetter<String?>? species,
    ValueGetter<String?>? type,
    ValueGetter<CharacterGender?>? gender,
    ValueGetter<EmbeddedLocationEntity?>? origin,
    ValueGetter<EmbeddedLocationEntity?>? location,
    ValueGetter<String?>? image,
    ValueGetter<List<String>?>? episode,
    ValueGetter<String?>? url,
  }) {
    return CharacterEntity(
      id: id != null ? id() : this.id,
      name: name != null ? name() : this.name,
      status: status != null ? status() : this.status,
      species: species != null ? species() : this.species,
      type: type != null ? type() : this.type,
      gender: gender != null ? gender() : this.gender,
      origin: origin != null ? origin() : this.origin,
      location: location != null ? location() : this.location,
      image: image != null ? image() : this.image,
      episode: episode != null ? episode() : this.episode,
      url: url != null ? url() : this.url,
    );
  }

  bool get hasValue =>
      (id != null) ||
      (name != null) ||
      (status != null) ||
      (species != null) ||
      (type != null) ||
      (gender != null) ||
      (origin != null) ||
      (location != null) ||
      (image != null) ||
      (episode != null) ||
      (url != null);
}
