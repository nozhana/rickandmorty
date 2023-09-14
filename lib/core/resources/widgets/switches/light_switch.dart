import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rickandmorty/core/theme/cubit/theme_cubit.dart';
import 'package:velocity_x/velocity_x.dart';

class LightSwitch extends StatelessWidget {
  const LightSwitch({super.key, this.isExtended = false});

  final bool isExtended;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return isExtended
            ? ToggleButtons(
                    onPressed: (index) {
                      context
                          .read<ThemeCubit>()
                          .changeBrightness(switch (index) {
                            0 => ThemeMode.light,
                            1 => ThemeMode.dark,
                            _ => ThemeMode.system,
                          });
                      context.showToast(
                          msg: switch (index) {
                            0 => "Light mode enabled.",
                            1 => "Dark mode enabled.",
                            _ => "Adaptive mode enabled."
                          },
                          position: VxToastPosition.center);
                    },
                    isSelected: [state.isLight, state.isDark, state.isAdaptive],
                    constraints:
                        const BoxConstraints.expand(width: (256 - 20) / 3),
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                    fillColor: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(16),
                    children: [
                      (Icons.light_mode, "Light"),
                      (Icons.dark_mode, "Dark"),
                      (Icons.brightness_auto, "Adaptive")
                    ]
                        .map((pair) => [
                              Icon(pair.$1),
                              8.heightBox,
                              pair.$2.text.make()
                            ].vStack(axisSize: MainAxisSize.min))
                        .toList())
                .px8()
                .wh(256, 86)
            : IconButton.filled(
                onPressed: () {
                  context.read<ThemeCubit>().changeBrightness(state.isLight
                      ? ThemeMode.dark
                      : state.isDark
                          ? ThemeMode.system
                          : ThemeMode.light);
                  context.showToast(
                      msg: switch (state.themeMode) {
                        ThemeMode.light => "Dark mode enabled.",
                        ThemeMode.dark => "Adaptive mode enabled.",
                        ThemeMode.system => "Light mode enabled."
                      },
                      position: VxToastPosition.center);
                },
                icon: Icon(state.isLight
                    ? Icons.light_mode
                    : state.isDark
                        ? Icons.dark_mode
                        : Icons.brightness_auto));
      },
    );
  }
}
