import 'package:dio/dio.dart';
import 'package:rickandmorty/core/resources/data/data_state.dart';
import 'package:rickandmorty/core/usecase/usecase.dart';
import 'package:rickandmorty/features/character/data/datasources/remote/character_api_service.dart';
import 'package:rickandmorty/features/character/domain/entities/character_entity.dart';
import 'package:rickandmorty/features/character/domain/repositories/character_repository.dart';

class FilterCharactersUseCase
    implements UseCase<DataState<GetCharactersResponse>, CharacterEntity> {
  final CharacterRepository _characterRepository;
  FilterCharactersUseCase(this._characterRepository);

  @override
  Future<DataState<GetCharactersResponse>> call({CharacterEntity? params}) {
    return _characterRepository
        .filterCharacters(
            name: params?.name,
            species: params?.species,
            status: params?.status?.name,
            type: params?.type,
            gender: params?.gender?.name)
        .timeout(const Duration(seconds: 5));
  }
}

class FilterMoreCharactersUsecase
    implements UseCase<DataState<GetCharactersResponse>, Map<String, dynamic>> {
  final CharacterRepository _characterRepository;
  FilterMoreCharactersUsecase(this._characterRepository);

  @override
  Future<DataState<GetCharactersResponse>> call(
      {Map<String, dynamic>? params}) {
    final int page = params!['page'];
    final CharacterEntity characterEntity = params['data'];
    return _characterRepository
        .filterCharacters(
            page: page,
            name: characterEntity.name,
            gender: characterEntity.gender?.name,
            species: characterEntity.species,
            status: characterEntity.status?.name,
            type: characterEntity.type)
        .timeout(const Duration(seconds: 5));
  }
}

class GetAllCharactersUsecase
    implements UseCase<DataState<GetCharactersResponse>, void> {
  final CharacterRepository _characterRepository;
  GetAllCharactersUsecase(this._characterRepository);

  @override
  Future<DataState<GetCharactersResponse>> call({void params}) {
    return _characterRepository
        .getAllCharacters()
        .timeout(const Duration(seconds: 5));
  }
}

class GetMoreCharactersUsecase
    implements UseCase<DataState<GetCharactersResponse>, int> {
  final CharacterRepository _characterRepository;
  GetMoreCharactersUsecase(this._characterRepository);

  @override
  Future<DataState<GetCharactersResponse>> call({int? params}) {
    if (params == null) {
      return Future.value(
          DataFailed(DioError(requestOptions: RequestOptions(path: ''))));
    }
    return _characterRepository
        .getMoreCharacters(nextPage: params)
        .timeout(const Duration(seconds: 5));
  }
}

class GetCharacterUseCase implements UseCase<DataState<CharacterEntity>, int> {
  final CharacterRepository _characterRepository;
  GetCharacterUseCase(this._characterRepository);

  @override
  Future<DataState<CharacterEntity>> call({int? params}) {
    return _characterRepository
        .getCharacter(params!)
        .timeout(const Duration(seconds: 5));
  }
}
