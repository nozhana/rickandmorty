import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'episode_event.dart';
part 'episode_state.dart';

class EpisodeBloc extends Bloc<EpisodeEvent, EpisodeState> {
  EpisodeBloc() : super(EpisodeInitial()) {
    on<EpisodeEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
