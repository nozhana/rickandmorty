import 'package:rickandmorty/core/resources/data/data_state.dart';
import 'package:rickandmorty/features/character/data/datasources/remote/character_api_service.dart';
import 'package:rickandmorty/features/character/domain/entities/character_entity.dart';

abstract class CharacterRepository {
  Future<DataState<GetCharactersResponse>> getAllCharacters();
  Future<DataState<GetCharactersResponse>> getMoreCharacters(
      {required int nextPage});
  Future<DataState<GetCharactersResponse>> filterCharacters(
      {int? page,
      String? name,
      String? status,
      String? species,
      String? type,
      String? gender});
  Future<DataState<CharacterEntity>> getCharacter(int id);
}
