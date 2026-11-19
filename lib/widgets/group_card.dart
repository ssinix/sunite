import 'package:flutter/material.dart';
import 'package:sunite/models/group.dart';
import 'package:sunite/utils/app_spacing.dart';

// One group in a list: category, title, looking-for tags and capacity.
// Screens add their own extras through badge (top right) and action
// (bottom right), e.g. a "2 pending" label or a "Cancel request" button.
class GroupCard extends StatelessWidget {
  final Group group;
  final VoidCallback? onTap;
  final Widget? badge;
  final Widget? action;

  const GroupCard({
    super.key,
    required this.group,
    this.onTap,
    this.badge,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      // Keeps the tap ripple inside the card's rounded corners
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category line, with the badge on the right
              Row(
                children: [
                  Expanded(
                    child: Text(
                      group.categoryLine,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall
                          ?.copyWith(color: colors.onSurfaceVariant),
                    ),
                  ),
                  if (badge != null) ...[
                    const SizedBox(width: AppSpacing.sm),
                    badge!,
                  ],
                ],
              ),
              const SizedBox(height: AppSpacing.xs),

              Text(
                group.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: AppSpacing.sm),

              // Looking-for tags, with the member count on the right
              Row(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: [
                        for (final tag in group.lookingFor)
                          Chip(
                            label: Text(tag),
                            visualDensity: VisualDensity.compact,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Icon(
                    Icons.group_outlined,
                    size: 18,
                    color: colors.onSurfaceVariant,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text('${group.memberCount}/${group.maxMembers}'),
                ],
              ),

              if (action != null)
                Align(alignment: Alignment.centerRight, child: action),
            ],
          ),
        ),
      ),
    );
  }
}
