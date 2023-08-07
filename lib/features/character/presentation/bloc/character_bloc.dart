import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:rickandmorty/core/resources/data/data_state.dart';
import 'package:rickandmorty/features/character/data/datasources/remote/character_api_service.dart';
import 'package:rickandmorty/features/character/domain/usecases/character_usecases.dart';

import '../../domain/entities/character_entity.dart';

part 'character_event.dart';
part 'character_state.dart';

class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  final GetCharacterUseCase _getCharacterUseCase;
  final GetAllCharactersUseCase _getAllCharactersUseCase;
  final GetMoreCharactersUseCase _getMoreCharactersUseCase;
  final FilterCharactersUseCase _filterCharactersUseCase;
  final FilterMoreCharactersUseCase _filterMoreCharactersUseCase;

  CharacterBloc(
      this._getCharacterUseCase,
      this._getAllCharactersUseCase,
      this._filterCharactersUseCase,
      this._getMoreCharactersUseCase,
      this._filterMoreCharactersUseCase)
      : super(const CharacterInitial()) {
    on<GetCharacter>(onGetCharacter);
    on<GetAllCharacters>(onGetAllCharacters);
    on<GetMoreCharacters>(onGetMoreCharacters);
    on<FilterCharacters>(onFilterCharacters);
    on<FilterMoreCharacters>(onFilterMoreCharacters);
  }

  FutureOr<void> onGetCharacter(
      GetCharacter event, Emitter<CharacterState> emit) async {
    emit(const CharacterLoading());

    final DataState dataState;
    try {
      dataState = await _getCharacterUseCase(params: event.id);
    } on TimeoutException catch (e) {
      emit(CharacterTimeoutError(errorMessage: e.message));
      return;
    }

    if (dataState is DataSuccess && dataState.data != null) {
      emit(CharacterDone(dataState.data!));
    }

    if (dataState is DataFailed && dataState.error != null) {
      emit(CharacterError(dataState.error!));
    }
  }

  FutureOr<void> onGetAllCharacters(
      GetAllCharacters event, Emitter<CharacterState> emit) async {
    emit(const CharacterLoading());

    final DataState dataState;
    try {
      dataState = await _getAllCharactersUseCase();
    } on TimeoutException catch (e) {
      emit(CharacterTimeoutError(errorMessage: e.message));
      return;
    }

    if (dataState is DataSuccess && dataState.data != null) {
      emit(CharactersDone(dataState.data!));
    }

    if (dataState is DataFailed && dataState.error != null) {
      emit(CharacterError(dataState.error!));
    }
  }

  FutureOr<void> onGetMoreCharacters(
      GetMoreCharacters event, Emitter<CharacterState> emit) async {
    emit(const CharacterLoadingMore());

    final DataState dataState;

    try {
      dataState = await _getMoreCharactersUseCase(params: event.page);
    } on TimeoutException catch (e) {
      emit(CharacterTimeoutError(errorMessage: e.message));
      return;
    }

    if (dataState is DataSuccess && dataState.data != null) {
      emit(CharactersDone(dataState.data!));
    }

    if (dataState is DataFailed && dataState.error != null) {
      emit(CharacterNonFatalError(dataState.error!));
    }
  }

  FutureOr<void> onFilterCharacters(
      FilterCharacters event, Emitter<CharacterState> emit) async {
    emit(const CharacterLoading());

    final DataState dataState;
    try {
      dataState = await _filterCharactersUseCase(params: event.characterEntity);
    } on TimeoutException catch (e) {
      emit(CharacterTimeoutError(errorMessage: e.message));
      return;
    }

    if (dataState is DataSuccess && dataState.data != null) {
      emit(CharactersDone(dataState.data!));
    }

    if (dataState is DataFailed && dataState.error != null) {
      if (dataState.error?.type == DioErrorType.response &&
          dataState.error?.response?.statusCode == 404) {
        emit(const CharactersEmpty());
      } else {
        emit(CharacterError(dataState.error!));
      }
    }
  }

  FutureOr<void> onFilterMoreCharacters(
      FilterMoreCharacters event, Emitter<CharacterState> emit) async {
    emit(const CharacterLoadingMore());

    final DataState dataState;
    try {
      dataState = await _filterMoreCharactersUseCase(params: {
        'page': event.page,
        'data': event.characterEntity,
      });
    } on TimeoutException catch (e) {
      emit(CharacterTimeoutError(errorMessage: e.message));
      return;
    }

    if (dataState is DataSuccess && dataState.data != null) {
      emit(CharactersDone(dataState.data!));
    }

    if (dataState is DataFailed && dataState.error != null) {
      emit(CharacterNonFatalError(dataState.error!));
    }
  }
}
