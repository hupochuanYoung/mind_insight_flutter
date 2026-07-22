import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  final String envName;
  final String baseUrl;
  final String agentBaseUrl;

  EnvConfig({
    required this.envName,
    required this.baseUrl,
    required this.agentBaseUrl,
  });
}

class AppConstants {
  static final String _appEnv = dotenv.env['BUILD_ENV'] ?? 'DEV';

  /// 当前是否为 PROD 环境。
  static bool get isProd => envConfig.envName == "PROD";

  // get current env
  static EnvConfig get envConfig => _getEnvConfig();

  static EnvConfig _getEnvConfig() {
    switch (_appEnv.toUpperCase()) {
      case "PROD":
        return _prodConfig;
      default:
        return _devConfig;
    }
  }

  // dev — local agent service
  static final EnvConfig _devConfig = EnvConfig(
    envName: "DEV",
    baseUrl: "http://127.0.0.1:8001",
    agentBaseUrl: "http://127.0.0.1:8001",
  );

  // prod
  static final EnvConfig _prodConfig = EnvConfig(
    envName: "PROD",
    baseUrl: "http://127.0.0.1:8001",
    agentBaseUrl: "http://127.0.0.1:8001",
  );

  // ---------------------------------------------------------------------------
  // URI helpers
  // ---------------------------------------------------------------------------

  static String getBaseUri(String url) {
    return '/v1$url';
  }

  // ---------------------------------------------------------------------------
  // Agent Chat API
  // ---------------------------------------------------------------------------

  /// POST /v1/chat — send a message to the tarot agent
  static String get chatUri => getBaseUri('/chat');

  /// GET /health — agent service health check
  static String get healthUri => '/health';
}
