import 'dart:async';
import 'package:rickandmorty/features/character/domain/entities/types.dart';
// ignore: depend_on_referenced_packages
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:floor/floor.dart';
import 'package:rickandmorty/features/character/data/datasources/local/DAO/character_dao.dart';
import 'package:rickandmorty/features/character/data/datasources/local/models/character_in_db.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [CharacterModelInDb])
abstract class AppDatabase extends FloorDatabase {
  CharacterDao get characterDao;
}
