import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sunite/screens/login/login_screen.dart'; // for InputBox and AppLogo

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  String? _emailError;
  String? _confirmError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _createAccount() {
    setState(() {
      _emailError = _emailController.text.trim().endsWith('@sabanciuniv.edu')
          ? null
          : "Must be @sabanciuniv.edu";
      _confirmError = _passwordController.text == _confirmController.text
          ? null
          : "Passwords do not match";
    });

    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final fieldWidth = min(MediaQuery.sizeOf(context).width * 0.8, 300.0);

    return Scaffold(

      appBar: AppBar(title: const Text("Sign Up"), centerTitle: true),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const AppLogo(size: 60),
              const SizedBox(height: 10),
              const Text("Create your SUnite account", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              const SizedBox(height: 20),
              InputBox(
                title: "Full name",
                controller: _nameController,
                placeholderValue: "Azra At",
                width: fieldWidth,
              ),
              const SizedBox(height: 10),
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
              const SizedBox(height: 10),
              InputBox(
                title: "Confirm password",
                controller: _confirmController,
                placeholderValue: "********",
                errorText: _confirmError,
                obscureText: true,
                width: fieldWidth,
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _createAccount,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  minimumSize: const Size(200, 50),
                ),
                child: const Text("Create Account"),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Already have an account? Log in"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
