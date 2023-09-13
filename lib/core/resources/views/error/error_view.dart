import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class ErrorView extends StatelessWidget {
  final DioError? error;
  final String? errorMessage;
  const ErrorView({this.error, this.errorMessage, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1.5,
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(16.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.error,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.redAccent, width: 8),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.1),
                    blurRadius: 24,
                    offset: const Offset(0, 12))
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Spacer(flex: 2),
              const Text(
                "ERROR!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                error?.message ?? errorMessage ?? "No error description",
                style: TextStyle(
                    color: Colors.red.shade200,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
