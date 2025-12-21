import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  final String _clientId = "nckh_app"; // clientId Keycloak
  final String _issuer = "http://localhost:8180/realms/nckh"; // realm
  final String _clientSecret = "B9OECHjjg8xgjpwGPHCeC5RUMDZeWPAY";
  String? _accessToken;

  // Login với username/email + password
  Future<bool> login({
    required String username,
    required String password,
  }) async {
    try {
      final url = Uri.parse("$_issuer/protocol/openid-connect/token");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          "grant_type": "password",
          "client_id": _clientId,
          "client_secret": _clientSecret,
          "username": username,
          "password": password,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _accessToken = data['access_token'];
        await _secureStorage.write(key: 'access_token', value: _accessToken);
        return true;
      } else {
        print("Login failed: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Login error: $e");
      return false;
    }
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: 'access_token');
    _accessToken = null;
  }

  Future<String?> getToken() async {
    if (_accessToken != null) return _accessToken;
    return await _secureStorage.read(key: 'access_token');
  }
}
