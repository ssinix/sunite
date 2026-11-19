import 'package:flutter/material.dart';
import 'package:sunite/models/user_profile.dart';

// Round profile picture loaded from the internet (Image.network).
// Shows the initials, e.g. "Ece Ulutaş" -> "EU", while the photo loads,
// if it can't be loaded (e.g. offline) or if the user has no photo.
class UserAvatar extends StatelessWidget {
  final UserProfile user;
  final double radius;

  const UserAvatar({super.key, required this.user, this.radius = 20});

  // First letter of the first and last name
  String get _initials {
    final parts =
        user.fullName.trim().split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final initials = Text(
      _initials,
      style: TextStyle(fontSize: radius * 0.7, fontWeight: FontWeight.w600),
    );
    final photoUrl = user.photoUrl;

    return CircleAvatar(
      radius: radius,
      backgroundColor: colors.primaryContainer,
      foregroundColor: colors.onPrimaryContainer,
      child: photoUrl == null
          ? initials
          // ClipOval cuts the square photo into a circle
          : ClipOval(
              child: Image.network(
                photoUrl,
                width: radius * 2,
                height: radius * 2,
                fit: BoxFit.cover,
                // frame is null until the first frame of the photo arrives
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  return frame == null ? Center(child: initials) : child;
                },
                errorBuilder: (context, error, stackTrace) {
                  return Center(child: initials);
                },
              ),
            ),
    );
  }
}
