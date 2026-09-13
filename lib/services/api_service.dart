import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/destination.dart';

class ApiService {
  // Direct API key (SECURITY: production me .env use karo)
  static const String _apiKey = 'rc_live_2f93b4bb88484e79b5032ff493293ad7';
  static const String _baseUrl =
      'https://api.restcountries.com/countries/v5?limit=50&pretty=1';

  Future<List<Destination>> fetchDestinations() async {
    try {
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final dynamic decoded = jsonDecode(response.body);
        final List<dynamic> data = decoded is List
            ? decoded
            : (decoded['data']?['objects'] ??
            decoded['data'] ??
            decoded['countries'] ??
            []);
        return data.map((json) => Destination.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw Exception('API key invalid hai');
      } else if (response.statusCode == 403) {
        throw Exception('API quota khatam ho gaya hai');
      } else if (response.statusCode == 429) {
        throw Exception('Rate limit - thodi der baad try karo');
      } else {
        throw Exception('API error (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}