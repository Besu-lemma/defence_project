// lib/services/irrigation_history_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/irrigation_event.dart';

class IrrigationHistoryService {
  static const String _baseUrl = 'http://192.168.0.4'; // Replace with your ESP32 IP
  static const Duration timeout = Duration(seconds: 5);

  static Future<List<IrrigationEvent>> getHistory() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/history'),
        headers: {'Accept': 'application/json'},
      ).timeout(timeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> events = data['events'] ?? [];
        return events.map((json) => _parseEvent(json)).toList();
      }
      throw Exception('Failed to load history. Status: ${response.statusCode}');
    } catch (e) {
      throw Exception('History service error: $e');
    }
  }

  static IrrigationEvent _parseEvent(Map<String, dynamic> json) {
    return IrrigationEvent(
      eventType: json['type'] ?? 'UNKNOWN',
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        (json['timestamp'] ?? 0) * 1000, // Convert seconds to milliseconds
      ),
      durationInMinutes: (json['duration'] ?? 0) ~/ 60, // Convert seconds to minutes
      waterUsed: null, // Not available in ESP32 response
      soilMoisture: (json['soilMoisture'] ?? 0).toDouble(),
      temperature: (json['temperature'] ?? 0).toDouble(),
      humidity: (json['humidity'] ?? 0).toDouble(),
      pumpStatus: json['pump_status'] ?? 'UNKNOWN',
      isOverride: json['override'] ?? false,
      notes: json['type'] == 'MANUAL' ? 'Manual override' : 'Automatic irrigation',
    );
  }

  // For future use if you add backend logging
  static Future<bool> logEvent(IrrigationEvent event) async {
    // This would now send to ESP32 if you implement logging there
    return false; // Currently not implemented
  }
}