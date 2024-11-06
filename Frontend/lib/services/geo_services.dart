import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, double>> getCoordinatesFromCity(String city) async {
  // Default coordinates (fallback)
  final defaultCoords = {
    'latitude': 6.9271,
    'longitude': 79.8612
  };

  try {
    // Add delay for rate limiting
    await Future.delayed(Duration(milliseconds: 1000));

    final response = await http.get(
      Uri.parse('https://nominatim.openstreetmap.org/search?city=$city&format=json'),
      headers: {
        'User-Agent': 'TapOn_App/1.0',
        'Accept': 'application/json'
      },
    );

    if (response.statusCode != 200) {
      print('Error: Status code ${response.statusCode}');
      print('Response body: ${response.body}');
      return defaultCoords;
    }

    // Validate response is JSON
    if (!response.body.startsWith('[')) {
      print('Invalid response format: ${response.body.substring(0, 50)}...');
      return defaultCoords;
    }

    final data = jsonDecode(response.body);
    
    if (data.isEmpty) {
      print('No results found for city: $city');
      return defaultCoords;
    }

    try {
      final lat = double.parse(data[0]['lat']);
      final lon = double.parse(data[0]['lon']);
      return {'latitude': lat, 'longitude': lon};
    } on FormatException catch (e) {
      print('Error parsing coordinates: $e');
      return defaultCoords;
    }

  } catch (e) {
    print('Error fetching coordinates: $e');
    return defaultCoords;
  }
}

Future<String> getCityFromCoordinates(double lat, double lon) async {
  try {
    await Future.delayed(Duration(milliseconds: 1000));

    final response = await http.get(
      Uri.parse('https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$lon&format=json'),
      headers: {
        'User-Agent': 'TapOn_App/1.0',
        'Accept': 'application/json'
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['address']['city'] ?? data['address']['town'] ?? 'Unknown';
    }
    return 'Unknown';
  } catch (e) {
    print('Error reverse geocoding: $e');
    return 'Unknown';
  }
}
