import 'package:flutter/material.dart';
import 'package:sunite/screens/home/home_posts.dart';
import 'package:sunite/utils/app_spacing.dart';


class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({super.key, required this.post});

  final HomePost post;

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  bool _requested = false;

  HomePost get post => widget.post;
  bool get _isGroup => post.type == HomePostType.group;

  int get _members => int.parse(post.memberCount!.split('/').first);
  int get _maxMembers => int.parse(post.memberCount!.split('/').last);
  bool get _isFull => _members >= _maxMembers;

  String get _codeLabel => switch (post.category) {
    'Course Groups' => 'Course code',
    'Erasmus' => 'School',
    'Events' => 'Event',
    _ => 'Stage',
  };

  Widget _sectionTitle(String label) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: 1,
        color: Colors.grey.shade700,
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: [
          Text(label,
              style: text.bodyMedium?.copyWith(color: Colors.grey.shade700)),
          const Spacer(),
          Text(value,
              style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  ButtonStyle get _blackButton => ElevatedButton.styleFrom(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );

  void _confirmJoin() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Request to join?'),
        content: Text(
          'Send a join request to "${post.title}"? '
              'The owner will see your profile and can accept or decline.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              setState(() => _requested = true);
            },
            child: const Text('Send Request'),
          ),
        ],
      ),
    );
  }

  Widget _bottomButton() {
    if (!_isGroup) {
      return ElevatedButton(
        style: _blackButton,
        onPressed: () {
          // TODO: open 12. Other User's Profile
        },
        child: const Text('View Profile'),
      );
    }


    if (_isFull) {
      return const ElevatedButton(
        onPressed: null,
        child: Text('Group full'),
      );
    }


    if (_requested) {
      return OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: null,
        icon: const Icon(Icons.schedule),
        label: const Text('Request pending'),
      );
    }


    return ElevatedButton(
      style: _blackButton,
      onPressed: _confirmJoin,
      child: const Text('Request to Join'),
    );
  }



  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;


    final authorParts = (post.author ?? 'Unknown').split(' · ');
    final authorName = authorParts.first;
    final authorInfo = authorParts.skip(1).join(' · ');

    return Scaffold(

      appBar: AppBar(
        title: Text(_isGroup ? 'Group' : 'Post'),
        centerTitle: true,
      ),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [

          if (!_isGroup) ...[
            GestureDetector(
              onTap: () {
              },
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                        radius: 22, backgroundColor: Colors.grey.shade300),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            authorName,
                            style: text.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            authorInfo,
                            style: text.bodySmall
                                ?.copyWith(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],


          Row(
            children: [
              PostBadge(isGroup: _isGroup),
              const SizedBox(width: AppSpacing.sm),
              Text(
                post.category,
                style: text.bodySmall?.copyWith(color: Colors.grey.shade600),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),


          Text(
            post.title,
            style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.md),


          _infoRow(_codeLabel, post.code),
          if (post.term != null) _infoRow('Term', post.term!),


          if (_isGroup) ...[
            _infoRow('Capacity', '$_members/$_maxMembers members'),
            const SizedBox(height: AppSpacing.xs),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: _members / _maxMembers,
                minHeight: 6,
                backgroundColor: Colors.grey.shade300,
                color: Colors.black,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),


          _sectionTitle('DESCRIPTION'),
          const SizedBox(height: AppSpacing.sm),
          Text(post.description ?? 'No description yet.',
              style: text.bodyMedium),
          const SizedBox(height: AppSpacing.lg),
          _sectionTitle('LOOKING FOR'),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              for (final tag in post.tags) PostTag(label: tag),
            ],
          ),
          // TODO (group posts): OWNER and MEMBERS lists, once there is member data
        ],
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: _bottomButton(),
          ),
        ),
      ),
    );
  }
}