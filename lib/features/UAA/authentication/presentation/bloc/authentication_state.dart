part of 'authentication_bloc.dart';

enum AuthenticationStatus { authenticated, unauthenticated, unknown }

class AuthenticationState extends Equatable {
  const AuthenticationState._(
      {required this.status, this.userEntity = UserEntity.empty});

  final AuthenticationStatus status;
  final UserEntity userEntity;

  @override
  List<Object> get props => [status, userEntity];

  const AuthenticationState.authenticated(UserEntity userEntity)
      : this._(
            status: AuthenticationStatus.authenticated, userEntity: userEntity);

  const AuthenticationState.unauthenticated()
      : this._(status: AuthenticationStatus.unauthenticated);

  const AuthenticationState.unknown()
      : this._(status: AuthenticationStatus.unknown);

  factory AuthenticationState.fromJson(Map<String, dynamic> json) =>
      AuthenticationState._(
          status: (json['status'] as String)._toAuthenticationStatus,
          userEntity: json['userEntity']);

  Map<String, dynamic> toJson() => {
        'status': status.name,
        'userEntity': UserModel.fromUserEntity(userEntity)
      };
}

extension on String {
  AuthenticationStatus get _toAuthenticationStatus {
    switch (this) {
      case 'authenticated':
        return AuthenticationStatus.authenticated;
      case 'unauthenticated':
        return AuthenticationStatus.unauthenticated;
      case 'unknown':
      default:
        return AuthenticationStatus.unknown;
    }
  }
}
