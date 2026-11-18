import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sunite/models/user_profile.dart';
import 'package:sunite/screens/profile/widgets/profile_view.dart';

// 12. Other User's Profile: same layout as My Profile, without the
// owner-only controls. The SU e-mail is how students contact each other.
//
// Open it with:
//   Navigator.push(context, MaterialPageRoute(
//     builder: (context) => OtherProfileScreen(profile: someProfile)));
class OtherProfileScreen extends StatelessWidget {
  final UserProfile profile;

  const OtherProfileScreen({super.key, required this.profile});

  // No in-app chat or mail package yet, so copy the address for the user
  Future<void> _copyEmail(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: profile.email));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('${profile.email} copied to clipboard')),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ProfileView(
        profile: profile,
        belowEmail: OutlinedButton(
          onPressed: () => _copyEmail(context),
          child: const Text('Contact by e-mail'),
        ),
        onGroupTap: (group) {
          // TODO: open Group Detail once that screen exists
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Group Detail coming soon')),
            );
        },
      ),
    );
  }
}
