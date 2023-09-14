import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:rickandmorty/features/UAA/authentication/domain/repositories/authentication_repository.dart';
import 'package:rickandmorty/features/UAA/login/presentation/pages/login_view.dart';
import 'package:rickandmorty/features/UAA/signup/presentation/pages/signup_view.dart';
import 'package:rickandmorty/features/profile/presentation/pages/profile_view.dart';
import 'package:rickandmorty/injection_container.dart';

class ProfileBeamLocation extends BeamLocation {
  @override
  List<BeamGuard> get guards => [
        BeamGuard(
            pathBlueprints: ['/signup', '/login'],
            check: _isGuest,
            beamToNamed: '/profile'),
      ];

  @override
  List<BeamPage> pagesBuilder(BuildContext context, BeamState state) =>
      <BeamPage>[
        BeamPage(
            key: const ValueKey("profile"),
            name: "Profile",
            type: BeamPageType.noTransition,
            child: const ProfileView()),
        if (state.pathBlueprintSegments.contains('signup'))
          BeamPage(
              key: const ValueKey("signup"),
              name: "Signup",
              type: BeamPageType.material,
              child: SignupView()),
        if (state.pathBlueprintSegments.contains('login'))
          BeamPage(
              key: const ValueKey("login"),
              name: "Login",
              type: BeamPageType.material,
              child: LoginView()),
      ];

  @override
  List<String> get pathBlueprints => ['/profile', '/signup', '/login'];

  bool _isGuest(BuildContext context, BeamLocation location) =>
      sl<AuthenticationRepository>().currentUser.isEmpty;
}
