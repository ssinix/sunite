import 'package:flutter/material.dart';
import 'package:sunite/utils/app_spacing.dart';

// Small colored pill, e.g. "2 pending" or a join request's status
class StatusLabel extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;

  const StatusLabel({
    super.key,
    required this.text,
    required this.color,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
