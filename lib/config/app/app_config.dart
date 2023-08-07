class AppConfig {
  final String appName;
  final Flavor flavor;

  const AppConfig({required this.appName, required this.flavor});
}

enum Flavor { production, staging }
