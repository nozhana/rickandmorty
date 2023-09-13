import 'package:firebase_auth/firebase_auth.dart';
import 'package:rickandmorty/features/UAA/authentication/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel(
      {required super.id, super.email, super.fullName, super.profileImageUrl});

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map["id"] ?? "",
      email: map["email"],
      fullName: map["fullName"],
      profileImageUrl: map["profileImageUrl"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "email": email,
      "fullName": fullName,
      "profileImageUrl": profileImageUrl,
    };
  }

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
        id: user.uid,
        email: user.email,
        fullName: user.displayName,
        profileImageUrl: user.photoURL);
  }

  factory UserModel.fromUserEntity(UserEntity userEntity) => UserModel(
      id: userEntity.id,
      email: userEntity.email,
      fullName: userEntity.fullName,
      profileImageUrl: userEntity.profileImageUrl);

  UserModel copyWith(
          {String? id,
          String? email,
          String? fullName,
          String? profileImageUrl}) =>
      UserModel(
          id: id ?? this.id,
          email: email ?? this.email,
          fullName: fullName ?? this.fullName,
          profileImageUrl: profileImageUrl ?? this.profileImageUrl);
}
