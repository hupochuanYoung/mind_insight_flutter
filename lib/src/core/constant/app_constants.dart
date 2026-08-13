import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  final String envName;
  final String baseUrl;

  EnvConfig({required this.envName, required this.baseUrl});
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

  // dev — local backend
  static final EnvConfig _devConfig = EnvConfig(
    envName: "DEV",
    baseUrl: "http://127.0.0.1:8081",
  );

  // prod
  static final EnvConfig _prodConfig = EnvConfig(
    envName: "PROD",
    baseUrl: "http://127.0.0.1:8081",
  );

  // ---------------------------------------------------------------------------
  // Auth
  // ---------------------------------------------------------------------------

  /// POST /api/auth/register
  static String get registerUri => '/api/auth/register';

  /// POST /api/auth/login
  static String get loginUri => '/api/auth/login';

  /// POST /api/auth/logout
  static String get logoutUri => '/api/auth/logout';

  /// POST /api/auth/wechat/login
  static String get wechatLoginUri => '/api/auth/wechat/login';

  // ---------------------------------------------------------------------------
  // Profile
  // ---------------------------------------------------------------------------

  /// GET /api/profile
  /// PUT /api/profile
  static String get profileUri => '/api/profile';

  // ---------------------------------------------------------------------------
  // Conversation
  // ---------------------------------------------------------------------------

  /// POST /api/conversations
  /// GET  /api/conversations
  static String get conversationsUri => '/api/conversations';

  /// GET/PATCH/DELETE /api/conversations/{id}
  static String conversationUri(int id) => '/api/conversations/$id';

  /// POST /api/conversations/{id}/respond
  static String conversationRespondUri(int id) =>
      '/api/conversations/$id/respond';

  /// GET /api/conversations/{id}/messages
  static String conversationMessagesUri(int id) =>
      '/api/conversations/$id/messages';

  /// GET /api/conversations/{id}/events
  static String conversationEventsUri(int id) =>
      '/api/conversations/$id/events';

  // ---------------------------------------------------------------------------
  // Agent
  // ---------------------------------------------------------------------------

  /// POST /api/agent/chat
  static String get agentChatUri => '/api/agent/chat';

  // ---------------------------------------------------------------------------
  // Tarot
  // ---------------------------------------------------------------------------

  /// POST /api/tarot/draws
  static String get tarotDrawsUri => '/api/tarot/draws';

  /// GET /api/tarot/draws/{id}
  static String tarotDrawUri(int id) => '/api/tarot/draws/$id';

  /// POST /api/tarot/draws/{id}/reveal
  static String tarotDrawRevealUri(int id) => '/api/tarot/draws/$id/reveal';

  /// POST /api/tarot/draws/{id}/interpret
  static String tarotDrawInterpretUri(int id) =>
      '/api/tarot/draws/$id/interpret';
}
