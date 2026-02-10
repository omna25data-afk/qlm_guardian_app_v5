import 'env_config.dart';

/// Global app configuration
class AppConfig {
  static late EnvConfig _config;

  static void init(EnvConfig config) {
    _config = config;
  }

  static EnvConfig get current => _config;
  static String get apiBaseUrl => _config.apiBaseUrl;
  static bool get enableLogging => _config.enableLogging;
  static bool get isDev => _config.isDev;
  static bool get isProd => _config.isProd;
}
