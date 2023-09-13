import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rickandmorty/features/UAA/authentication/domain/repositories/authentication_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthenticationRepository _authenticationRepository;

  LoginCubit(this._authenticationRepository) : super(const LoginIdle());

  FutureOr<void> submitLogin(String email, String password) async {
    final currentUser = _authenticationRepository.currentUser;
    if (currentUser.isNotEmpty) return;

    emit(const LoginInProgress());

    try {
      await _authenticationRepository.login(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      emit(LoginFailed(e));
      return;
    } on TimeoutException {
      emit(const LoginTimedOut());
      return;
    }

    emit(const LoginDone());
  }
}
