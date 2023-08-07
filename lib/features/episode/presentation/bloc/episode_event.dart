part of 'episode_bloc.dart';

abstract class EpisodeEvent extends Equatable {
  const EpisodeEvent();

  @override
  List<Object> get props => [];
}

class GetEpisode extends EpisodeEvent {
  final int id;
  const GetEpisode({required this.id});
}

class GetAllEpisodes extends EpisodeEvent {
  const GetAllEpisodes();
}

class GetMoreEpisodes extends EpisodeEvent {
  final int page;
  const GetMoreEpisodes({required this.page});
}

class FilterEpisodes extends EpisodeEvent {
  final EpisodeEntity episodeEntity;
  const FilterEpisodes({required this.episodeEntity});
}

class FilterMoreEpisodes extends EpisodeEvent {
  final EpisodeEntity episodeEntity;
  final int page;
  const FilterMoreEpisodes({required this.episodeEntity, required this.page});
}
