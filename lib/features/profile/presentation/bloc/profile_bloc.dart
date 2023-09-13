import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rickandmorty/core/resources/data/data_state.dart';
import 'package:rickandmorty/features/UAA/authentication/domain/entities/user_entity.dart';
import 'package:rickandmorty/features/UAA/authentication/domain/repositories/authentication_repository.dart';
import 'package:rickandmorty/features/UAA/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:rickandmorty/features/profile/domain/entities/user_profile_level.dart';
import 'package:rickandmorty/features/profile/domain/usecases/profile_usecases.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthenticationRepository _authenticationRepository;
  late final StreamSubscription<UserEntity> _userSubscription;

  final ProfileGetLevelUsecase _getLevelUsecase;
  final ProfileDeleteUserUsecase _deleteUserUsecase;
  final ProfileLogoutUsecase _logoutUsecase;

  ProfileBloc(this._authenticationRepository, this._getLevelUsecase,
      this._deleteUserUsecase, this._logoutUsecase)
      : super(const ProfileInitial()) {
    on<ProfileAuthStateDidChange>(_onAuthStateDidChange);
    on<ProfileLogoutButtonTapped>(_onLogoutButtonTapped);
    on<ProfileDeleteAccountRequested>(_onDeleteAccountRequested);

    _userSubscription =
        _authenticationRepository.userStream.listen((userEntity) {
      add(ProfileAuthStateDidChange(userEntity.isNotEmpty
          ? AuthenticationState.authenticated(userEntity)
          : const AuthenticationState.unauthenticated()));
    });
  }

  @override
  Future<void> close() async {
    await _userSubscription.cancel();
    await super.close();
  }

  FutureOr<void> _onAuthStateDidChange(
      ProfileAuthStateDidChange event, Emitter<ProfileState> emit) async {
    switch (event.authenticationState.status) {
      case AuthenticationStatus.unauthenticated:
        emit(const ProfileLoaded(UserProfileLevel.guest()));
        break;
      case AuthenticationStatus.authenticated:
        final dataState = await _getLevelUsecase();
        if (dataState is DataSuccess && !(dataState.data?.isGuest ?? true)) {
          emit(ProfileLoaded(dataState.data!));
        } else {
          emit(ProfileFailed(state.userProfileLevel,
              reason: ProfileFailedReason.other,
              errorMessage: dataState.errorMessage));
        }
        break;
      case AuthenticationStatus.unknown:
        emit(ProfileFailed(state.userProfileLevel,
            reason: ProfileFailedReason.unknownAuth));
        break;
    }
  }

  FutureOr<void> _onLogoutButtonTapped(
      ProfileLogoutButtonTapped event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading(state.userProfileLevel));
    await _logoutUsecase();
  }

  FutureOr<void> _onDeleteAccountRequested(
      ProfileDeleteAccountRequested event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading(state.userProfileLevel));
    final dataState = await _deleteUserUsecase();

    if (dataState is DataSuccess) {
      await _logoutUsecase();
    } else {
      emit(ProfileFailed(state.userProfileLevel,
          reason: ProfileFailedReason.other,
          errorMessage: dataState.errorMessage));
    }
  }
}
