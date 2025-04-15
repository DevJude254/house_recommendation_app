import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:unistay/model/prediction_model.dart';

class ApiService {
  static const String _baseUrl = "https://6rc1m9jm-8001.uks1.devtunnels.ms/predict_rent_and_recommendations";

  // Function to make the API call for rent prediction and recommendations
  static Future<Map<String, dynamic>> predictRentAndRecommend(
      RentPredictionRequest request) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        // Decode the response body
        final Map<String, dynamic> data = jsonDecode(response.body);


        // Safely cast top_5_locations or assign an empty list
        List topLocations = (data['top_5_locations'] as List?)?.map((location) {
          return location;
        }).toList() ?? [];

        // Safely check for predicted rent price and top 5 locations
        final predictedRentPrice = data['predicted_rent_price'] ?? 0.0; // Default to 0 if null


        // Return a cleaned-up response
        return {
          'predicted_rent_price': predictedRentPrice,
          'top_5_locations': topLocations,
        };
      } else {
        // If the server returns an error response, throw an exception
        throw Exception('Prediction failed: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      // Catch and throw an exception if there's any error in the request
      throw Exception('Failed to make API request: $e');
    }
  }
}
