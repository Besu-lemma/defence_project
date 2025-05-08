import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String baseUrl = 'https://api.open-meteo.com/v1/forecast';

  // Fetch weather data (for temperature, wind speed, etc.)
  Future<Map<String, dynamic>> fetchWeather(double latitude, double longitude) async {
    final url = Uri.parse(
      '$baseUrl?latitude=$latitude&longitude=$longitude&current_weather=true&temperature_unit=celsius&windspeed_unit=kmh'
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);  // Parse the response body into a map
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
