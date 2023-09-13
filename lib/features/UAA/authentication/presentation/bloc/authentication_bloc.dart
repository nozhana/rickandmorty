import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rickandmorty/features/UAA/authentication/data/models/user_model.dart';
import 'package:rickandmorty/features/UAA/authentication/domain/entities/user_entity.dart';
import 'package:rickandmorty/features/UAA/authentication/domain/repositories/authentication_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends HydratedBloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc(AuthenticationRepository authenticationRepository)
      : _authenticationRepository = authenticationRepository,
        super(const AuthenticationState.unknown()) {
    on<AuthenticationDidRequestLogout>(_onLogoutRequested);
    on<AuthenticationUserDidChange>(_onUserChanged);

    _userSubscription = _authenticationRepository.userStream.listen(
        (userEntity) =>
            add(AuthenticationUserDidChange(userEntity: userEntity)));
  }

  final AuthenticationRepository _authenticationRepository;
  StreamSubscription<UserEntity>? _userSubscription;

  @override
  Future<void> close() async {
    await _userSubscription?.cancel();
    return super.close();
  }

  @override
  AuthenticationState? fromJson(Map<String, dynamic> json) {
    return json['state'] as AuthenticationState?;
  }

  @override
  Map<String, dynamic>? toJson(AuthenticationState state) {
    return {'state': state};
  }

  void _onLogoutRequested(
    AuthenticationDidRequestLogout event,
    Emitter<AuthenticationState> emit,
  ) async {
    await _authenticationRepository.logout();
    emit(const AuthenticationState.unauthenticated());
  }

  void _onUserChanged(
    AuthenticationUserDidChange event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(event.userEntity.isNotEmpty
        ? AuthenticationState.authenticated(event.userEntity)
        : const AuthenticationState.unauthenticated());
  }
}
