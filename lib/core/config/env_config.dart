/// Environment configuration for the app
enum Environment { dev, staging, prod }

class EnvConfig {
  final Environment environment;
  final String apiBaseUrl;
  final bool enableLogging;

  const EnvConfig({
    required this.environment,
    required this.apiBaseUrl,
    this.enableLogging = false,
  });

  static const EnvConfig dev = EnvConfig(
    environment: Environment.dev,
    apiBaseUrl: 'http://10.0.2.2:8000/api', // Android emulator localhost
    enableLogging: true,
  );

  // For Chrome/Web development
  static const EnvConfig devWeb = EnvConfig(
    environment: Environment.dev,
    apiBaseUrl: 'http://localhost:8000/api', // Web localhost
    enableLogging: true,
  );

  static const EnvConfig staging = EnvConfig(
    environment: Environment.staging,
    apiBaseUrl: 'https://staging.qlmguardian.com/api',
    enableLogging: true,
  );

  static const EnvConfig prod = EnvConfig(
    environment: Environment.prod,
    apiBaseUrl: 'https://darkturquoise-lark-306795.hostingersite.com/api',
    enableLogging: false,
  );

  bool get isDev => environment == Environment.dev;
  bool get isProd => environment == Environment.prod;
}
