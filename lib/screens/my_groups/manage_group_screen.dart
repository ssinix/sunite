import 'package:flutter/material.dart';
import 'package:sunite/models/group.dart';
import 'package:sunite/models/user_profile.dart';
import 'package:sunite/screens/my_groups/widgets/pending_request_card.dart';
import 'package:sunite/screens/profile/other_profile_screen.dart';
import 'package:sunite/utils/app_spacing.dart';
import 'package:sunite/utils/app_text_styles.dart';
import 'package:sunite/utils/dialog_utils.dart';
import 'package:sunite/utils/snackbar_utils.dart';
import 'package:sunite/widgets/user_avatar.dart';

// 10. Manage Group (owner only): capacity, pending join requests with
// Accept / Decline, the member list, and Edit Post / Delete Group
class ManageGroupScreen extends StatefulWidget {
  final Group group;

  // Called after every change, so My Groups can update the group's card
  final void Function(Group updated) onChanged;

  // Called when the owner deletes the group, so My Groups can remove it
  final void Function(Group deleted) onDelete;

  const ManageGroupScreen({
    super.key,
    required this.group,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  State<ManageGroupScreen> createState() => _ManageGroupScreenState();
}

class _ManageGroupScreenState extends State<ManageGroupScreen> {
  // This screen's current copy of the group; replaced on every change
  late Group _group;

  @override
  void initState() {
    super.initState();
    _group = widget.group;
  }

  // Shows the updated group here, tells My Groups and confirms with a message
  void _update(Group updated, String message) {
    setState(() {
      _group = updated;
    });
    widget.onChanged(updated);
    showAppSnackBar(context, message);
  }

  // Moves the user from the pending requests to the members
  void _accept(UserProfile user) {
    _update(
      _group.copyWith(
        members: [..._group.members, user],
        pendingRequests: _group.pendingRequests
            .where((u) => u.email != user.email)
            .toList(),
      ),
      '${user.fullName} joined the group',
    );
  }

  void _decline(UserProfile user) {
    _update(
      _group.copyWith(
        pendingRequests: _group.pendingRequests
            .where((u) => u.email != user.email)
            .toList(),
      ),
      'Declined ${user.fullName}\'s request',
    );
  }

  void _removeMember(UserProfile user) {
    _update(
      _group.copyWith(
        members: _group.members.where((u) => u.email != user.email).toList(),
      ),
      '${user.fullName} was removed from the group',
    );
  }

  bool _isOwner(UserProfile user) => user.email == _group.owner.email;

  void _openProfile(UserProfile user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtherProfileScreen(profile: user),
      ),
    );
  }

  // TODO: open Edit Post (screen 8) once that screen exists
  void _openEditPost() {
    showAppSnackBar(context, 'Edit Post coming soon');
  }

  // Asks for confirmation, then deletes the group and goes back to My Groups
  Future<void> _deleteGroup() async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Delete this group?',
      message: 'This can\'t be undone. Its members and pending requests '
          'are removed too.',
      confirmLabel: 'Delete',
    );
    // Stop if the user cancelled, or if this screen closed in the meantime
    if (!confirmed || !mounted) return;

    widget.onDelete(_group);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Group'),
        actions: [
          IconButton(
            tooltip: 'Edit Post',
            icon: const Icon(Icons.edit_outlined),
            onPressed: _openEditPost,
          ),
        ],
      ),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          // Title and capacity
          Row(
            children: [
              Expanded(
                child: Text(
                  _group.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                '${_group.memberCount}/${_group.maxMembers}',
                style: textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          LinearProgressIndicator(
            value: _group.memberCount / _group.maxMembers,
            minHeight: 6,
          ),
          if (_group.isFull) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              'The group is full. Remove a member to accept new requests.',
              style: textTheme.bodySmall
                  ?.copyWith(color: colors.onSurfaceVariant),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),

          // Pending requests
          Text(
            'PENDING REQUESTS (${_group.pendingCount})',
            style: AppTextStyles.sectionLabel,
          ),
          const SizedBox(height: AppSpacing.sm),
          if (_group.pendingRequests.isEmpty)
            Text(
              'No pending requests',
              style: textTheme.bodyMedium
                  ?.copyWith(color: colors.onSurfaceVariant),
            )
          else
            for (final user in _group.pendingRequests)
              PendingRequestCard(
                key: ValueKey(user.email),
                user: user,
                canAccept: !_group.isFull,
                onAccept: () => _accept(user),
                onDecline: () => _decline(user),
                onTap: () => _openProfile(user),
              ),
          const SizedBox(height: AppSpacing.lg),

          // Members; the owner (the current user) can't be removed
          Text(
            'MEMBERS (${_group.memberCount})',
            style: AppTextStyles.sectionLabel,
          ),
          for (final member in _group.members)
            ListTile(
              key: ValueKey(member.email),
              contentPadding: EdgeInsets.zero,
              leading: UserAvatar(name: member.fullName),
              title: Text(member.fullName),
              subtitle: Text(
                _isOwner(member) ? 'Owner' : 'Member',
              ),
              trailing: _isOwner(member)
                  ? null
                  : TextButton(
                      onPressed: () => _removeMember(member),
                      style: TextButton.styleFrom(
                        foregroundColor: colors.error,
                      ),
                      child: const Text('Remove'),
                    ),
              onTap: _isOwner(member)
                  ? null
                  : () => _openProfile(member),
            ),
          const SizedBox(height: AppSpacing.lg),

          // Edit Post / Delete Group
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _openEditPost,
                  child: const Text('Edit Post'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: FilledButton(
                  onPressed: _deleteGroup,
                  style: FilledButton.styleFrom(
                    backgroundColor: colors.error,
                    foregroundColor: colors.onError,
                  ),
                  child: const Text('Delete Group'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
