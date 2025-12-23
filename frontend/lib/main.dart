import 'package:flutter/material.dart';
import 'package:frontend/home_page.dart';
import 'package:frontend/login_screen.dart';
import 'landingpage.dart';
import 'auth_gate.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Inter'),

      home: const LandingPage(),

      routes: {
        '/login': (_) => const LoginPage(),

        '/home': (_) => const AuthGate(child: HomePage()),
      },
    );
  }
}
