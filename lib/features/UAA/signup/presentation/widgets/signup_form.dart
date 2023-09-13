import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class SignupForm extends StatefulWidget {
  SignupForm(
      {super.key,
      required this.emailTextEditingController,
      required this.passwordTextEditingController,
      required this.nameTextEditingController,
      required this.onSubmitForm});

  final formKey = GlobalKey<FormState>();
  final TextEditingController nameTextEditingController;
  final TextEditingController emailTextEditingController;
  final TextEditingController passwordTextEditingController;
  final void Function() onSubmitForm;

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: <Widget>[
        TextFormField(
          controller: widget.nameTextEditingController,
          decoration: const InputDecoration.collapsed(
            hintText: "Full Name",
            border: UnderlineInputBorder(),
          ),
          validator: (value) => (value ?? '').split(' ').count() < 2
              ? "Enter your first and last name, separated by a space."
              : null,
          onTapOutside: _defocus,
        ),
        TextFormField(
          controller: widget.emailTextEditingController,
          decoration: const InputDecoration.collapsed(
            hintText: "Email",
            border: UnderlineInputBorder(),
          ),
          validator: (value) =>
              value.isEmptyOrNull ? "Please enter your email." : null,
          onTapOutside: _defocus,
        ),
        TextFormField(
          controller: widget.passwordTextEditingController,
          decoration: const InputDecoration.collapsed(
            hintText: "Password",
            border: UnderlineInputBorder(),
          ),
          obscureText: true,
          validator: (value) {
            if (value.isEmptyOrNull) return "Please enter a password.";
            if (value!.length < 8) {
              return "Your password is too short.";
            }
            if (!value.contains(RegExp(r'[a-z]'))) {
              return "Include at least one lowercase character.";
            }
            if (!value.contains(RegExp(r'[A-Z]'))) {
              return "Include at least one uppercase character.";
            }
            if (!value.contains(RegExp(r'\d+'))) {
              return "Include at least one digit.";
            }
            return null;
          },
          onTapOutside: _defocus,
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.person_add_alt_1),
          label: "Sign up".text.make(),
          onPressed: () async {
            if (widget.formKey.currentState!.validate()) widget.onSubmitForm();
          },
        ),
      ]
          .map((e) => e.py32())
          .toList()
          .vStack(axisSize: MainAxisSize.min)
          .centered(),
    );
  }

  void _defocus(PointerDownEvent event) {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
