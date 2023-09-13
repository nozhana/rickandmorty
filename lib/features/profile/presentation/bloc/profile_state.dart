part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  final UserProfileLevel userProfileLevel;
  const ProfileState(UserProfileLevel? userProfileLevel)
      : userProfileLevel = userProfileLevel ?? const UserProfileLevel.guest();

  UserEntity get currentUser => userProfileLevel.userEntity;

  @override
  List<Object> get props => [userProfileLevel];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial() : super(const UserProfileLevel.guest());
}

class ProfileLoading extends ProfileState {
  const ProfileLoading(super.userProfileLevel);
}

class ProfileLoaded extends ProfileState {
  const ProfileLoaded(UserProfileLevel userProfileLevel)
      : super(userProfileLevel);
}

class ProfileFailed extends ProfileState {
  final ProfileFailedReason reason;
  final String? errorMessage;
  const ProfileFailed(super.userProfileLevel,
      {this.reason = ProfileFailedReason.other, this.errorMessage});
}

enum ProfileFailedReason { unknownAuth, timedOut, other }
