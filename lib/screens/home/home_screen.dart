import 'package:flutter/material.dart';
import 'package:sunite/screens/home/create_post.dart';
import 'package:sunite/screens/home/home_categories.dart';
import 'package:sunite/screens/home/home_posts.dart';
import 'package:sunite/utils/app_spacing.dart';

// 4. Home
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const String userName = 'Azra'; // TODO: take from the logged-in user

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

            // 2) The 4 category buttons -> Board (in home_categories.dart)
            const HomeCategoryGrid(),
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

            // 4) Post cards -> Post detail (in home_posts.dart)
            //    Only this part scrolls
            const Expanded(
              child: HomeLatestPosts(),
            ),
          ],
        ),
      ),

      // + button -> New Post (in create_post.dart)
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            fullscreenDialog: true, // opens like a form, from the bottom
            builder: (context) => const CreatePostScreen(),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}