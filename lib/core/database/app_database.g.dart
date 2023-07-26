// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: library_private_types_in_public_api

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  CharacterDao? _characterDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `character` (`id` INTEGER, `name` TEXT, `status` INTEGER, `species` TEXT, `type` TEXT, `gender` INTEGER, `origin` TEXT, `location` TEXT, `image` TEXT, `episodes` TEXT, `url` TEXT, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  CharacterDao get characterDao {
    return _characterDaoInstance ??= _$CharacterDao(database, changeListener);
  }
}

class _$CharacterDao extends CharacterDao {
  _$CharacterDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _characterModelInDbInsertionAdapter = InsertionAdapter(
            database,
            'character',
            (CharacterModelInDb item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'status': item.status?.index,
                  'species': item.species,
                  'type': item.type,
                  'gender': item.gender?.index,
                  'origin': item.origin,
                  'location': item.location,
                  'image': item.image,
                  'episodes': item.episodes,
                  'url': item.url
                }),
        _characterModelInDbDeletionAdapter = DeletionAdapter(
            database,
            'character',
            ['id'],
            (CharacterModelInDb item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'status': item.status?.index,
                  'species': item.species,
                  'type': item.type,
                  'gender': item.gender?.index,
                  'origin': item.origin,
                  'location': item.location,
                  'image': item.image,
                  'episodes': item.episodes,
                  'url': item.url
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CharacterModelInDb>
      _characterModelInDbInsertionAdapter;

  final DeletionAdapter<CharacterModelInDb> _characterModelInDbDeletionAdapter;

  @override
  Future<CharacterModelInDb?> getCharacter(int id) async {
    return _queryAdapter.query('SELECT * FROM character WHERE id = ?1',
        mapper: (Map<String, Object?> row) => CharacterModelInDb(
            id: row['id'] as int?,
            name: row['name'] as String?,
            status: row['status'] == null
                ? null
                : CharacterStatus.values[row['status'] as int],
            species: row['species'] as String?,
            type: row['type'] as String?,
            gender: row['gender'] == null
                ? null
                : CharacterGender.values[row['gender'] as int],
            origin: row['origin'] as String?,
            location: row['location'] as String?,
            image: row['image'] as String?,
            episodes: row['episodes'] as String?,
            url: row['url'] as String?),
        arguments: [id]);
  }

  @override
  Future<List<CharacterModelInDb>> getAllCharacters() async {
    return _queryAdapter.queryList('SELECT * FROM character',
        mapper: (Map<String, Object?> row) => CharacterModelInDb(
            id: row['id'] as int?,
            name: row['name'] as String?,
            status: row['status'] == null
                ? null
                : CharacterStatus.values[row['status'] as int],
            species: row['species'] as String?,
            type: row['type'] as String?,
            gender: row['gender'] == null
                ? null
                : CharacterGender.values[row['gender'] as int],
            origin: row['origin'] as String?,
            location: row['location'] as String?,
            image: row['image'] as String?,
            episodes: row['episodes'] as String?,
            url: row['url'] as String?));
  }

  @override
  Future<void> insertCharacter(CharacterModelInDb characterModel) async {
    await _characterModelInDbInsertionAdapter.insert(
        characterModel, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteCharacter(CharacterModelInDb characterModel) async {
    await _characterModelInDbDeletionAdapter.delete(characterModel);
  }
}
