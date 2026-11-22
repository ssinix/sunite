import 'package:flutter/material.dart';
import 'package:sunite/utils/app_spacing.dart';

// 5. Board — placeholder page for now (one template for all four categories)
class BoardScreen extends StatelessWidget {
  const BoardScreen({super.key, required this.title});

  final String title; // e.g. 'Course Groups', comes from the tapped Home button

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      // The back arrow appears automatically because this screen was pushed
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min, // keep the group small and centered
            children: [
              Icon(Icons.construction, size: 64, color: Colors.grey.shade400),
              const SizedBox(height: AppSpacing.md),
              Text(
                '$title board',
                textAlign: TextAlign.center,
                style: text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Coming soon',
                style: text.bodyLarge?.copyWith(color: Colors.grey.shade600),
              ),
              const SizedBox(height: AppSpacing.lg),
              OutlinedButton.icon(
                onPressed: () => Navigator.pop(context), // back to Home
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}