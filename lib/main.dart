import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mind_insight/di_container.dart';
import 'package:mind_insight/src/core/helper/toast_helper.dart';
import 'package:mind_insight/src/core/route/app_router.dart';
import 'package:mind_insight/src/core/theme/light_theme.dart';
import 'package:mind_insight/src/core/theme/dark_theme.dart';
import 'package:provider/provider.dart';

import 'src/features/chat/presentation/provider/chat_provider.dart';
import 'src/features/profile/presentation/provider/profile_provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await initDependencies();
  runApp(const MindInsightApp());
}

class MindInsightApp extends StatelessWidget {
  const MindInsightApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = appRouter(navigatorKey);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatProvider>(create: (_) => sl<ChatProvider>()),
        ChangeNotifierProvider<ProfileProvider>(
          create: (_) => sl<ProfileProvider>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Mind Insight',
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: ToastHelper.scaffoldMessengerKey,
        theme: light,
        darkTheme: dark,
        themeMode: ThemeMode.light,
        routerConfig: router,
      ),
    );
  }
}
