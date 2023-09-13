import 'package:firebase_auth/firebase_auth.dart';
import 'package:rickandmorty/features/UAA/authentication/domain/entities/user_entity.dart';

abstract class AuthenticationRepository {
  UserEntity get currentUser;
  Stream<UserEntity> get userStream;
  Future<UserCredential> login(
      {required String email, required String password});
  Future<UserCredential> signup(
      {required String email, required String password, String? fullName});
  Future<void> logout();
  Future<void> delete();
}
