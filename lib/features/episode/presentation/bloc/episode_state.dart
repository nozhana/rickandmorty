part of 'episode_bloc.dart';

abstract class EpisodeState extends Equatable {
  const EpisodeState();  

  @override
  List<Object> get props => [];
}
class EpisodeInitial extends EpisodeState {}
