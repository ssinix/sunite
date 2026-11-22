import 'package:flutter/material.dart';
import 'package:sunite/models/user_profile.dart';
import 'package:sunite/screens/profile/edit_profile_screen.dart';
import 'package:sunite/screens/profile/widgets/profile_view.dart';
import 'package:sunite/utils/app_spacing.dart';
import 'package:sunite/screens/profile/my_posts_screen.dart';

// 11. My Profile: the user's own profile as others see it, plus the
// owner-only controls (Edit Profile, My Posts, Log Out)
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Sample data until profiles come from the backend
  UserProfile _profile = SampleProfiles.currentUser;

  // Opens Edit Profile and shows the saved changes when it returns
  Future<void> _openEditProfile() async {
    final updated = await Navigator.push<UserProfile>(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(profile: _profile),
      ),
    );
    if (updated != null) {
      setState(() {
        _profile = updated;
      });
    }
  }

  // TODO: replace with navigation once these screens exist
  void _comingSoon(String screenName) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$screenName coming soon')));
  }

  Future<void> _confirmLogOut() async {
    final logOut = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text('You will need to log in again to use SUnite.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
    if (logOut == true) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            tooltip: 'Edit Profile',
            icon: const Icon(Icons.edit_outlined),
            onPressed: _openEditProfile,
          ),
        ],
      ),
      body: ProfileView(
        profile: _profile,
        onGroupTap: (group) => _comingSoon('Group Detail'),
        footer: [
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _openEditProfile,
                  child: const Text('Edit Profile'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyPostsScreen()),
                  ),
                  child: const Text('My Posts'),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          TextButton.icon(
            onPressed: _confirmLogOut,
            icon: const Icon(Icons.logout),
            label: const Text('Log Out'),
            style: TextButton.styleFrom(foregroundColor: colors.error),
          ),
        ],
      ),
    );
  }
}
