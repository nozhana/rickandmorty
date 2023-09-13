import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:rickandmorty/core/constants/constants.dart' as constants;
import 'package:rickandmorty/core/database/app_database.dart';
import 'package:rickandmorty/core/firestore/firestore_database.dart';
import 'package:rickandmorty/core/utils/logger.dart';
import 'package:rickandmorty/features/UAA/authentication/data/repositories/authentication_repository_impl.dart';
import 'package:rickandmorty/features/UAA/authentication/domain/repositories/authentication_repository.dart';
import 'package:rickandmorty/features/UAA/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:rickandmorty/features/UAA/login/presentation/cubit/login_cubit.dart';
import 'package:rickandmorty/features/UAA/signup/presentation/cubit/signup_cubit.dart';
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
import 'package:rickandmorty/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:rickandmorty/features/profile/domain/repositories/profile_repository.dart';
import 'package:rickandmorty/features/profile/domain/usecases/profile_usecases.dart';
import 'package:rickandmorty/features/profile/presentation/bloc/profile_bloc.dart';

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

  // Firestore
  sl.registerSingleton<FirestoreDatabase>(FirestoreDatabase());

  // Dio
  sl.registerSingleton<Dio>(Dio());

  // Services
  sl.registerSingleton<CharacterApiService>(CharacterApiService(sl()));
  sl.registerSingleton<EpisodeApiService>(EpisodeApiService(sl()));

  // Repositories
  sl.registerSingleton<CharacterRepository>(CharacterRepositoryImpl(sl()));
  sl.registerSingleton<EpisodeRepository>(EpisodeRepositoryImpl(sl()));
  sl.registerSingleton<AuthenticationRepository>(
      AuthenticationRepositoryImpl(firebaseAuth: FirebaseAuth.instance));
  sl.registerSingleton<ProfileRepository>(ProfileRepositoryImpl(sl(), sl()));

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

  sl.registerSingleton<ProfileAddUserUsecase>(ProfileAddUserUsecase(sl()));
  sl.registerSingleton<ProfileGetUserUsecase>(ProfileGetUserUsecase(sl()));
  sl.registerSingleton<ProfileGetLevelUsecase>(ProfileGetLevelUsecase(sl()));
  sl.registerSingleton<ProfileLogoutUsecase>(ProfileLogoutUsecase(sl()));
  sl.registerSingleton<ProfileDeleteUserUsecase>(
      ProfileDeleteUserUsecase(sl(), sl()));

  // Blocs
  sl.registerFactory<CharacterBloc>(
      () => CharacterBloc(sl(), sl(), sl(), sl(), sl()));
  sl.registerFactory<EpisodeBloc>(
      () => EpisodeBloc(sl(), sl(), sl(), sl(), sl()));
  sl.registerFactory<AuthenticationBloc>(() => AuthenticationBloc(sl()));
  sl.registerFactory<ProfileBloc>(() => ProfileBloc(sl(), sl(), sl(), sl()));

  // Cubits
  sl.registerFactory<SignupCubit>(() => SignupCubit(sl(), sl()));
  sl.registerFactory<LoginCubit>(() => LoginCubit(sl()));
}
