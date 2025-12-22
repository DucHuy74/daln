import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  final String _clientId = "nckh_app";
  final String _issuer = "http://localhost:8180/realms/nckh";
  final String _clientSecret = "B9OECHjjg8xgjpwGPHCeC5RUMDZeWPAY";
  String? _accessToken;

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    final res = await http.post(
      Uri.parse("$_issuer/protocol/openid-connect/token"),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {
        "grant_type": "password",
        "client_id": _clientId,
        "client_secret": _clientSecret,
        "username": username,
        "password": password,
      },
    );

    if (res.statusCode == 200) {
      final data = json.decode(res.body);

      final accessToken = data['access_token'];
      final refreshToken = data['refresh_token'];
      final expiresIn = data['expires_in'];

      final expiresAt =
          DateTime.now().millisecondsSinceEpoch + expiresIn * 1000;

      await _secureStorage.write(key: 'access_token', value: accessToken);
      await _secureStorage.write(key: 'refresh_token', value: refreshToken);
      await _secureStorage.write(
        key: 'expires_at',
        value: expiresAt.toString(),
      );

      _accessToken = accessToken;
      return true;
    }

    return false;
  }

  Future<void> logout() async {
    await _secureStorage.deleteAll();
    _accessToken = null;
  }

  Future<String?> getToken() async {
    if (await isAccessTokenExpired()) {
      final ok = await refreshToken();
      if (!ok) return null;
    }
    return await _secureStorage.read(key: 'access_token');
  }

  Future<bool> refreshToken() async {
    final refreshToken = await _secureStorage.read(key: 'refresh_token');

    if (refreshToken == null) return false;

    final res = await http.post(
      Uri.parse("$_issuer/protocol/openid-connect/token"),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {
        "grant_type": "refresh_token",
        "client_id": _clientId,
        "client_secret": _clientSecret,
        "refresh_token": refreshToken,
      },
    );

    if (res.statusCode == 200) {
      final data = json.decode(res.body);

      final accessToken = data['access_token'];
      final newRefreshToken = data['refresh_token'];
      final expiresIn = data['expires_in'];

      final expiresAt =
          DateTime.now().millisecondsSinceEpoch + expiresIn * 1000;

      await _secureStorage.write(key: 'access_token', value: accessToken);
      await _secureStorage.write(key: 'refresh_token', value: newRefreshToken);
      await _secureStorage.write(
        key: 'expires_at',
        value: expiresAt.toString(),
      );

      _accessToken = accessToken;
      return true;
    }

    return false;
  }

  Future<bool> isAccessTokenExpired() async {
    final expiresAtStr = await _secureStorage.read(key: 'expires_at');
    if (expiresAtStr == null) return true;

    final expiresAt = int.parse(expiresAtStr);
    return DateTime.now().millisecondsSinceEpoch > expiresAt;
  }
}
