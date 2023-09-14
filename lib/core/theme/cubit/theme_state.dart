part of 'theme_cubit.dart';

final class ThemeState extends Equatable {
  final ThemeMode themeMode;
  const ThemeState._(this.themeMode);

  const ThemeState.light() : this._(ThemeMode.light);
  const ThemeState.dark() : this._(ThemeMode.dark);
  const ThemeState.adaptive() : this._(ThemeMode.system);
  const ThemeState.fromThemeMode(this.themeMode);

  bool get isLight => themeMode == ThemeMode.light;
  bool get isDark => themeMode == ThemeMode.dark;
  bool get isAdaptive => themeMode == ThemeMode.system;

  @override
  List<Object> get props => [themeMode.name];
}
