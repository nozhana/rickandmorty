import 'dart:io';

import 'package:dio/dio.dart';
import 'package:rickandmorty/features/character/data/datasources/remote/character_api_service.dart';
import 'package:rickandmorty/features/character/data/models/character.dart';
import 'package:rickandmorty/core/resources/data/data_state.dart';
import 'package:rickandmorty/features/character/domain/repositories/character_repository.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  final CharacterApiService _characterApiService;
  CharacterRepositoryImpl(this._characterApiService);

  @override
  Future<DataState<GetCharactersResponse>> getAllCharacters() async {
    try {
      final httpResponse = await _characterApiService.getAllCharacters();

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(httpResponse.data);
      } else {
        return DataFailed(DioError(
            error: httpResponse.response.statusMessage,
            response: httpResponse.response,
            type: DioErrorType.response,
            requestOptions: httpResponse.response.requestOptions));
      }
    } on DioError catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<CharacterModel>> getCharacter(int id) async {
    try {
      final httpResponse =
          await _characterApiService.getCharacter(id.toString());

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(httpResponse.data);
      } else {
        return DataFailed(DioError(
            error: httpResponse.response.statusMessage,
            response: httpResponse.response,
            type: DioErrorType.response,
            requestOptions: httpResponse.response.requestOptions));
      }
    } on DioError catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<GetCharactersResponse>> filterCharacters(
      {int? page,
      String? name,
      String? status,
      String? species,
      String? type,
      String? gender}) async {
    try {
      final httpResponse = await _characterApiService.filterCharacters(
          page: page,
          name: name,
          status: status,
          species: species,
          type: type,
          gender: gender);

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(httpResponse.data);
      } else {
        return DataFailed(DioError(
            error: httpResponse.response.statusMessage,
            response: httpResponse.response,
            type: DioErrorType.response,
            requestOptions: httpResponse.response.requestOptions));
      }
    } on DioError catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<GetCharactersResponse>> getMoreCharacters(
      {required int nextPage}) async {
    try {
      final httpResponse =
          await _characterApiService.getMoreCharacters(nextPage);

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(httpResponse.data);
      } else {
        return DataFailed(DioError(
            error: httpResponse.response.statusMessage,
            response: httpResponse.response,
            type: DioErrorType.response,
            requestOptions: httpResponse.response.requestOptions));
      }
    } on DioError catch (e) {
      return DataFailed(e);
    }
  }
}
