import 'package:rickandmorty/core/firestore/firestore_database.dart';
import 'package:rickandmorty/core/resources/data/data_state.dart';
import 'package:rickandmorty/features/UAA/authentication/data/models/user_model.dart';
import 'package:rickandmorty/features/UAA/authentication/domain/entities/user_entity.dart';
import 'package:rickandmorty/features/UAA/authentication/domain/repositories/authentication_repository.dart';
import 'package:rickandmorty/features/profile/domain/entities/user_profile_level.dart';
import 'package:rickandmorty/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final AuthenticationRepository _authenticationRepository;
  final FirestoreDatabase _database;

  const ProfileRepositoryImpl(this._authenticationRepository, this._database);

  @override
  Future<DataState<void>> addUser(UserEntity userEntity) async {
    if (_authenticationRepository.currentUser.isNotEmpty &&
        _authenticationRepository.currentUser.id == userEntity.id) {
      try {
        await _database.addObject<UserEntity>(
            collectionPath: "users",
            data: userEntity,
            objectEncoder: (object) =>
                UserModel.fromUserEntity(object).toJson());
        return const DataSuccess(null);
      } catch (_) {
        return const DataFailed.withMessage("Failed to add user.");
      }
    }
    return const DataFailed.withMessage("User not authenticated.");
  }

  @override
  Future<DataState<void>> deleteUser() async {
    if (_authenticationRepository.currentUser.isNotEmpty) {
      try {
        await _database.deleteFirstDocumentByField(
            collectionPath: "users",
            field: "id",
            match: _authenticationRepository.currentUser.id);
      } catch (_) {
        return const DataFailed.withMessage("Failed to delete user.");
      }
    }
    return const DataFailed.withMessage("User not authenticated.");
  }

  @override
  Future<DataState<UserEntity>> getUser() async {
    if (_authenticationRepository.currentUser.isNotEmpty) {
      try {
        final userEntity = await _database.getObjectByField<UserEntity>(
            collectionPath: "users",
            field: "id",
            match: _authenticationRepository.currentUser.id,
            objectDecoder: (map) => UserModel.fromJson(map));
        return DataSuccess(userEntity ?? UserEntity.empty);
      } on Exception catch (e) {
        return DataFailed.withMessage(e.toString());
      }
    }
    return const DataSuccess(UserEntity.empty);
  }

  @override
  Future<DataState<UserProfileLevel>> getUserProfileLevel() async {
    final dataState = await getUser();

    if (dataState is DataSuccess) {
      return DataSuccess((dataState.data?.isEmpty ?? true)
          ? const UserProfileLevel.guest()
          : UserProfileLevel.loggedIn(dataState.data!));
    } else {
      return DataFailed.withMessage(dataState.errorMessage!);
    }
  }

  @override
  Stream<UserProfileLevel> get userProfileLevelStream => getUserProfileLevel()
      .asStream()
      .asyncMap((dataState) async => dataState is DataSuccess
          ? dataState.data!
          : const UserProfileLevel.guest());

  @override
  Stream<UserEntity> get userStream =>
      getUser().asStream().asyncMap((dataState) =>
          dataState is DataSuccess ? dataState.data! : UserEntity.empty);
}
