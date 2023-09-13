import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rickandmorty/core/resources/widgets/appbar/base_app_bar.dart';
import 'package:rickandmorty/features/UAA/login/presentation/cubit/login_cubit.dart';
import 'package:rickandmorty/features/UAA/login/presentation/widgets/login_form.dart';
import 'package:rickandmorty/injection_container.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final emailTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() => BaseAppBar(title: "Login".text.make());

  Widget _buildBody() {
    Function? toastCloser;

    return BlocProvider<LoginCubit>(
      create: (context) => sl(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginInProgress) {
            toastCloser = context.showLoading(msg: "Please wait");
          } else if (toastCloser != null) {
            toastCloser?.call();
            toastCloser = null;
          }
          if (state is LoginDone) {
            context.beamToNamed('/profile');
            context.showToast(
                msg: "You're now logged in.", position: VxToastPosition.center);
          }
          if (state is LoginFailed) {
            context.showToast(
                msg: state.exception.message ?? "Login failed.",
                position: VxToastPosition.center);
          }
        },
        builder: (context, state) {
          return [
            "Enter your email and password to login."
                .text
                .makeCentered()
                .px16()
                .py32(),
            LoginForm(
              emailTextEditingController: emailTextEditingController,
              passwordTextEditingController: passwordTextEditingController,
              onSubmitForm: (() => context.read<LoginCubit>().submitLogin(
                  emailTextEditingController.text,
                  passwordTextEditingController.text)),
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
