import 'package:dio/dio.dart';
import 'package:rickandmorty/core/resources/data/data_state.dart';
import 'package:rickandmorty/core/usecase/usecase.dart';
import 'package:rickandmorty/features/episode/data/datasources/remote/episode_api_service.dart';
import 'package:rickandmorty/features/episode/domain/entities/episode_entity.dart';
import 'package:rickandmorty/features/episode/domain/repositories/episode_repository.dart';

class FilterEpisodesUseCase
    implements UseCase<DataState<GetEpisodesResponse>, EpisodeEntity> {
  final EpisodeRepository _episodeRepository;
  FilterEpisodesUseCase(this._episodeRepository);

  @override
  Future<DataState<GetEpisodesResponse>> call({EpisodeEntity? params}) {
    return _episodeRepository
        .filterEpisodes(name: params?.name, episode: params?.episode)
        .timeout(const Duration(seconds: 5));
  }
}

class FilterMoreEpisodesUseCase
    implements UseCase<DataState<GetEpisodesResponse>, Map<String, dynamic>> {
  final EpisodeRepository _episodeRepository;
  FilterMoreEpisodesUseCase(this._episodeRepository);

  @override
  Future<DataState<GetEpisodesResponse>> call({Map<String, dynamic>? params}) {
    final int page = params!['page'];
    final EpisodeEntity episodeEntity = params['data'];
    return _episodeRepository
        .filterEpisodes(
            page: page,
            name: episodeEntity.name,
            episode: episodeEntity.episode)
        .timeout(const Duration(seconds: 5));
  }
}

class GetAllEpisodesUseCase
    implements UseCase<DataState<GetEpisodesResponse>, void> {
  final EpisodeRepository _episodeRepository;
  GetAllEpisodesUseCase(this._episodeRepository);

  @override
  Future<DataState<GetEpisodesResponse>> call({void params}) {
    return _episodeRepository
        .getAllEpisodes()
        .timeout(const Duration(seconds: 5));
  }
}

class GetMoreEpisodesUseCase
    implements UseCase<DataState<GetEpisodesResponse>, int> {
  final EpisodeRepository _episodeRepository;
  GetMoreEpisodesUseCase(this._episodeRepository);

  @override
  Future<DataState<GetEpisodesResponse>> call({int? params}) {
    if (params == null) {
      return Future.value(
          DataFailed(DioError(requestOptions: RequestOptions(path: ''))));
    }
    return _episodeRepository
        .getMoreEpisodes(nextPage: params)
        .timeout(const Duration(seconds: 5));
  }
}

class GetEpisodeUseCase implements UseCase<DataState<EpisodeEntity>, int> {
  final EpisodeRepository _episodeRepository;
  GetEpisodeUseCase(this._episodeRepository);

  @override
  Future<DataState<EpisodeEntity>> call({int? params}) {
    return _episodeRepository
        .getEpisode(params!)
        .timeout(const Duration(seconds: 5));
  }
}
