import 'package:http/http.dart' as http;
import 'auth_service.dart';
import 'dart:convert';

class ApiService {
  final AuthService _authService = AuthService();
  final String _baseUrl = "http://localhost:8080/api";

  Future<Map<String, dynamic>?> getMyProfile() async {
    final token = await _authService.getToken();
    if (token == null) return null;

    final response = await http.get(
      Uri.parse("$_baseUrl/my-profile"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print("Error fetching profile: ${response.body}");
      return null;
    }
  }

  Future<Map<String, dynamic>?> register(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/register"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print("Registration error: ${response.body}");
      return null;
    }
  }
}
