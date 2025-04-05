import 'dart:convert';
import 'package:http/http.dart' as http;

class RecommendationModel {
  final String baseUrl;

  RecommendationModel({this.baseUrl = 'https://6rc1m9jm-8000.uks1.devtunnels.ms/recommendations/'});

  Future<List<Map<String, dynamic>>> getRecommendations({
    required String maxRent,
    required String maxDistance,
    String? roomType,
  }) async {
    try {
      // Construct query parameters
      final params = {
        'max_rent': maxRent,
        'max_distance': maxDistance,
        if (roomType != null) 'room_type': roomType,
      };

      // Build URI with query parameters
      final uri = Uri.parse(baseUrl).replace(queryParameters: params);

      final response = await http.get(uri, headers: {
        'Content-Type': 'application/json'
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception(
            'Failed to load recommendations. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch recommendations: $e');
    }
  }
}
