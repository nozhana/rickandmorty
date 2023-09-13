part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationDidRequestLogout extends AuthenticationEvent {}

class AuthenticationUserDidChange extends AuthenticationEvent {
  const AuthenticationUserDidChange({required this.userEntity});
  final UserEntity userEntity;
}
