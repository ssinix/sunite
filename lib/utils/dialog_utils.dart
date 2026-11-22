import 'package:flutter/material.dart';

// Confirmation dialog, e.g. O4 Delete Group or O2 Request to join.
// The confirm button is red for destructive actions (isDestructive).
// Returns true only if the user taps the confirm button.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  bool isDestructive = true,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) {
      final colors = Theme.of(context).colorScheme;

      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            // null keeps the theme's normal button colors
            style: isDestructive
                ? FilledButton.styleFrom(
                    backgroundColor: colors.error,
                    foregroundColor: colors.onError,
                  )
                : null,
            child: Text(confirmLabel),
          ),
        ],
      );
    },
  );

  // null when the dialog is closed by tapping outside it or pressing back
  return confirmed ?? false;
}
