import 'package:flutter/material.dart';

// O4. Confirmation dialog for destructive actions (Delete Group, and
// Delete post on My Posts). The confirm button is red.
// Returns true only if the user taps the confirm button.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
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
            style: FilledButton.styleFrom(
              backgroundColor: colors.error,
              foregroundColor: colors.onError,
            ),
            child: Text(confirmLabel),
          ),
        ],
      );
    },
  );

  // null when the dialog is closed by tapping outside it or pressing back
  return confirmed ?? false;
}
