import 'package:get_it/get_it.dart';

import 'src/core/constant/app_constants.dart';
import 'src/core/data/dio/dio_client.dart';
import 'src/core/data/dio/logging_interceptor.dart';

// Auth feature
import 'src/features/auth/business/repository/auth_repository.dart';
import 'src/features/auth/business/usecase/login_usecase.dart';
import 'src/features/auth/business/usecase/logout_usecase.dart';
import 'src/features/auth/business/usecase/register_usecase.dart';
import 'src/features/auth/data/datasource/auth_remote_datasource.dart';
import 'src/features/auth/data/repository/auth_repository_impl.dart';
import 'src/features/auth/presentation/provider/auth_provider.dart';

// Chat feature
import 'src/features/chat/business/repository/chat_repository.dart';
import 'src/features/chat/business/usecase/chat_with_agent_usecase.dart';
import 'src/features/chat/business/usecase/create_tarot_draw_usecase.dart';
import 'src/features/chat/business/usecase/interpret_tarot_cards_usecase.dart';
import 'src/features/chat/business/usecase/reveal_tarot_cards_usecase.dart';
import 'src/features/chat/data/datasource/agent_remote_datasource.dart';
import 'src/features/chat/data/datasource/conversation_remote_datasource.dart';
import 'src/features/chat/data/datasource/tarot_remote_datasource.dart';
import 'src/features/chat/data/repository/chat_repository_impl.dart';
import 'src/features/chat/presentation/provider/chat_provider.dart';

// Profile feature
import 'src/features/profile/business/repository/profile_repository.dart';
import 'src/features/profile/business/usecase/get_profile_usecase.dart';
import 'src/features/profile/data/datasource/profile_remote_datasource.dart';
import 'src/features/profile/data/repository/profile_repository_impl.dart';
import 'src/features/profile/presentation/provider/profile_provider.dart';

/// Global service locator instance.
final GetIt sl = GetIt.instance;

/// Register all dependencies — call once at app startup before runApp().
Future<void> initDependencies() async {
  // ---------------------------------------------------------------------------
  // Core
  // ---------------------------------------------------------------------------

  sl.registerLazySingleton<LoggingInterceptor>(() => LoggingInterceptor());

  sl.registerLazySingleton<DioClient>(
    () => DioClient(
      AppConstants.envConfig.baseUrl,
      loggingInterceptor: sl<LoggingInterceptor>(),
    ),
  );

  // ---------------------------------------------------------------------------
  // Auth Feature
  // ---------------------------------------------------------------------------

  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasource(dioClient: sl<DioClient>()),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(authRemote: sl<AuthRemoteDatasource>()),
  );

  sl.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(repository: sl<AuthRepository>()),
  );

  sl.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(repository: sl<AuthRepository>()),
  );

  sl.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(repository: sl<AuthRepository>()),
  );

  sl.registerFactory<AuthProvider>(
    () => AuthProvider(
      loginUseCase: sl<LoginUseCase>(),
      logoutUseCase: sl<LogoutUseCase>(),
      registerUseCase: sl<RegisterUseCase>(),
    ),
  );

  // ---------------------------------------------------------------------------
  // Chat Feature
  // ---------------------------------------------------------------------------

  sl.registerLazySingleton<AgentRemoteDatasource>(
    () => AgentRemoteDatasource(dioClient: sl<DioClient>()),
  );

  sl.registerLazySingleton<ConversationRemoteDatasource>(
    () => ConversationRemoteDatasource(dioClient: sl<DioClient>()),
  );

  sl.registerLazySingleton<TarotRemoteDatasource>(
    () => TarotRemoteDatasource(dioClient: sl<DioClient>()),
  );

  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(
      agentRemote: sl<AgentRemoteDatasource>(),
      conversationRemote: sl<ConversationRemoteDatasource>(),
      tarotRemote: sl<TarotRemoteDatasource>(),
    ),
  );

  sl.registerLazySingleton<ChatWithAgentUseCase>(
    () => ChatWithAgentUseCase(repository: sl<ChatRepository>()),
  );

  sl.registerLazySingleton<CreateTarotDrawUseCase>(
    () => CreateTarotDrawUseCase(repository: sl<ChatRepository>()),
  );

  sl.registerLazySingleton<RevealTarotCardsUseCase>(
    () => RevealTarotCardsUseCase(repository: sl<ChatRepository>()),
  );

  sl.registerLazySingleton<InterpretTarotCardsUseCase>(
    () => InterpretTarotCardsUseCase(repository: sl<ChatRepository>()),
  );

  sl.registerFactory<ChatProvider>(
    () => ChatProvider(
      chatWithAgentUseCase: sl<ChatWithAgentUseCase>(),
      createTarotDrawUseCase: sl<CreateTarotDrawUseCase>(),
      revealTarotCardsUseCase: sl<RevealTarotCardsUseCase>(),
      interpretTarotCardsUseCase: sl<InterpretTarotCardsUseCase>(),
    ),
  );

  // ---------------------------------------------------------------------------
  // Profile Feature
  // ---------------------------------------------------------------------------

  sl.registerLazySingleton<ProfileRemoteDatasource>(
    () => ProfileRemoteDatasource(dioClient: sl<DioClient>()),
  );

  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(profileRemote: sl<ProfileRemoteDatasource>()),
  );

  sl.registerLazySingleton<GetProfileUseCase>(
    () => GetProfileUseCase(repository: sl<ProfileRepository>()),
  );

  sl.registerFactory<ProfileProvider>(
    () => ProfileProvider(getProfileUseCase: sl<GetProfileUseCase>()),
  );
}
