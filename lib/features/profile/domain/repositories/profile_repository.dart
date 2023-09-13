import 'package:rickandmorty/core/resources/data/data_state.dart';
import 'package:rickandmorty/features/UAA/authentication/domain/entities/user_entity.dart';
import 'package:rickandmorty/features/profile/domain/entities/user_profile_level.dart';

abstract class ProfileRepository {
  Future<DataState<UserEntity>> getUser();
  Future<DataState<UserProfileLevel>> getUserProfileLevel();
  Future<DataState<void>> addUser(UserEntity userEntity);
  Future<DataState<void>> deleteUser();
  Stream<UserEntity> get userStream;
  Stream<UserProfileLevel> get userProfileLevelStream;
}
