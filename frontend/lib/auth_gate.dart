import 'package:flutter/material.dart';
import 'package:frontend/services/auth/auth_service.dart';
import 'login_screen.dart';

class AuthGate extends StatelessWidget {
  final Widget child;
  const AuthGate({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService.instance.isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data == true) {
          return child;
        }

        return const LoginPage();
      },
    );
  }
}
