import 'package:flutter/material.dart';
import 'package:sunite/screens/home/board.dart';
import 'package:sunite/utils/app_spacing.dart';

// The 4 category buttons at the top of Home (4)

// ---------- DATA (placeholder list; change labels/icons here) ----------

class HomeCategory {
  final String label;
  final IconData icon;

  const HomeCategory({required this.label, required this.icon});
}

const List<HomeCategory> homeCategories = [
  HomeCategory(label: 'Course Groups', icon: Icons.menu_book),
  HomeCategory(label: 'Erasmus', icon: Icons.flight_takeoff),
  HomeCategory(label: 'Startups & Projects', icon: Icons.rocket_launch),
  HomeCategory(label: 'Events', icon: Icons.celebration),
];

// ---------- THE GRID ----------

/// 2 x 2 grid of category buttons, always exactly 200 tall
class HomeCategoryGrid extends StatelessWidget {
  const HomeCategoryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
          for (final category in homeCategories)
            HomeCategoryButton(category: category),
        ],
      ),
    );
  }
}

// ---------- ONE BUTTON ----------

class HomeCategoryButton extends StatelessWidget {
  const HomeCategoryButton({super.key, required this.category});

  final HomeCategory category;

  // Opens the Board (5) with this category's title
  void _openBoard(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BoardScreen(title: category.label),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(AppSpacing.sm),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: () => _openBoard(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(category.icon),
          const SizedBox(height: AppSpacing.xs),
          Text(category.label, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}