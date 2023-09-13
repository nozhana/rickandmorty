part of 'login_cubit.dart';

sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

final class LoginIdle extends LoginState {
  const LoginIdle();
}

final class LoginInProgress extends LoginState {
  const LoginInProgress();
}

final class LoginDone extends LoginState {
  const LoginDone();
}

final class LoginFailed extends LoginState {
  final FirebaseAuthException exception;
  const LoginFailed(this.exception);
}

final class LoginTimedOut extends LoginState {
  const LoginTimedOut();
}
