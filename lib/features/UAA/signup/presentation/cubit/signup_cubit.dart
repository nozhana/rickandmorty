import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rickandmorty/core/resources/data/data_state.dart';
import 'package:rickandmorty/features/UAA/authentication/domain/entities/user_entity.dart';
import 'package:rickandmorty/features/UAA/authentication/domain/repositories/authentication_repository.dart';
import 'package:rickandmorty/features/profile/domain/repositories/profile_repository.dart';
part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthenticationRepository _authenticationRepository;
  final ProfileRepository _profileRepository;

  SignupCubit(this._authenticationRepository, this._profileRepository)
      : super(const SignupIdle());

  FutureOr<void> submitSignup(String email, String password,
      {String? fullName}) async {
    final currentUser = _authenticationRepository.currentUser;
    if (currentUser.isNotEmpty) return;

    emit(const SignupInProgress());

    try {
      final userCredential = await _authenticationRepository.signup(
          email: email, password: password, fullName: fullName);
      if (userCredential.user == null) return;
      final dataState = await _profileRepository.addUser(UserEntity(
          id: userCredential.user!.uid, email: email, fullName: fullName));

      if (dataState is DataSuccess) {
        emit(const SignupDone());
      } else {
        emit(SignupFailed(FirebaseAuthException(
            code: "storing-to-db-failed",
            message: "Failed to store user to database.")));
      }
    } on FirebaseAuthException catch (e) {
      emit(SignupFailed(e));
      return;
    } on TimeoutException {
      emit(const SignupTimedOut());
      return;
    }
  }
}
