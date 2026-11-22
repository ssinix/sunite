import 'package:flutter/material.dart';
import 'package:sunite/screens/main_shell.dart';
import 'package:sunite/utils/app_theme.dart';
import 'package:sunite/screens/login/login_screen.dart';
import 'package:sunite/screens/login/create_account_screen.dart';

void main() {
  runApp(const SUniteApp());
}

class SUniteApp extends StatelessWidget {
  const SUniteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SUnite',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const CreateAccountScreen(),
        '/home': (context) => const MainShell(),
      },
    );
  }
}
