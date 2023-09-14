import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'theme_state.dart';

class ThemeCubit extends HydratedCubit<ThemeState> {
  ThemeCubit() : super(const ThemeState.adaptive());

  @override
  ThemeState? fromJson(Map<String, dynamic> json) {
    switch (json["brightness"]) {
      case "light":
        return const ThemeState.light();
      case "dark":
        return const ThemeState.dark();
      default:
        return const ThemeState.adaptive();
    }
  }

  @override
  Map<String, dynamic>? toJson(ThemeState state) =>
      {"brightness": state.themeMode.name};

  void changeBrightness(ThemeMode themeMode) {
    emit(ThemeState.fromThemeMode(themeMode));
  }
}
