import 'package:flutter/material.dart';

class VerifyEmailScreen extends StatelessWidget {
  final String email;

  const VerifyEmailScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 40,
                child: Icon(Icons.mail_outline, size: 36),
              ),
              const SizedBox(height: 20),
              const Text("Verify your e-mail", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
              const SizedBox(height: 10),
              const Text("We sent a link to"),
              Text(email, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text(
                "Open the link in your inbox, then come back and continue.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              FilledButton(
                // No backend yet: go to the main page and clear login/sign-up/verify from the back stack
                onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  minimumSize: const Size(200, 50),
                ),
                child: const Text("I've verified"),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Verification link sent")),
                ),
                child: const Text("Didn't get it? Resend link"),
              ),
              const SizedBox(height: 10),
              const Text(
                "Unverified accounts cannot post or join groups.",
                style: TextStyle(color: Colors.grey, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
