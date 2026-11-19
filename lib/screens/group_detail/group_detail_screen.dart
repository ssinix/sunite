import 'package:flutter/material.dart';
import 'package:sunite/data/sample_groups.dart';
import 'package:sunite/models/group.dart';
import 'package:sunite/models/user_profile.dart';
import 'package:sunite/screens/my_groups/manage_group_screen.dart';
import 'package:sunite/screens/profile/other_profile_screen.dart';
import 'package:sunite/utils/app_spacing.dart';
import 'package:sunite/utils/app_text_styles.dart';
import 'package:sunite/utils/dialog_utils.dart';
import 'package:sunite/utils/snackbar_utils.dart';
import 'package:sunite/widgets/info_row.dart';
import 'package:sunite/widgets/status_label.dart';
import 'package:sunite/widgets/user_avatar.dart';

// 6. Group Detail: everything about a group post. The bottom button
// depends on who is viewing: the owner, a member, someone with a pending
// request, or a visitor (who sees "Group full" when there is no spot).
//
// Open it with:
//   Navigator.push(context, MaterialPageRoute(
//     builder: (context) => GroupDetailScreen(group: someGroup)));
class GroupDetailScreen extends StatefulWidget {
  final Group group;

  // Optional: called after the user joins, leaves or manages the group,
  // so the screen that opened Group Detail can update its lists
  final void Function(Group updated)? onChanged;

  // Optional: called if the owner deletes the group from Manage Group
  final void Function(Group deleted)? onDelete;

  const GroupDetailScreen({
    super.key,
    required this.group,
    this.onChanged,
    this.onDelete,
  });

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  // This screen's current copy of the group; replaced on every change
  late Group _group;

  @override
  void initState() {
    super.initState();
    _group = widget.group;
  }

  // Shows the updated group here and tells the screen that opened this one
  void _setGroup(Group updated) {
    setState(() {
      _group = updated;
    });
    widget.onChanged?.call(updated);
  }

  bool _isCurrentUser(UserProfile user) => user.email == currentUser.email;

  void _openProfile(UserProfile user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtherProfileScreen(profile: user),
      ),
    );
  }

  // O2: asks for confirmation, then sends a join request
  Future<void> _requestToJoin() async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Request to join?',
      message: 'Send a join request to ${_group.title}? The owner will see '
          'your profile and can accept or decline.',
      confirmLabel: 'Send Request',
      isDestructive: false,
    );
    if (!confirmed || !mounted) return;

    _setGroup(
      _group.copyWith(
        pendingRequests: [..._group.pendingRequests, currentUser],
      ),
    );
    showAppSnackBar(context, 'Join request sent');
  }

  Future<void> _leaveGroup() async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Leave this group?',
      message: 'Your spot will open up for others. To join again, you need '
          'to send a new request.',
      confirmLabel: 'Leave',
    );
    if (!confirmed || !mounted) return;

    _setGroup(
      _group.copyWith(
        members: _group.members.where((m) => !_isCurrentUser(m)).toList(),
      ),
    );
    showAppSnackBar(context, 'You left ${_group.title}');
  }

  // Owner only. If the group is deleted there, this screen closes too.
  Future<void> _openManageGroup() async {
    var deleted = false;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ManageGroupScreen(
          group: _group,
          onChanged: _setGroup,
          onDelete: (group) {
            deleted = true;
            widget.onDelete?.call(group);
          },
        ),
      ),
    );
    if (!deleted || !mounted) return;

    showAppSnackBar(context, '"${_group.title}" was deleted');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Group')),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          // Post type, category and title
          Row(
            children: [
              StatusLabel(
                text: 'GROUP',
                color: colors.onSurface,
                textColor: colors.surface,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  _group.category,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall
                      ?.copyWith(color: colors.onSurfaceVariant),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            _group.title,
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.md),

          // The board's own field (e.g. course code) and capacity
          if (_group.categoryDetailLabel.isNotEmpty)
            InfoRow(
              label: _group.categoryDetailLabel,
              value: _group.categoryDetail,
            ),
          InfoRow(
            label: 'Capacity',
            value: '${_group.memberCount}/${_group.maxMembers} members',
          ),
          const SizedBox(height: AppSpacing.xs),
          LinearProgressIndicator(
            value: _group.memberCount / _group.maxMembers,
            minHeight: 6,
          ),
          const SizedBox(height: AppSpacing.lg),

          const Text('DESCRIPTION', style: AppTextStyles.sectionLabel),
          const SizedBox(height: AppSpacing.sm),
          Text(
            _group.description.isEmpty
                ? 'No description'
                : _group.description,
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.lg),

          const Text('LOOKING FOR', style: AppTextStyles.sectionLabel),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final tag in _group.lookingFor) Chip(label: Text(tag)),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          const Text('OWNER', style: AppTextStyles.sectionLabel),
          const SizedBox(height: AppSpacing.sm),
          Card(
            margin: EdgeInsets.zero,
            child: ListTile(
              leading: UserAvatar(name: _group.owner.fullName),
              title: Text(
                _group.owner.fullName,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(_userDetails(_group.owner)),
              onTap: _isCurrentUser(_group.owner)
                  ? null
                  : () => _openProfile(_group.owner),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Members, plus an empty circle for each open spot
          Text(
            'MEMBERS (${_group.memberCount})',
            style: AppTextStyles.sectionLabel,
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final member in _group.members) _buildMemberAvatar(member),
              for (int i = _group.memberCount; i < _group.maxMembers; i++)
                _buildOpenSpot(),
            ],
          ),
        ],
      ),
      // The action button stays at the bottom while the details scroll
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: _buildActionButton(),
          ),
        ),
      ),
    );
  }

  // "4th year · Computer Science & Eng."
  String _userDetails(UserProfile user) {
    final parts = [user.year, user.majors.join(', ')];
    return parts.where((part) => part.isNotEmpty).join(' · ');
  }

  // A member's avatar; tapping it opens their profile (not your own)
  Widget _buildMemberAvatar(UserProfile member) {
    return Tooltip(
      message: member.fullName,
      child: GestureDetector(
        onTap: _isCurrentUser(member) ? null : () => _openProfile(member),
        child: UserAvatar(name: member.fullName),
      ),
    );
  }

  Widget _buildOpenSpot() {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: colors.outlineVariant, width: 1.5),
      ),
    );
  }

  // The bottom button for each viewer (wireframe states 6a-6e)
  Widget _buildActionButton() {
    final colors = Theme.of(context).colorScheme;

    if (_group.isOwnedBy(currentUser)) {
      return FilledButton(
        onPressed: _openManageGroup,
        child: const Text('Manage Group'),
      );
    }
    if (_group.hasMember(currentUser)) {
      return OutlinedButton(
        onPressed: _leaveGroup,
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.error,
          side: BorderSide(color: colors.error),
        ),
        child: const Text('Leave Group'),
      );
    }
    if (_group.hasRequestFrom(currentUser)) {
      // null disables the button until the owner answers
      return OutlinedButton.icon(
        onPressed: null,
        icon: const Icon(Icons.schedule),
        label: const Text('Request pending'),
      );
    }
    if (_group.isFull) {
      return const FilledButton(onPressed: null, child: Text('Group full'));
    }
    return FilledButton(
      onPressed: _requestToJoin,
      child: const Text('Request to Join'),
    );
  }
}
