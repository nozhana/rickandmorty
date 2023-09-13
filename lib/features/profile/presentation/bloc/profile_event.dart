part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class ProfileLogoutButtonTapped extends ProfileEvent {
  const ProfileLogoutButtonTapped();
}

class ProfileAuthStateDidChange extends ProfileEvent {
  final AuthenticationState authenticationState;
  const ProfileAuthStateDidChange(this.authenticationState);

  @override
  List<Object> get props => [authenticationState];
}

class ProfileDeleteAccountRequested extends ProfileEvent {
  const ProfileDeleteAccountRequested();
}

class ProfileChangeProfileImageRequested extends ProfileEvent {
  final XFile pickedImageXFile;
  const ProfileChangeProfileImageRequested(this.pickedImageXFile);

  @override
  List<Object> get props => [pickedImageXFile.name];
}
