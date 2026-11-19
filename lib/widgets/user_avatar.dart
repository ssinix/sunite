import 'package:flutter/material.dart';

// Round avatar with the person's initials, e.g. "Ece Ulutaş" -> "EU".
// The network profile photo will be added here later.
class UserAvatar extends StatelessWidget {
  final String name;
  final double radius;

  const UserAvatar({super.key, required this.name, this.radius = 20});

  // First letter of the first and last name
  String get _initials {
    final parts = name.trim().split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return CircleAvatar(
      radius: radius,
      backgroundColor: colors.primaryContainer,
      foregroundColor: colors.onPrimaryContainer,
      child: Text(
        _initials,
        style: TextStyle(
          fontSize: radius * 0.7,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
