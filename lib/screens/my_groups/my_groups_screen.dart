import 'package:flutter/material.dart';
import 'package:sunite/data/sample_groups.dart';
import 'package:sunite/models/group.dart';
import 'package:sunite/models/join_request.dart';
import 'package:sunite/screens/my_groups/manage_group_screen.dart';
import 'package:sunite/utils/app_colors.dart';
import 'package:sunite/utils/app_spacing.dart';
import 'package:sunite/utils/snackbar_utils.dart';
import 'package:sunite/widgets/empty_state.dart';
import 'package:sunite/widgets/group_card.dart';
import 'package:sunite/widgets/status_label.dart';

// 9. My Groups: groups the user owns, groups they joined and the join
// requests they sent. The toggle at the top switches between the three.
class MyGroupsScreen extends StatefulWidget {
  // Switches the bottom bar to Home (the empty states' Browse boards button)
  final VoidCallback onBrowseBoards;

  const MyGroupsScreen({super.key, required this.onBrowseBoards});

  @override
  State<MyGroupsScreen> createState() => _MyGroupsScreenState();
}

class _MyGroupsScreenState extends State<MyGroupsScreen> {
  static const List<String> _tabs = ['Owned', 'Joined', 'My Requests'];

  // Lists start under the toggle, so they have no top padding
  static const EdgeInsets _listPadding = EdgeInsets.fromLTRB(
    AppSpacing.md,
    0,
    AppSpacing.md,
    AppSpacing.md,
  );

  int _selectedTab = 0;

  // Copies of the sample lists, so this screen can change its own lists
  List<Group> _ownedGroups = [...SampleGroups.owned];
  final List<Group> _joinedGroups = [...SampleGroups.joined];
  List<JoinRequest> _requests = [...SampleGroups.myRequests];

  void _openManageGroup(Group group) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ManageGroupScreen(
          group: group,
          onChanged: _updateOwnedGroup,
          onDelete: _deleteOwnedGroup,
        ),
      ),
    );
  }

  void _deleteOwnedGroup(Group deleted) {
    setState(() {
      _ownedGroups = _ownedGroups.where((g) => g.id != deleted.id).toList();
    });
    showAppSnackBar(context, '"${deleted.title}" was deleted');
  }

  // Swaps the old copy of a group for the updated one from Manage Group
  void _updateOwnedGroup(Group updated) {
    setState(() {
      _ownedGroups = [
        for (final group in _ownedGroups)
          group.id == updated.id ? updated : group,
      ];
    });
  }

  // Cancels a pending request, or clears a declined one
  void _removeRequest(JoinRequest request) {
    setState(() {
      _requests = _requests
          .where((r) => r.group.id != request.group.id)
          .toList();
    });
    showAppSnackBar(
      context,
      request.status == RequestStatus.pending
          ? 'Request cancelled'
          : 'Request removed',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Groups')),
      body: Column(
        children: [
          Padding(
            padding: AppSpacing.screenPadding,
            child: _buildToggle(),
          ),
          // Expanded gives the list all the height left under the toggle
          Expanded(child: _buildSelectedList()),
        ],
      ),
    );
  }

  // Owned / Joined / My Requests: the selected button is highlighted
  Widget _buildToggle() {
    final colors = Theme.of(context).colorScheme;

    return Row(
      children: [
        for (int i = 0; i < _tabs.length; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                backgroundColor: _selectedTab == i
                    ? colors.primary
                    : colors.surfaceContainerHighest,
                foregroundColor: _selectedTab == i
                    ? colors.onPrimary
                    : colors.onSurfaceVariant,
              ),
              onPressed: () {
                setState(() {
                  _selectedTab = i;
                });
              },
              child: Text(
                _tabs[i],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSelectedList() {
    if (_selectedTab == 0) return _buildOwnedList();
    if (_selectedTab == 1) return _buildJoinedList();
    return _buildRequestList();
  }

  Widget _buildOwnedList() {
    final colors = Theme.of(context).colorScheme;

    if (_ownedGroups.isEmpty) {
      return EmptyState(
        icon: Icons.group_add_outlined,
        title: 'No groups yet',
        message: 'Groups you create show up here. Post a group on a board '
            'to start one.',
        buttonLabel: 'Browse boards',
        onPressed: widget.onBrowseBoards,
      );
    }

    return ListView.builder(
      padding: _listPadding,
      itemCount: _ownedGroups.length,
      itemBuilder: (context, index) {
        final group = _ownedGroups[index];
        return GroupCard(
          key: ValueKey(group.id),
          group: group,
          badge: group.pendingCount > 0
              ? StatusLabel(
                  text: '${group.pendingCount} pending',
                  color: colors.error,
                  textColor: colors.onError,
                )
              : null,
          onTap: () => _openManageGroup(group),
        );
      },
    );
  }

  Widget _buildJoinedList() {
    if (_joinedGroups.isEmpty) {
      return EmptyState(
        icon: Icons.groups_outlined,
        title: 'No joined groups yet',
        message: 'Groups that accept your join request show up here.',
        buttonLabel: 'Browse boards',
        onPressed: widget.onBrowseBoards,
      );
    }

    return ListView.builder(
      padding: _listPadding,
      itemCount: _joinedGroups.length,
      itemBuilder: (context, index) {
        final group = _joinedGroups[index];
        return GroupCard(
          key: ValueKey(group.id),
          group: group,
          // TODO: open Group Detail once that screen exists
          onTap: () => showAppSnackBar(context, 'Group Detail coming soon'),
        );
      },
    );
  }

  Widget _buildRequestList() {
    if (_requests.isEmpty) {
      return EmptyState(
        icon: Icons.schedule,
        title: 'No requests yet',
        message: 'Find a group on a board and tap Request to Join. Pending '
            'and declined requests show up here.',
        buttonLabel: 'Browse boards',
        onPressed: widget.onBrowseBoards,
      );
    }

    return ListView.builder(
      padding: _listPadding,
      itemCount: _requests.length,
      itemBuilder: (context, index) {
        final request = _requests[index];
        return GroupCard(
          key: ValueKey(request.group.id),
          group: request.group,
          badge: _buildStatusLabel(request.status),
          // TODO: open Group Detail once that screen exists
          onTap: () => showAppSnackBar(context, 'Group Detail coming soon'),
          action: TextButton(
            onPressed: () => _removeRequest(request),
            child: Text(
              request.status == RequestStatus.pending
                  ? 'Cancel request'
                  : 'Remove',
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusLabel(RequestStatus status) {
    final colors = Theme.of(context).colorScheme;

    if (status == RequestStatus.pending) {
      return const StatusLabel(
        text: 'Pending',
        color: AppColors.warning,
        textColor: Colors.black87,
      );
    }
    return StatusLabel(
      text: 'Declined',
      color: colors.error,
      textColor: colors.onError,
    );
  }
}
