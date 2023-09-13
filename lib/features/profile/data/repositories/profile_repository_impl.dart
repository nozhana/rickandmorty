import 'package:firebase_auth/firebase_auth.dart';
import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rickandmorty/core/firestore/firestore_database.dart';
import 'package:rickandmorty/core/resources/data/data_state.dart';
import 'package:rickandmorty/features/UAA/authentication/data/models/user_model.dart';
import 'package:rickandmorty/features/UAA/authentication/domain/entities/user_entity.dart';
import 'package:rickandmorty/features/UAA/authentication/domain/repositories/authentication_repository.dart';
import 'package:rickandmorty/features/profile/data/datasources/user_profile_image_bucket.dart';
import 'package:rickandmorty/features/profile/domain/entities/user_profile_level.dart';
import 'package:rickandmorty/features/profile/domain/repositories/profile_repository.dart';
import 'package:velocity_x/velocity_x.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final AuthenticationRepository _authenticationRepository;
  final FirestoreDatabase _database;
  final UserProfileImageBucket _imageBucket;

  const ProfileRepositoryImpl(
      this._authenticationRepository, this._database, this._imageBucket);

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
        return const DataSuccess();
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
  Future<DataState<void>> updateUserWith(
      {String? email, String? fullName, String? profileImageUrl}) async {
    if (_authenticationRepository.currentUser.isNotEmpty) {
      try {
        final documentId = await _database.getDocumentIdByField(
            collectionPath: "users",
            field: "id",
            match: _authenticationRepository.currentUser.id);
        if (documentId.isNotEmptyAndNotNull) {
          final dataState = await getUser();
          if (dataState is DataSuccess) {
            await _database.setObject<UserEntity>(
                collectionPath: "users",
                documentId: documentId!,
                data: UserModel.fromUserEntity(dataState.data!).copyWith(
                    email: email,
                    fullName: fullName,
                    profileImageUrl: profileImageUrl),
                objectEncoder: (object) =>
                    UserModel.fromUserEntity(object).toJson());
          } else {
            return dataState;
          }
        } else {
          return const DataFailed.withMessage("User not found.");
        }
        return const DataSuccess();
      } on FirebaseException catch (e) {
        return DataFailed.withMessage(e.message ?? e.code);
      }
    }
    return const DataFailed.withMessage("User not authenticated.");
  }

  @override
  Future<DataState<String>> uploadImageToBucket(XFile xFile) async {
    if (_authenticationRepository.currentUser.isNotEmpty) {
      final inputBytes = await xFile.readAsBytes();
      final image = decodeImage(inputBytes);

      if (image?.isNotEmpty ?? false) {
        final thumbnail = copyResizeCropSquare(image!, size: 512);
        final data = encodePng(thumbnail);
        return await _imageBucket.uploadImagePngRawData(
            data, _authenticationRepository.currentUser.id);
      }
      return const DataFailed.withMessage("Couldn't decode selected photo.");
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
      } on FirebaseException catch (e) {
        return DataFailed.withMessage(e.message ?? e.code);
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
