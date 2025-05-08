import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/notification_service.dart';
import '../services/weather_service.dart';
import '../utils/language_strings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();
  Map<String, dynamic> _w = {};
  Map<String, dynamic> _s = {};
  bool _loading = true;
  String _error = '';
  late Timer _timer;
  final String _ip = '192.168.0.12';

  @override
  void initState() {
    super.initState();
    _refreshAll();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _fetchSensor());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _refreshAll() async {
    try {
      _w = await _weatherService.fetchWeather(9.03, 38.74);
    } catch (_) {
      NotificationService.addNotification('Weather Error', 'Failed to fetch weather');
    }
    await _fetchSensor();
  }

  Future<void> _fetchSensor() async {
    try {
      final res = await http
          .get(Uri.parse('http://$_ip/data'))
          .timeout(const Duration(seconds: 3));
      if (res.statusCode == 200) {
        _s = json.decode(res.body);
        setState(() => _loading = false);
      }
    } catch (e) {
      setState(() {
        _error = e is TimeoutException ? 'Connection timeout' : 'Error: $e';
      });
    }
  }

  IconData _iconForCode(int code) {
    if (code == 0) return Icons.wb_sunny;
    if (code <= 3) return Icons.wb_cloudy;
    if (code <= 48) return Icons.cloud;
    if (code <= 67) return Icons.grain;
    if (code <= 82) return Icons.beach_access;
    if (code >= 95) return Icons.flash_on;
    return Icons.help_outline;
  }

  Widget _weatherCard() {
    final current = _w['current_weather'] ?? {};
    final code = current['weathercode'] as int? ?? 0;
    final temp = (current['temperature'] as num?)?.toStringAsFixed(1) ?? '--';
    final wind = (current['windspeed'] as num?)?.toStringAsFixed(1) ?? '--';
    final pumpOn = _s['pumpStatus'] == 'ON';

    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          children: [
            Icon(_iconForCode(code), size: 64, color: Colors.orange),
            const SizedBox(height: 12),
            Text(
              '$temp°C',
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              _w['weather_descriptions'] != null
                  ? (_w['weather_descriptions'][0] as String)
                  : tr('weather_conditions'),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.air, color: Colors.blue),
                const SizedBox(width: 6),
                Text('$wind m/s', style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 24),
                Icon(Icons.power, color: pumpOn ? Colors.green : Colors.red),
                const SizedBox(width: 6),
                Text(
                  pumpOn ? tr('pump_active') : tr('pump_inactive'),
                  style: TextStyle(
                    fontSize: 16,
                    color: pumpOn ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _sensorGrid() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    return GridView.count(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.2,
      children: [
         _sensorCard(tr('soil_moisture'), '${_s['soilMoisture'] ?? '--'}', Icons.grass, Colors.green),
  _sensorCard(tr('water_level'), '${_s['waterLevel'] ?? '--'}%', Icons.water, Colors.blue),
  _sensorCard(tr('temperature'), '${_s['temperature'] ?? '--'}°C', Icons.thermostat, Colors.orange),
  _sensorCard(tr('humidity'), '${_s['humidity'] ?? '--'}%', Icons.water_drop, Colors.blue),
      ],
    );
  }

  Widget _sensorCard(String label, String value, IconData icon, Color color) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, size: 36, color: color),
          const SizedBox(height: 8),
          Text(value,
              style:
                  TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 14)),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _weatherCard(),
        Expanded(child: _sensorGrid()),
        if (_error.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(_error, style: const TextStyle(color: Colors.red)),
          ),
      ],
    );
  }

  void fetchAllData() {}
}
