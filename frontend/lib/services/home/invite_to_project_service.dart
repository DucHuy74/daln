import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../auth/auth_service.dart';
import '../../models/home/workspace_model.dart';

class InvitationService {
  static const String _baseUrl = 'http://localhost:8080/api';

  Future<bool> sendInvites(
    String workspaceId,
    List<String> emails,
    WorkspaceRole role,
  ) async {
    final url = Uri.parse('$_baseUrl/workspace/$workspaceId/invitations');

    final token = await AuthService.instance.getValidAccessToken();

    try {
      List<Future<http.Response>> requests = emails.map((email) {
        return http.post(
          url,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
            'x-api-key': dotenv.env['API_KEY'] ?? '',
          },
          body: jsonEncode({"email": email, "role": role.name}),
        );
      }).toList();

      final responses = await Future.wait(requests);
      bool allSuccess = responses.every(
        (res) => res.statusCode >= 200 && res.statusCode < 300,
      );

      return allSuccess;
    } catch (e) {
      print('Invitation Error: $e');
      throw Exception('Lỗi kết nối: $e');
    }
  }
}
