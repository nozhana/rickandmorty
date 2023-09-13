import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginForm extends StatefulWidget {
  LoginForm(
      {super.key,
      required this.emailTextEditingController,
      required this.passwordTextEditingController,
      required this.onSubmitForm});

  final formKey = GlobalKey<FormState>();
  final TextEditingController emailTextEditingController;
  final TextEditingController passwordTextEditingController;
  final void Function() onSubmitForm;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: <Widget>[
        TextFormField(
          controller: widget.emailTextEditingController,
          decoration: const InputDecoration.collapsed(
            hintText: "Email",
            border: UnderlineInputBorder(),
          ),
          validator: (value) =>
              value.isEmptyOrNull ? "Please enter a valid email" : null,
        ),
        TextFormField(
          controller: widget.passwordTextEditingController,
          decoration: const InputDecoration.collapsed(
            hintText: "Password",
            border: UnderlineInputBorder(),
          ),
          obscureText: true,
          validator: (value) {
            if (value.isEmptyOrNull) return "Please enter a password";
            if (value!.length < 8) {
              return "Minimum 8 letters";
            }
            return null;
          },
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.lock_person_rounded),
          label: "Log In".text.make(),
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
}
