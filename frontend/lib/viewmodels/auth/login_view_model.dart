<<<<<<< HEAD
import '../../services/auth_service.dart';
=======
import 'package:frontend/services/auth/auth_service.dart';
>>>>>>> main

class LoginViewModel {
  final AuthService _auth = AuthService.instance;

  Future<bool> login({required String username, required String password}) {
    return _auth.login(username: username, password: password);
  }

  Future<bool> loginWithGoogle() async {
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }

  Future<bool> loginWithGithub() async {
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> main
