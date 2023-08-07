import 'package:rickandmorty/core/resources/data/data_state.dart';
import 'package:rickandmorty/features/episode/data/datasources/remote/episode_api_service.dart';
import 'package:rickandmorty/features/episode/domain/entities/episode_entity.dart';

abstract class EpisodeRepository {
  Future<DataState<GetEpisodesResponse>> getAllEpisodes();
  Future<DataState<GetEpisodesResponse>> getMoreEpisodes(
      {required int nextPage});
  Future<DataState<GetEpisodesResponse>> filterEpisodes(
      {int? page, String? name, String? episode});
  Future<DataState<EpisodeEntity>> getEpisode(int id);
}
