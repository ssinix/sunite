import 'package:flutter/material.dart';
import 'package:sunite/models/user_profile.dart';
import 'package:sunite/utils/app_spacing.dart';
import 'package:sunite/widgets/user_avatar.dart';

// One join request on Manage Group: who sent it, plus Accept / Decline
class PendingRequestCard extends StatelessWidget {
  final UserProfile user;
  final bool canAccept; // false when the group is full
  final VoidCallback onAccept;
  final VoidCallback onDecline;
  final VoidCallback onTap; // opens the user's profile

  const PendingRequestCard({
    super.key,
    required this.user,
    required this.canAccept,
    required this.onAccept,
    required this.onDecline,
    required this.onTap,
  });

  // "3rd year · Computer Science & Eng. · Flutter, UI design"
  String get _details {
    final parts = [user.year, user.majors.join(', '), user.skills.join(', ')];
    return parts.where((part) => part.isNotEmpty).join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.sm,
          0,
          AppSpacing.sm,
          AppSpacing.sm,
        ),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: UserAvatar(name: user.fullName),
              title: Text(
                user.fullName,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                _details,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: onTap,
            ),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    // null disables the button
                    onPressed: canAccept ? onAccept : null,
                    icon: const Icon(Icons.check),
                    label: const Text('Accept'),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onDecline,
                    icon: const Icon(Icons.close),
                    label: const Text('Decline'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
