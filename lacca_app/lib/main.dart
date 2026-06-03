import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/onboarding_screen.dart';
import 'features/home/main_navigation.dart';

void main() {
  runApp(const LacaApp());
}

class LacaApp extends StatelessWidget {
  const LacaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LACA - Tanzania\'s Logistics Super-App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/onboarding',
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const MainNavigationScreen(),
      },
    );
  }
}