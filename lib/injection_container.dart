import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:rickandmorty/core/constants/constants.dart' as constants;
import 'package:rickandmorty/core/database/app_database.dart';
import 'package:rickandmorty/core/utils/logger.dart';
import 'package:rickandmorty/features/character/data/datasources/remote/character_api_service.dart';
import 'package:rickandmorty/features/character/data/repositories/character_repository_impl.dart';
import 'package:rickandmorty/features/character/domain/repositories/character_repository.dart';
import 'package:rickandmorty/features/character/domain/usecases/character_usecases.dart';
import 'package:rickandmorty/features/character/presentation/bloc/character_bloc.dart';
import 'package:rickandmorty/features/episode/data/datasources/remote/episode_api_service.dart';
import 'package:rickandmorty/features/episode/data/repositories/episode_repository_impl.dart';
import 'package:rickandmorty/features/episode/domain/repositories/episode_repository.dart';
import 'package:rickandmorty/features/episode/domain/usecases/episode_usecases.dart';
import 'package:rickandmorty/features/episode/presentation/bloc/episode_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Logger
  sl.registerSingleton<CustomLogger>(CustomLogger());
  constants.logger = sl<CustomLogger>();

  // Database
  if (!kIsWeb) {
    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    sl.registerSingleton<AppDatabase>(database);
  }

  // Dio
  sl.registerSingleton<Dio>(Dio());

  // Services
  sl.registerSingleton<CharacterApiService>(CharacterApiService(sl()));
  sl.registerSingleton<CharacterRepository>(CharacterRepositoryImpl(sl()));

  sl.registerSingleton<EpisodeApiService>(EpisodeApiService(sl()));
  sl.registerSingleton<EpisodeRepository>(EpisodeRepositoryImpl(sl()));

  // UseCases
  sl.registerSingleton<GetCharacterUseCase>(GetCharacterUseCase(sl()));
  sl.registerSingleton<GetAllCharactersUseCase>(GetAllCharactersUseCase(sl()));
  sl.registerSingleton<FilterCharactersUseCase>(FilterCharactersUseCase(sl()));
  sl.registerSingleton<GetMoreCharactersUseCase>(
      GetMoreCharactersUseCase(sl()));
  sl.registerSingleton<FilterMoreCharactersUseCase>(
      FilterMoreCharactersUseCase(sl()));

  sl.registerSingleton<GetEpisodeUseCase>(GetEpisodeUseCase(sl()));
  sl.registerSingleton<GetAllEpisodesUseCase>(GetAllEpisodesUseCase(sl()));
  sl.registerSingleton<FilterEpisodesUseCase>(FilterEpisodesUseCase(sl()));
  sl.registerSingleton<GetMoreEpisodesUseCase>(GetMoreEpisodesUseCase(sl()));
  sl.registerSingleton<FilterMoreEpisodesUseCase>(
      FilterMoreEpisodesUseCase(sl()));

  // Blocs
  sl.registerFactory<CharacterBloc>(
      () => CharacterBloc(sl(), sl(), sl(), sl(), sl()));

  sl.registerFactory<EpisodeBloc>(
      () => EpisodeBloc(sl(), sl(), sl(), sl(), sl()));
}
