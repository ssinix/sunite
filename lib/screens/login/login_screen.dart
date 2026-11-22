import 'dart:math';

import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _emailError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _logIn() {
    setState(() {
      _emailError = _emailController.text.trim().endsWith('@sabanciuniv.edu')
          ? null
          : "Must be @sabanciuniv.edu";
    });

    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    final fieldWidth = min(MediaQuery.sizeOf(context).width * 0.8, 300.0);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const AppLogo(size: 90),
              const SizedBox(height: 20),
              const Text("SUnite", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
              const Text("Find your group at Sabancı"),
              const SizedBox(height: 20),
              InputBox(
                title: "SU e-mail",
                controller: _emailController,
                placeholderValue: "name@sabanciuniv.edu",
                errorText: _emailError,
                width: fieldWidth,
              ),
              const SizedBox(height: 10),
              InputBox(
                title: "Password",
                controller: _passwordController,
                placeholderValue: "********",
                obscureText: true,
                width: fieldWidth,
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _logIn,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  minimumSize: const Size(200, 50),
                ),
                child: const Text("Log In"),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/signup'),
                child: const Text("No account? Create account"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppLogo extends StatelessWidget {
  final double size;

  const AppLogo({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(width: 3),
        borderRadius: BorderRadius.circular(size * 0.2),
      ),
      child: Text("SU", style: TextStyle(fontWeight: FontWeight.bold, fontSize: size * 0.35)),
    );
  }
}


class InputBox extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final String? placeholderValue;
  final String? errorText;
  final bool obscureText;
  final double? width;

  const InputBox({
    super.key,
    required this.title,
    required this.controller,
    this.placeholderValue,
    this.errorText,
    this.obscureText = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 5),
          TextFormField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              hintText: placeholderValue,
              errorText: errorText,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(width: 1.5, color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(width: 2, color: Colors.grey),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(width: 1.5, color: Colors.red),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(width: 2, color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
