import 'package:flutter/material.dart';
import 'package:sunite/utils/app_spacing.dart';

// Placeholder until the real Home screen is built
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SUnite')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/sunite_logo.png', width: 120),
            const SizedBox(height: AppSpacing.md),
            const Text('Home screen coming soon'),
          ],
        ),
      ),
    );
  }
}
