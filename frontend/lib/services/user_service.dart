import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class UserService {
  final AuthService _authService = AuthService();
  final String _baseUrl = "http://localhost:8080/api";

  Future<http.Response> register({
    required String username,
    required String password,
    required String email,
    required String firstName,
    required String lastName,
    required String dob,
  }) {
    final url = Uri.parse("$_baseUrl/register");
    final body = jsonEncode({
      "username": username,
      "password": password,
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "dob": dob,
    });

    return http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );
  }

  Future<http.Response> getProfile() async {
    final token = await _authService.getToken();
    final url = Uri.parse("$_baseUrl/my-profile");

    return http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );
  }
}
