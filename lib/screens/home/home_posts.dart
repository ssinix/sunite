import 'package:flutter/material.dart';
import 'package:sunite/utils/app_spacing.dart';

// Latest posts shown on Home (4)

// ---------- DATA (sample posts; replace with Firestore later) ----------

enum HomePostType { group, person }

class HomePost {
  final HomePostType type;
  final String category;     // e.g. 'Course Groups'
  final String code;         // course code, school or event, e.g. 'CS310'
  final String title;
  final List<String> tags;
  final String? memberCount; // only group posts, e.g. '3/5'
  final String? author;      // only person posts, e.g. 'Elif Ç. · 3rd year'

  const HomePost({
    required this.type,
    required this.category,
    required this.code,
    required this.title,
    required this.tags,
    this.memberCount,
    this.author,
  });
}

const List<HomePost> sampleHomePosts = [
  HomePost(
    type: HomePostType.group,
    category: 'Course Groups',
    code: 'CS310',
    title: 'CS310 app team needs 2 more',
    tags: ['Flutter', 'Firebase'],
    memberCount: '3/5',
  ),
  HomePost(
    type: HomePostType.person,
    category: 'Erasmus',
    code: 'TU Delft',
    title: 'Going in Spring 2027, looking for flatmates',
    tags: ['Flatmate', 'Travel'],
    author: 'Elif Ç. · 3rd year',
  ),
  HomePost(
    type: HomePostType.group,
    category: 'Startups & Projects',
    code: 'MVP stage',
    title: 'Campus food-waste app',
    tags: ['Backend', 'Marketing'],
    memberCount: '2/4',
  ),
  HomePost(
    type: HomePostType.person,
    category: 'Course Groups',
    code: 'PROJ201',
    title: 'Looking for a PROJ201 group',
    tags: ['Python', 'Reports'],
    author: 'Mert A. · 2nd year',
  ),
];

// ---------- THE LIST ----------

/// The scrolling list of post cards (goes inside Expanded on Home)
class HomeLatestPosts extends StatelessWidget {
  const HomeLatestPosts({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 88), // room for the + button
      itemCount: sampleHomePosts.length,
      separatorBuilder: (context, index) =>
      const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) =>
          HomePostCard(post: sampleHomePosts[index]),
    );
  }
}

// ---------- ONE CARD ----------

class HomePostCard extends StatelessWidget {
  const HomePostCard({super.key, required this.post});

  final HomePost post;

  // Black "GROUP" badge or outlined "PERSON" badge
  Widget _badge(bool isGroup) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
      decoration: BoxDecoration(
        color: isGroup ? Colors.black : Colors.white,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        isGroup ? 'GROUP' : 'PERSON',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: isGroup ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  // Small rounded tag like "Flutter"
  Widget _tag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: const TextStyle(fontSize: 11)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final isGroup = post.type == HomePostType.group;

    return GestureDetector(
      onTap: () {
        // TODO: open Group Detail (group posts) or Person Post Detail (person posts)
      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1) Badge + "Course Groups · CS310"
            Row(
              children: [
                _badge(isGroup),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    '${post.category} · ${post.code}',
                    style: text.bodySmall?.copyWith(color: Colors.grey.shade600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),

            // 2) Title
            Text(
              post.title,
              style: text.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.sm),

            // 3) Tags on the left, member count on the right (group posts)
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: [
                      for (final tag in post.tags) _tag(tag),
                    ],
                  ),
                ),
                if (post.memberCount != null) ...[
                  const Icon(Icons.group_outlined, size: 16),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    post.memberCount!,
                    style: text.labelMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ],
            ),

            // 4) Author (person posts only)
            if (post.author != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  CircleAvatar(radius: 10, backgroundColor: Colors.grey.shade300),
                  const SizedBox(width: AppSpacing.sm),
                  Text(post.author!, style: text.bodySmall),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}