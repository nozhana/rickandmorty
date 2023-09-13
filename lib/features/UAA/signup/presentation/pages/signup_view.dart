import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rickandmorty/core/resources/widgets/appbar/base_app_bar.dart';
import 'package:rickandmorty/features/UAA/signup/presentation/cubit/signup_cubit.dart';
import 'package:rickandmorty/features/UAA/signup/presentation/widgets/signup_form.dart';
import 'package:rickandmorty/injection_container.dart';
import 'package:velocity_x/velocity_x.dart';

class SignupView extends StatelessWidget {
  SignupView({super.key});

  final nameTextEditingController = TextEditingController();
  final emailTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() =>
      BaseAppBar(title: "Sign up".text.make());

  Widget _buildBody() {
    Function? toastCloser;

    return BlocProvider<SignupCubit>(
      create: (context) => sl(),
      child: BlocConsumer<SignupCubit, SignupState>(
        listener: (context, state) {
          if (state is SignupInProgress) {
            toastCloser = context.showLoading(msg: "Please wait");
          } else if (toastCloser != null) {
            toastCloser?.call();
            toastCloser = null;
          }
          if (state is SignupDone) {
            context.beamToNamed('/profile');
            context.showToast(
                msg: "Registration successful.",
                position: VxToastPosition.center);
          }
          if (state is SignupFailed) {
            context.showToast(
                msg: state.exception.message ?? "Sign up failed.",
                position: VxToastPosition.center);
          }
        },
        builder: (context, state) {
          return [
            "Enter your email and password to create an account."
                .text
                .makeCentered()
                .px16()
                .py32(),
            SignupForm(
              nameTextEditingController: nameTextEditingController,
              emailTextEditingController: emailTextEditingController,
              passwordTextEditingController: passwordTextEditingController,
              onSubmitForm: (() => context.read<SignupCubit>().submitSignup(
                  emailTextEditingController.text,
                  passwordTextEditingController.text,
                  fullName: nameTextEditingController.text)),
            ).px32().constrainedBox(const BoxConstraints.tightFor(width: 640)),
          ]
              .vStack(
                  axisSize: MainAxisSize.min,
                  alignment: MainAxisAlignment.spaceAround)
              .scrollVertical()
              .constrainedBox(const BoxConstraints.tightFor(height: 429))
              .centered();
        },
      ),
    );
  }
}
