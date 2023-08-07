part of 'episode_bloc.dart';

abstract class EpisodeState extends Equatable {
  final EpisodeEntity? episodeEntity;
  final List<EpisodeEntity>? episodeEntities;
  final GetEpisodesResponseInfo? info;
  final DioError? error;

  const EpisodeState(
      {this.episodeEntity, this.episodeEntities, this.info, this.error});

  @override
  List<Object> get props => [
        episodeEntity ?? const EpisodeEntity(),
        episodeEntities ?? [],
      ];
}

class EpisodeInitial extends EpisodeState {
  const EpisodeInitial();
}

class EpisodeLoading extends EpisodeState {
  const EpisodeLoading();
}

class EpisodeLoadingMore extends EpisodeState {
  const EpisodeLoadingMore();
}

class EpisodeDone extends EpisodeState {
  const EpisodeDone(EpisodeEntity episodeEntity)
      : super(episodeEntity: episodeEntity);
}

class EpisodesDone extends EpisodeState {
  EpisodesDone(GetEpisodesResponse getEpisodesResponse)
      : super(
            episodeEntities: getEpisodesResponse.results,
            info: getEpisodesResponse.info);
}

class EpisodeError extends EpisodeState {
  const EpisodeError(DioError error) : super(error: error);
}

class EpisodeNonFatalError extends EpisodeState {
  const EpisodeNonFatalError(DioError error) : super(error: error);
}

class EpisodeTimeoutError extends EpisodeState {
  const EpisodeTimeoutError({String? errorMessage});
}

class EpisodesEmpty extends EpisodeState {
  const EpisodesEmpty();
}
