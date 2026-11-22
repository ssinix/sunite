import 'package:flutter/material.dart';
import 'package:sunite/screens/home/board.dart';
import 'package:sunite/screens/home/home_posts.dart';
import 'package:sunite/utils/app_spacing.dart';

// 4. Home
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const String userName = 'Azra'; // TODO: take from the logged-in user

  // Opens the Board (5) with the tapped category's title
  void _openBoard(BuildContext context, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BoardScreen(title: title)),
    );
  }

  // One category button (used 4 times below)
  Widget _categoryButton(BuildContext context, IconData icon, String label) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(AppSpacing.sm),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: () => _openBoard(context, label),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          const SizedBox(height: AppSpacing.xs),
          Text(label, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SUnite',
          style: text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      body: Padding(
        padding: AppSpacing.screenPadding.copyWith(bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1) Greeting
            Text(
              'Hi $userName, what are you looking for?',
              style: text.bodyLarge?.copyWith(color: Colors.grey.shade700),
            ),
            const SizedBox(height: AppSpacing.md),

            // 2) Category buttons: 2 x 2, always exactly 200 tall
            SizedBox(
              height: 200,
              child: GridView(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: AppSpacing.sm,
                  mainAxisSpacing: AppSpacing.sm,
                  mainAxisExtent: 96, // (200 - 8) / 2
                ),
                children: [
                  _categoryButton(context, Icons.menu_book, 'Course Groups'),
                  _categoryButton(context, Icons.flight_takeoff, 'Erasmus'),
                  _categoryButton(
                      context, Icons.rocket_launch, 'Startups & Projects'),
                  _categoryButton(context, Icons.celebration, 'Events'),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // 3) Section title
            Text(
              'LATEST POSTS',
              style: text.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            // 4) Latest posts (only this part scrolls) — see home_posts.dart
            const Expanded(
              child: HomeLatestPosts(),
            ),
          ],
        ),
      ),

      // TODO: open Create Post
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}