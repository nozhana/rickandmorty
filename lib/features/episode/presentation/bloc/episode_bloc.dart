import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:rickandmorty/core/resources/data/data_state.dart';
import 'package:rickandmorty/features/episode/data/datasources/remote/episode_api_service.dart';
import 'package:rickandmorty/features/episode/domain/entities/episode_entity.dart';
import 'package:rickandmorty/features/episode/domain/usecases/episode_usecases.dart';

part 'episode_event.dart';
part 'episode_state.dart';

class EpisodeBloc extends Bloc<EpisodeEvent, EpisodeState> {
  final GetEpisodeUseCase _getEpisodeUseCase;
  final GetAllEpisodesUseCase _getAllEpisodesUseCase;
  final GetMoreEpisodesUseCase _getMoreEpisodesUseCase;
  final FilterEpisodesUseCase _filterEpisodesUseCase;
  final FilterMoreEpisodesUseCase _filterMoreEpisodesUseCase;

  EpisodeBloc(
      this._getEpisodeUseCase,
      this._getAllEpisodesUseCase,
      this._filterEpisodesUseCase,
      this._getMoreEpisodesUseCase,
      this._filterMoreEpisodesUseCase)
      : super(const EpisodeInitial()) {
    on<GetEpisode>(onGetEpisode);
    on<GetAllEpisodes>(onGetAllEpisodes);
    on<GetMoreEpisodes>(onGetMoreEpisodes);
    on<FilterEpisodes>(onFilterEpisodes);
    on<FilterMoreEpisodes>(onFilterMoreEpisodes);
  }

  FutureOr<void> onGetEpisode(
      GetEpisode event, Emitter<EpisodeState> emit) async {
    emit(const EpisodeLoading());

    final DataState dataState;
    try {
      dataState = await _getEpisodeUseCase(params: event.id);
    } on TimeoutException catch (e) {
      emit(EpisodeTimeoutError(errorMessage: e.message));
      return;
    }

    if (dataState is DataSuccess && dataState.data != null) {
      emit(EpisodeDone(dataState.data!));
    }

    if (dataState is DataFailed && dataState.error != null) {
      emit(EpisodeError(dataState.error!));
    }
  }

  FutureOr<void> onGetAllEpisodes(
      GetAllEpisodes event, Emitter<EpisodeState> emit) async {
    emit(const EpisodeLoading());

    final DataState dataState;
    try {
      dataState = await _getAllEpisodesUseCase();
    } on TimeoutException catch (e) {
      emit(EpisodeTimeoutError(errorMessage: e.message));
      return;
    }

    if (dataState is DataSuccess && dataState.data != null) {
      emit(EpisodesDone(dataState.data!));
    }

    if (dataState is DataFailed && dataState.error != null) {
      emit(EpisodeError(dataState.error!));
    }
  }

  FutureOr<void> onGetMoreEpisodes(
      GetMoreEpisodes event, Emitter<EpisodeState> emit) async {
    emit(const EpisodeLoadingMore());

    final DataState dataState;

    try {
      dataState = await _getMoreEpisodesUseCase(params: event.page);
    } on TimeoutException catch (e) {
      emit(EpisodeTimeoutError(errorMessage: e.message));
      return;
    }

    if (dataState is DataSuccess && dataState.data != null) {
      emit(EpisodesDone(dataState.data!));
    }

    if (dataState is DataFailed && dataState.error != null) {
      emit(EpisodeNonFatalError(dataState.error!));
    }
  }

  FutureOr<void> onFilterEpisodes(
      FilterEpisodes event, Emitter<EpisodeState> emit) async {
    emit(const EpisodeLoading());

    final DataState dataState;
    try {
      dataState = await _filterEpisodesUseCase(params: event.episodeEntity);
    } on TimeoutException catch (e) {
      emit(EpisodeTimeoutError(errorMessage: e.message));
      return;
    }

    if (dataState is DataSuccess && dataState.data != null) {
      emit(EpisodesDone(dataState.data!));
    }

    if (dataState is DataFailed && dataState.error != null) {
      if (dataState.error?.type == DioErrorType.response &&
          dataState.error?.response?.statusCode == 404) {
        emit(const EpisodesEmpty());
      } else {
        emit(EpisodeError(dataState.error!));
      }
    }
  }

  FutureOr<void> onFilterMoreEpisodes(
      FilterMoreEpisodes event, Emitter<EpisodeState> emit) async {
    emit(const EpisodeLoadingMore());

    final DataState dataState;
    try {
      dataState = await _filterMoreEpisodesUseCase(params: {
        'page': event.page,
        'data': event.episodeEntity,
      });
    } on TimeoutException catch (e) {
      emit(EpisodeTimeoutError(errorMessage: e.message));
      return;
    }

    if (dataState is DataSuccess && dataState.data != null) {
      emit(EpisodesDone(dataState.data!));
    }

    if (dataState is DataFailed && dataState.error != null) {
      emit(EpisodeNonFatalError(dataState.error!));
    }
  }
}
