import 'package:beamer/beamer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rickandmorty/core/exceptions/io_exceptions.dart';
import 'package:rickandmorty/core/extensions/string_extension.dart';
import 'package:rickandmorty/core/navigation/widgets/base_navigatable_scaffold.dart';
import 'package:rickandmorty/core/resources/views/error/error_view.dart';
import 'package:rickandmorty/core/resources/widgets/appbar/base_app_bar.dart';
import 'package:rickandmorty/core/resources/widgets/switches/light_switch.dart';
import 'package:rickandmorty/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:rickandmorty/injection_container.dart';
import 'package:velocity_x/velocity_x.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  Function? closeToast;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>(
      create: (context) => sl(),
      child: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoading) {
            closeToast = context.showLoading(
                msg: "Please wait...",
                bgColor: Theme.of(context).colorScheme.primaryContainer,
                textColor: Theme.of(context).colorScheme.onPrimaryContainer);
          } else {
            if (closeToast != null) {
              closeToast!();
              closeToast = null;
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
          floatingActionButton:
              context.screenWidth <= BaseNavigatableScaffold.breakingPoint
                  ? FloatingActionButton(
                      onPressed: () {}, child: const LightSwitch())
                  : null,
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
        _buildAvatar(context, state, maxRadius: 64),
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
        [
          _buildNameTag(state, context,
                  crossAxisAlignment: CrossAxisAlignment.start)
              .expand(),
          _buildAvatar(context, state, popUpOffset: const Offset(-32, 32)),
        ].hStack(alignment: MainAxisAlignment.spaceBetween),
        64.heightBox,
        _buildLogoutButton(context),
      ].vStack(axisSize: MainAxisSize.min).px16();

  ElevatedButton _buildLogoutButton(BuildContext context) {
    return ElevatedButton(
        onPressed: () =>
            context.read<ProfileBloc>().add(const ProfileLogoutButtonTapped()),
        child:
            "Log out".text.bold.color(Theme.of(context).primaryColor).make());
  }

  Widget _buildNameTag(ProfileState state, BuildContext context,
      {CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center}) {
    return [
      (state.currentUser.fullName ?? "Anonymous")
          .sentenceCased
          .text
          .maxLines(3)
          .overflow(TextOverflow.fade)
          .xl3
          .make(),
      (state.currentUser.email ?? "*****")
          .text
          .lg
          .color(Theme.of(context).disabledColor)
          .make(),
    ]
        .map((e) => e.py4())
        .toList()
        .vStack(axisSize: MainAxisSize.min, crossAlignment: crossAxisAlignment);
  }

  Widget _buildAvatar(BuildContext context, ProfileState state,
      {double maxRadius = 32, Offset popUpOffset = Offset.zero}) {
    return PopupMenuButton(
      enabled: state.currentUser.isNotEmpty,
      splashRadius: 0,
      tooltip: state.currentUser.isNotEmpty ? "Choose a new profile photo" : "",
      itemBuilder: (context) => [
        (Icons.photo_library, "Choose from photos"),
        if (!kIsWeb) (Icons.camera_alt, "Take picture")
      ]
          .map((element) => PopupMenuItem(
              onTap: () async {
                final imageSource = element.$1 == Icons.photo_library
                    ? ImageSource.gallery
                    : ImageSource.camera;

                XFile? pickedImageXFile;

                try {
                  pickedImageXFile =
                      await ImagePicker().pickImage(source: imageSource);
                  if (pickedImageXFile == null) {
                    throw ImagePickerException(imageSource,
                        message: "Failed to retrieve image data.");
                  }
                } on PlatformException catch (e) {
                  context.showToast(
                      msg: e.message ?? e.code,
                      position: VxToastPosition.center,
                      bgColor: Theme.of(context).colorScheme.errorContainer,
                      textColor:
                          Theme.of(context).colorScheme.onErrorContainer);
                  return;
                } on ImagePickerException catch (e) {
                  context.showToast(
                      msg: e.message ?? "${e.runtimeType}",
                      position: VxToastPosition.center,
                      bgColor: Theme.of(context).colorScheme.errorContainer,
                      textColor:
                          Theme.of(context).colorScheme.onErrorContainer);
                  return;
                }

                BlocProvider.of<ProfileBloc>(context)
                    .add(ProfileChangeProfileImageRequested(pickedImageXFile));
              },
              child: [Icon(element.$1), 16.widthBox, element.$2.text.make()]
                  .hStack()))
          .toList(),
      constraints: BoxConstraints.tightFor(
          width: context.screenWidth > BaseNavigatableScaffold.breakingPoint
              ? 300
              : 250),
      offset: popUpOffset,
      child: CircleAvatar(
          maxRadius: maxRadius,
          backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
          backgroundImage: state.currentUser.profileImageUrl.isEmptyOrNull
              ? null
              : CachedNetworkImageProvider(state.currentUser.profileImageUrl!),
          child: state.currentUser.profileImageUrl.isEmptyOrNull
              ? Icon(
                  state.currentUser.isEmpty
                      ? Icons.person_outline
                      : Icons.cloud_upload,
                  size: maxRadius / 1.5,
                )
              : null),
    );
  }

  PreferredSizeWidget _buildAppBar() => BaseAppBar(
        title: "Profile".text.make(),
      );
}
