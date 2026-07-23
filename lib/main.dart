import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mind_insight/src/core/helper/toast_helper.dart';
import 'package:mind_insight/src/core/route/app_router.dart';
import 'package:mind_insight/src/core/theme/light_theme.dart';
import 'package:mind_insight/src/core/theme/dark_theme.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MindInsightApp());
}

class MindInsightApp extends StatelessWidget {
  const MindInsightApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = appRouter(navigatorKey);

    return MaterialApp.router(
      title: 'Mind Insight',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: ToastHelper.scaffoldMessengerKey,
      theme: light,
      darkTheme: dark,
      themeMode: ThemeMode.light,
      routerConfig: router,
    );
  }
}
