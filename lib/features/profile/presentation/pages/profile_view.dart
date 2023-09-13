import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rickandmorty/core/extensions/string_extension.dart';
import 'package:rickandmorty/core/resources/views/error/error_view.dart';
import 'package:rickandmorty/core/resources/widgets/appbar/base_app_bar.dart';
import 'package:rickandmorty/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:rickandmorty/injection_container.dart';
import 'package:velocity_x/velocity_x.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  Function? toastCloser;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>(
      create: (context) => sl(),
      child: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoading) {
            toastCloser = context.showLoading(msg: "Please wait");
          } else {
            if (toastCloser != null) {
              toastCloser?.call();
              toastCloser = null;
            }
          }

          if (state is ProfileFailed &&
              state.errorMessage.isNotEmptyAndNotNull) {
            context.showToast(
                msg: state.errorMessage!,
                position: VxToastPosition.center,
                bgColor: Theme.of(context).colorScheme.errorContainer,
                textColor: Theme.of(context).colorScheme.onErrorContainer);
          }
        },
        child: Scaffold(
          appBar: _buildAppBar(),
          body: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) =>
                state is ProfileLoaded || state is ProfileLoading
                    ? state.userProfileLevel.isGuest
                        ? _buildGuestView(context, state)
                        : _buildProfileView(context, state)
                    : state is ProfileInitial
                        ? _buildClearView()
                        : _buildErrorView(state as ProfileFailed),
          ),
        ),
      ),
    );
  }

  Widget _buildGuestView(BuildContext context, ProfileState state) => [
        CircleAvatar(
            maxRadius: context.mq.size.shortestSide / 8,
            backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
            child: Icon(
              Icons.person,
              size: context.mq.size.shortestSide / 8,
            )),
        "You are not logged in.".text.xl.make(),
        [
          ElevatedButton.icon(
              onPressed: () => context.beamToNamed('/signup'),
              icon: const Icon(Icons.person_add_alt_1),
              label: "Sign up with Email".text.bold.make()),
          ElevatedButton.icon(
              onPressed: () => context.beamToNamed('/login'),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll(Theme.of(context).cardColor),
                  surfaceTintColor:
                      const MaterialStatePropertyAll(Colors.transparent),
                  shape: MaterialStatePropertyAll(StadiumBorder(
                      side: BorderSide(
                          color: Theme.of(context).primaryColor.withAlpha(45),
                          width: 2.0)))),
              icon: const Icon(Icons.person),
              label: "Log in".text.bold.make()),
        ].map((e) => e.py8()).toList().vStack(axisSize: MainAxisSize.min),
      ]
          .map((e) => e.py16())
          .toList()
          .vStack(axisSize: MainAxisSize.min)
          .centered();

  Widget _buildClearView() => Container().hide();

  Widget _buildErrorView(ProfileFailed state) => ErrorView(
      errorMessage: state.errorMessage ?? "Error loading Profile info.");

  Widget _buildProfileView(BuildContext context, ProfileState state) => [
        CircleAvatar(
            maxRadius: context.mq.size.shortestSide / 8,
            backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
            child: const Icon(Icons.person)),
        (state.currentUser.fullName ?? "Anonymous").titleCased.text.xl2.make(),
        [
          "ID:".text.xl.bold.color(Theme.of(context).disabledColor).make(),
          (state.currentUser.id).selectableText.xl.make(),
        ].map((e) => e.px12()).toList().hStack(axisSize: MainAxisSize.min),
        ElevatedButton(
            onPressed: () => context
                .read<ProfileBloc>()
                .add(const ProfileLogoutButtonTapped()),
            child: "Log out"
                .text
                .bold
                .color(Theme.of(context).primaryColor)
                .make()),
      ]
          .map((e) => e.py16())
          .toList()
          .vStack(axisSize: MainAxisSize.min)
          .centered();

  PreferredSizeWidget _buildAppBar() => BaseAppBar(
        title: "Profile".text.make(),
      );
}
