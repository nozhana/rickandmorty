part of 'character_bloc.dart';

abstract class CharacterEvent extends Equatable {
  const CharacterEvent();

  @override
  List<Object> get props => [];
}

class GetCharacter extends CharacterEvent {
  final int id;
  const GetCharacter({required this.id});
}

class GetAllCharacters extends CharacterEvent {
  const GetAllCharacters();
}

class GetMoreCharacters extends CharacterEvent {
  final int page;
  const GetMoreCharacters({required this.page});
}

class FilterCharacters extends CharacterEvent {
  final CharacterEntity characterEntity;
  const FilterCharacters({required this.characterEntity});
}

class FilterMoreCharacters extends CharacterEvent {
  final CharacterEntity characterEntity;
  final int page;
  const FilterMoreCharacters(
      {required this.characterEntity, required this.page});
}
