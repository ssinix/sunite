import 'package:flutter/material.dart';
import 'package:sunite/screens/home/person_post_detail.dart';
import 'package:sunite/utils/app_spacing.dart';





enum HomePostType { group, person }

class HomePost {
  final HomePostType type;
  final String category;
  final String code;
  final String title;
  final List<String> tags;
  final String? memberCount;
  final String? author;
  final String? term;
  final String? description;

  const HomePost({
    required this.type,
    required this.category,
    required this.code,
    required this.title,
    required this.tags,
    this.memberCount,
    this.author,
    this.term,
    this.description,
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
    description:
    'Mobile app project for CS310. We meet twice a week and build in Flutter.',
  ),
  HomePost(
    type: HomePostType.person,
    category: 'Erasmus',
    code: 'TU Delft',
    term: 'Spring 2027',
    title: 'Going to TU Delft in Spring, looking for flatmates',
    tags: ['Flatmate', 'Travel buddy', 'Same courses'],
    author: 'Elif Çamlıkaya · 3rd year · Computer Science',
    description:
    'Looking for 1–2 people to share a flat near campus and travel together on weekends.',
  ),
  HomePost(
    type: HomePostType.group,
    category: 'Startups & Projects',
    code: 'MVP stage',
    title: 'Campus food-waste app',
    tags: ['Backend', 'Marketing'],
    memberCount: '2/4',
    description:
    'An app that connects campus cafés with students to cut food waste.',
  ),
  HomePost(
    type: HomePostType.person,
    category: 'Course Groups',
    code: 'PROJ201',
    title: 'Looking for a PROJ201 group',
    tags: ['Python', 'Reports'],
    author: 'Mert Ali İlter · 2nd year · Computer Science',
    description: 'I can take the Python part and help with the reports.',
  ),
];



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



/// Black "GROUP" badge or outlined "PERSON" badge
class PostBadge extends StatelessWidget {
  const PostBadge({super.key, required this.isGroup});

  final bool isGroup;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
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
}

/// Small rounded tag like "Flutter"
class PostTag extends StatelessWidget {
  const PostTag({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: const TextStyle(fontSize: 11)),
    );
  }
}



class HomePostCard extends StatelessWidget {
  const HomePostCard({super.key, required this.post});

  final HomePost post;


  void _open(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostDetailScreen(post: post),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final isGroup = post.type == HomePostType.group;


    final authorParts = (post.author ?? '').split(' · ');
    final shortAuthor = authorParts.take(2).join(' · ');

    return GestureDetector(
      onTap: () => _open(context),
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

            Row(
              children: [
                PostBadge(isGroup: isGroup),
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


            Text(
              post.title,
              style: text.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.sm),


            Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: [
                      for (final tag in post.tags) PostTag(label: tag),
                    ],
                  ),
                ),
                if (post.memberCount != null) ...[
                  const Icon(Icons.group_outlined, size: 16),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    post.memberCount!,
                    style:
                    text.labelMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ],
            ),


            if (post.author != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  CircleAvatar(
                      radius: 10, backgroundColor: Colors.grey.shade300),
                  const SizedBox(width: AppSpacing.sm),
                  Text(shortAuthor, style: text.bodySmall),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}