part of 'signup_cubit.dart';

sealed class SignupState extends Equatable {
  const SignupState();

  @override
  List<Object> get props => [];
}

final class SignupIdle extends SignupState {
  const SignupIdle();
}

final class SignupInProgress extends SignupState {
  const SignupInProgress();
}

final class SignupDone extends SignupState {
  const SignupDone();
}

final class SignupFailed extends SignupState {
  final FirebaseAuthException exception;
  const SignupFailed(this.exception);
}

final class SignupTimedOut extends SignupState {
  const SignupTimedOut();
}
