import 'package:flutter/material.dart';
import 'package:sunite/models/user_profile.dart';
import 'package:sunite/utils/app_spacing.dart';
import 'package:sunite/utils/app_text_styles.dart';

// The profile layout shared by My Profile and Other User's Profile.
// Screen-specific controls (Contact by e-mail, Edit Profile, My Posts,
// Log Out) are passed in so each screen adds only what it needs.
class ProfileView extends StatelessWidget {
  final UserProfile profile;
  final Widget? belowEmail;
  final List<Widget> footer;
  final void Function(GroupMembership group) onGroupTap;

  const ProfileView({
    super.key,
    required this.profile,
    required this.onGroupTap,
    this.belowEmail,
    this.footer = const [],
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: AppSpacing.screenPadding,
      children: [
        // Avatar, name, e-mail and year
        Center(
          child: CircleAvatar(
            radius: 44,
            backgroundColor: colors.surfaceContainerHighest,
            child: Icon(Icons.person, size: 48, color: colors.outline),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          profile.fullName,
          textAlign: TextAlign.center,
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mail_outline, size: 16, color: colors.onSurfaceVariant),
            const SizedBox(width: AppSpacing.xs),
            Text(
              profile.email,
              style: textTheme.bodyMedium
                  ?.copyWith(color: colors.onSurfaceVariant),
            ),
          ],
        ),
        if (belowEmail != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Center(child: belowEmail),
        ],
        const SizedBox(height: AppSpacing.xs),
        Text(
          profile.year,
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Major / Minor rows
        _InfoRow(label: 'Major', value: _joinOrDash(profile.majors)),
        _InfoRow(label: 'Minor', value: _joinOrDash(profile.minors)),
        const SizedBox(height: AppSpacing.md),

        // Skills
        const Text('SKILLS', style: AppTextStyles.sectionLabel),
        const SizedBox(height: AppSpacing.sm),
        if (profile.skills.isEmpty)
          Text('No skills added yet', style: textTheme.bodyMedium)
        else
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final skill in profile.skills) Chip(label: Text(skill)),
            ],
          ),
        const SizedBox(height: AppSpacing.md),

        // Current groups; each one opens Group Detail
        const Text('CURRENT GROUPS', style: AppTextStyles.sectionLabel),
        const SizedBox(height: AppSpacing.sm),
        if (profile.currentGroups.isEmpty)
          Text('Not in any groups yet', style: textTheme.bodyMedium)
        else
          for (final group in profile.currentGroups)
            Card(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: ListTile(
                title: Text(
                  group.groupName,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                trailing: Text(
                  group.isOwner ? 'Owner' : 'Member',
                  style: TextStyle(color: colors.onSurfaceVariant),
                ),
                onTap: () => onGroupTap(group),
              ),
            ),

        ...footer,
      ],
    );
  }

  static String _joinOrDash(List<String> items) =>
      items.isEmpty ? '-' : items.join(', ');
}

// One "Label ........ Value" line
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: colors.onSurfaceVariant)),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
