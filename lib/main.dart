import 'package:flutter/material.dart';
import 'package:mind_insight/src/core/component/components.dart';
import 'package:mind_insight/src/features/home/presentation/screen/main_navigation_shell.dart';

void main() {
  runApp(const MindInsightApp());
}

class MindInsightApp extends StatelessWidget {
  const MindInsightApp({super.key});

  static const Color primaryColor = AppColors.primary;

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
      brightness: Brightness.light,
      surface: AppColors.surface,
    );

    return MaterialApp(
      title: 'Mind Insight',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: AppColors.surface,
        fontFamily: 'System',
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: AppColors.ink,
          displayColor: AppColors.ink,
        ),
      ),
      home: const MainNavigationShell(),
    );
  }
}
