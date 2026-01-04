import 'package:flutter/material.dart';
<<<<<<< HEAD
import '../services/auth_service.dart';
=======
import '../services/auth/auth_service.dart';
>>>>>>> main
import '../views/home/home_page.dart';
import '../views/landingpage.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key, required HomePage child});

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

        if (snapshot.hasData && snapshot.data == true) {
          return const HomePage();
        }

        return const LandingPage();
      },
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> main
