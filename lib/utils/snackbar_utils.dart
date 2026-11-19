import 'package:flutter/material.dart';

// Shows a short message at the bottom of the screen.
// Hides the current one first, so quick taps don't queue up messages.
void showAppSnackBar(BuildContext context, String message) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(SnackBar(content: Text(message)));
}
