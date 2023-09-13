import 'package:firebase_auth/firebase_auth.dart';
import 'package:rickandmorty/features/UAA/authentication/data/models/user_model.dart';
import 'package:rickandmorty/features/UAA/authentication/domain/entities/user_entity.dart';
import 'package:rickandmorty/features/UAA/authentication/domain/repositories/authentication_repository.dart';
import 'package:velocity_x/velocity_x.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  AuthenticationRepositoryImpl({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;

  @override
  UserEntity get currentUser =>
      _firebaseAuth.currentUser?.toUserModel ?? UserEntity.empty;

  @override
  Stream<UserEntity> get userStream => _firebaseAuth.authStateChanges().map(
      (firebaseUser) => firebaseUser == null || firebaseUser.isAnonymous
          ? UserEntity.empty
          : firebaseUser.toUserModel);

  @override
  Future<UserCredential> login(
      {required String email, required String password}) async {
    return _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password)
        .timeout(const Duration(seconds: 10));
  }

  @override
  Future<UserCredential> signup(
      {required String email,
      required String password,
      String? fullName}) async {
    final userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .timeout(const Duration(seconds: 10));
    if (fullName.isNotEmptyAndNotNull) {
      await userCredential.user?.updateDisplayName(fullName);
    }
    return userCredential;
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut().timeout(const Duration(seconds: 10));
  }

  @override
  Future<void> delete() async {
    await _firebaseAuth.currentUser
        ?.delete()
        .timeout(const Duration(seconds: 10));
  }
}

extension on User {
  UserModel get toUserModel => UserModel.fromFirebaseUser(this);
}
