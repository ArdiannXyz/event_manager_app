import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/event.dart';
import 'auth_service.dart';

class ApiService {
  static String get baseUrl => dotenv.env['API_BASE_URL'] ?? '';

  static Future<Map<String, String>> _getHeaders() async {
    final token = await AuthService.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<List<Event>> getEvents({
    String? search,
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final headers = await _getHeaders();
      final queryParams = {
        if (search != null && search.isNotEmpty) 'search': search,
        'page': page.toString(),
        'per_page': perPage.toString(),
      };

      final uri =
          Uri.parse('$baseUrl/events').replace(queryParameters: queryParams);
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final eventsData = data['events'] ?? data['data'] ?? [];
        return (eventsData as List)
            .map((json) => Event.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load events: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching events: $e');
      return [];
    }
  }

  static Future<Event?> getEvent(String id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/events/$id'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Event.fromJson(data['event'] ?? data);
      } else {
        throw Exception('Failed to load event: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching event: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getOrder(String id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/orders/$id'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['order'] ?? data;
      } else {
        throw Exception('Failed to load order: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching order: $e');
      return null;
    }
  }

  static Future<bool> sendFCMToken(String token) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/me/fcm-token'),
        headers: headers,
        body: json.encode({'fcm_token': token}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error sending FCM token: $e');
      return false;
    }
  }
}
