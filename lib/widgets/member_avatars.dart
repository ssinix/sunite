import 'package:flutter/material.dart';
import 'package:sunite/models/group.dart';
import 'package:sunite/models/user_profile.dart';
import 'package:sunite/widgets/user_avatar.dart';

// A group's members as small profile circles, plus an empty circle for
// each open spot (e.g. 3 photos + 2 empty circles for 3/5)
class MemberAvatars extends StatelessWidget {
  final Group group;
  final double radius;
  final WrapAlignment alignment;

  // Optional: called when a member's circle is tapped
  final void Function(UserProfile member)? onMemberTap;

  const MemberAvatars({
    super.key,
    required this.group,
    this.radius = 20,
    this.alignment = WrapAlignment.start,
    this.onMemberTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final spacing = radius / 3;

    // Wrap moves circles to a new line if a big group doesn't fit
    return Wrap(
      alignment: alignment,
      spacing: spacing,
      runSpacing: spacing,
      children: [
        for (final member in group.members)
          Tooltip(
            message: member.fullName,
            child: GestureDetector(
              onTap: onMemberTap == null ? null : () => onMemberTap!(member),
              child: UserAvatar(user: member, radius: radius),
            ),
          ),
        for (int i = group.memberCount; i < group.maxMembers; i++)
          Container(
            width: radius * 2,
            height: radius * 2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: colors.outlineVariant, width: 1.5),
            ),
          ),
      ],
    );
  }
}
