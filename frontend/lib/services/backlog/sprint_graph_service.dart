import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../auth/auth_service.dart';
import 'package:flutter/foundation.dart'; // Để check kIsWeb
import 'dart:io'; // Để check Platform

class SprintGraphService {
  Future<GraphQLClient> _getClient() async {
    final token = await AuthService.instance.getValidAccessToken();

    // 1. Cấu hình đường dẫn chính xác theo Postman của bạn
    // Postman: http://localhost:8080/api/graphql
    String url;
    if (kIsWeb) {
      url = 'http://127.0.0.1:8080/api/graphql'; // Web dùng localhost
    } else if (Platform.isAndroid) {
      url = 'http://10.0.2.2:8080/api/graphql'; // Android dùng 10.0.2.2
    } else {
      url = 'http://localhost:8080/api/graphql'; // iOS/Máy thật
    }

    print("Connecting to Graph API: $url"); // In log để kiểm tra

    final HttpLink httpLink = HttpLink(
      url,
      defaultHeaders: {
        'Authorization': 'Bearer $token',
        'x-api-key': dotenv.env['API_KEY'] ?? '',
        'Access-Control-Allow-Origin': '*',
      },
    );

    return GraphQLClient(cache: GraphQLCache(), link: httpLink);
  }

  Future<Map<String, dynamic>?> fetchSprintGraph(String sprintId) async {
    final client = await _getClient();

    const String query = r'''
      query getSprintGraph($id: ID!) {
        sprintGraph(sprintId: $id) {
          nodes { id type }
          edges { from to type }
        }
      }
    ''';

    final QueryOptions options = QueryOptions(
      document: gql(query),
      variables: {'id': sprintId},
      fetchPolicy: FetchPolicy.networkOnly,
    );

    final result = await client.query(options);

    if (result.hasException) {
      print("Graph Error: ${result.exception.toString()}");
      return null;
    }

    print("Graph Data: ${result.data?['sprintGraph']}");

    return result.data?['sprintGraph'];
  }
}
