import 'package:equatable/equatable.dart';
import 'package:rickandmorty/features/UAA/authentication/domain/entities/user_entity.dart';

class UserProfileLevel extends Equatable {
  final UserEntity userEntity;

  const UserProfileLevel._(this.userEntity);

  const UserProfileLevel.guest() : this._(UserEntity.empty);

  const UserProfileLevel.loggedIn(UserEntity userEntity) : this._(userEntity);

  bool get isGuest => userEntity.isEmpty;

  @override
  List<Object?> get props => [userEntity];
}
