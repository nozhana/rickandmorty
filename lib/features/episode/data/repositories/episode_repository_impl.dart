import 'dart:io';
import 'package:dio/dio.dart';
import 'package:rickandmorty/core/resources/data/data_state.dart';
import 'package:rickandmorty/features/episode/data/datasources/remote/episode_api_service.dart';
import 'package:rickandmorty/features/episode/data/models/episode.dart';
import 'package:rickandmorty/features/episode/domain/repositories/episode_repository.dart';

class EpisodeRepositoryImpl implements EpisodeRepository {
  final EpisodeApiService _episodeApiService;
  EpisodeRepositoryImpl(this._episodeApiService);

  @override
  Future<DataState<GetEpisodesResponse>> getAllEpisodes() async {
    try {
      final httpResponse = await _episodeApiService.getAllEpisodes();

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
  Future<DataState<EpisodeModel>> getEpisode(int id) async {
    try {
      final httpResponse = await _episodeApiService.getEpisode(id.toString());

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
  Future<DataState<GetEpisodesResponse>> filterEpisodes(
      {int? page, String? name, String? episode}) async {
    try {
      final httpResponse = await _episodeApiService.filterEpisodes(
          page: page, name: name, episode: episode);

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
  Future<DataState<GetEpisodesResponse>> getMoreEpisodes(
      {required int nextPage}) async {
    try {
      final httpResponse = await _episodeApiService.getMoreEpisodes(nextPage);

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
