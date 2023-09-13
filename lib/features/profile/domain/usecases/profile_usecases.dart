import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rickandmorty/core/resources/data/data_state.dart';
import 'package:rickandmorty/core/usecase/usecase.dart';
import 'package:rickandmorty/features/UAA/authentication/domain/entities/user_entity.dart';
import 'package:rickandmorty/features/UAA/authentication/domain/repositories/authentication_repository.dart';
import 'package:rickandmorty/features/profile/domain/entities/user_profile_level.dart';
import 'package:rickandmorty/features/profile/domain/repositories/profile_repository.dart';

final class ProfileAddUserUsecase
    implements UseCase<DataState<void>, UserEntity> {
  final ProfileRepository _profileRepository;
  const ProfileAddUserUsecase(this._profileRepository);

  @override
  Future<DataState<void>> call({UserEntity? params}) async {
    final dataState = await _profileRepository.addUser(params!);
    return dataState;
  }
}

final class ProfileGetUserUsecase
    implements UseCase<DataState<UserEntity>, void> {
  final ProfileRepository _profileRepository;
  const ProfileGetUserUsecase(this._profileRepository);

  @override
  Future<DataState<UserEntity>> call({void params}) async {
    final dataState = await _profileRepository.getUser();
    return dataState;
  }
}

final class ProfileGetLevelUsecase
    implements UseCase<DataState<UserProfileLevel>, void> {
  final ProfileRepository _profileRepository;
  const ProfileGetLevelUsecase(this._profileRepository);

  @override
  Future<DataState<UserProfileLevel>> call({void params}) async {
    final dataState = await _profileRepository.getUserProfileLevel();
    return dataState;
  }
}

final class ProfileDeleteUserUsecase implements UseCase<DataState<void>, void> {
  final ProfileRepository _profileRepository;
  final AuthenticationRepository _authenticationRepository;
  const ProfileDeleteUserUsecase(
      this._profileRepository, this._authenticationRepository);

  @override
  Future<DataState<void>> call({void params}) async {
    final dataState = await _profileRepository.deleteUser();

    if (dataState is DataSuccess) {
      try {
        await _authenticationRepository.delete();
        return const DataSuccess();
      } on FirebaseAuthException catch (e) {
        return DataFailed.withMessage(e.message ?? e.code);
      } on TimeoutException {
        return const DataFailed.withMessage("Request timed out.");
      }
    } else {
      return dataState;
    }
  }
}

final class ProfileLogoutUsecase implements UseCase<void, void> {
  final AuthenticationRepository _authenticationRepository;
  const ProfileLogoutUsecase(this._authenticationRepository);

  @override
  Future<void> call({void params}) async {
    try {
      await _authenticationRepository.logout();
    } catch (_) {}
  }
}

final class ProfileChangeProfileImageUsecase
    implements UseCase<DataState<void>, XFile> {
  final ProfileRepository _profileRepository;
  const ProfileChangeProfileImageUsecase(this._profileRepository);

  @override
  Future<DataState<void>> call({XFile? params}) async {
    DataState dataState = await _profileRepository.uploadImageToBucket(params!);

    if (dataState is DataFailed) return dataState;

    dataState = await _profileRepository.updateUserWith(
        profileImageUrl: dataState.data);

    return dataState;
  }
}
