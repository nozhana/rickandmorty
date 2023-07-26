import 'package:floor/floor.dart';
import 'package:rickandmorty/features/character/data/datasources/local/models/character_in_db.dart';

@dao
abstract class CharacterDao {
  @insert
  Future<void> insertCharacter(CharacterModelInDb characterModel);

  @delete
  Future<void> deleteCharacter(CharacterModelInDb characterModel);

  @Query("SELECT * FROM character WHERE id = :id")
  Future<CharacterModelInDb?> getCharacter(int id);

  @Query("SELECT * FROM character")
  Future<List<CharacterModelInDb>> getAllCharacters();
}
