part of 'character_bloc.dart';

abstract class CharacterState extends Equatable {
  final CharacterEntity? characterEntity;
  final List<CharacterEntity>? characterEntities;
  final GetCharactersResponseInfo? info;
  final DioError? error;

  const CharacterState(
      {this.characterEntity, this.characterEntities, this.info, this.error});

  @override
  List<Object> get props => [
        characterEntity ?? const CharacterEntity(),
        characterEntities ?? [],
      ];
}

class CharacterInitial extends CharacterState {
  const CharacterInitial();
}

class CharacterLoading extends CharacterState {
  const CharacterLoading();
}

class CharacterLoadingMore extends CharacterState {
  const CharacterLoadingMore();
}

class CharacterDone extends CharacterState {
  const CharacterDone(CharacterEntity characterEntity)
      : super(characterEntity: characterEntity);
}

class CharactersDone extends CharacterState {
  CharactersDone(GetCharactersResponse getCharactersResponse)
      : super(
            characterEntities: getCharactersResponse.results,
            info: getCharactersResponse.info);
}

class CharacterError extends CharacterState {
  const CharacterError(DioError error) : super(error: error);
}

class CharacterNonFatalError extends CharacterState {
  const CharacterNonFatalError(DioError error) : super(error: error);
}

class CharacterTimeoutError extends CharacterState {
  const CharacterTimeoutError({String? errorMessage});
}

class CharactersEmpty extends CharacterState {
  const CharactersEmpty();
}
