import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

import '../widgets/sensor_card.dart';
import '../services/weather_service.dart';
import '../services/notification_service.dart';
import '../utils/language_strings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();
  Map<String, dynamic> _weatherData = {};
  Map<String, dynamic>? _sensorData;
  bool _isOfflineData = false;
  bool _loading = true;
  String _error = '';
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    fetchAllData();
    // _refreshAll();
    _timer = Timer.periodic(const Duration(seconds: 10), (_) => _fetchSensorData());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> fetchAllData() async {
    await Future.wait([
      _fetchWeather(),
      
      _fetchSensorData(),
    ]);
  }

  Future<void> _fetchWeather() async {
    print('Weather API response: $_weatherData');

    try {
      final data = await _weatherService.fetchWeather(9.03, 38.74);
      setState(() {
        _weatherData = data;
      });
    } catch (e) {
      NotificationService.addNotification(
        'Weather Error',
        'Failed to fetch weather data',
      );
    }
  }


  Future<void> _fetchSensorData() async {
    try {
      final response = await http
          .get(Uri.parse('http://192.168.9.131/data'))
          .timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _sensorData = data;
          _isOfflineData = false;
          _loading = false;
        });

        final box = await Hive.openBox('sensor_data');
        await box.put('latest', data);
      } else {
        await _loadOfflineData();
      }
    } catch (e) {
      await _loadOfflineData();
    }
  }

  Future<void> _loadOfflineData() async {
    final box = await Hive.openBox('sensor_data');
    final data = box.get('latest');

    if (data != null && mounted) {
      setState(() {
        _sensorData = Map<String, dynamic>.from(data);
        _isOfflineData = true;
        _loading = false;
      });
    }
  }

  IconData _iconForWeatherCode(int code) {
    if (code == 0) return Icons.wb_sunny;
    if (code <= 3) return Icons.wb_cloudy;
    if (code <= 48) return Icons.cloud;
    if (code <= 67) return Icons.grain;
    if (code <= 82) return Icons.beach_access;
    if (code >= 95) return Icons.flash_on;
    return Icons.help_outline;
  }
Widget _buildWeatherCard() {
  final temperature = _weatherData['current_weather']?['temperature'];
  final wind = _weatherData['current_weather']?['windspeed'];
  final pumpStatus = _sensorData != null ? _sensorData!['pumpStatus'] : null;

  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'WEATHER CONDITIONS',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  const Icon(Icons.thermostat, size: 40, color: Colors.orange),
                  const SizedBox(height: 8),
                  Text(
                    // temperature != null ? '${temperature.toStringAsFixed(1)}°C' 
                    // : '--',
                    '${temperature?.toStringAsFixed(1) ?? "--"}°C',
                    style: const TextStyle(fontSize: 24),
                  ),
                  const Text('Temperature'),
                ],
              ),
              Column(
                children: [
                  const Icon(Icons.wind_power, size: 40, color: Colors.orange),
                  const SizedBox(height: 8),
                  Text(
                    // temperature != null ? '${temperature.toStringAsFixed(1)}°C' 
                    // : '--',
                    '${_weatherData['current_weather']?['windspeed']?.toStringAsFixed(1) ?? "--"} km/h',
                 style: TextStyle(fontSize: 16),
                  ),
                  const Text('wind'),
                ],
              ),
              Column(
                children: [
                  const Icon(Icons.power, size: 40, color: Colors.blue),
                  const SizedBox(height: 8),
                  Text(
                    pumpStatus != null ? pumpStatus.toString() : '--',
                    style: TextStyle(
                      fontSize: 18,
                      color: pumpStatus == "ON" ? Colors.green : Colors.red,
                    ),
                  ),
                  const Text('Pump status'),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}


  Widget _buildSensorGrid() {
    if (_loading) return const Center(child: CircularProgressIndicator());

    final s = _sensorData!;
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        SensorCard(
          icon: Icons.grass,
          title: tr('soil_moisture'),
          value: s['soilMoisture'].toString(),
          unit: '%',
        ),
        SensorCard(
          icon: Icons.water,
          title: tr('water_level'),
          value: s['waterLevel'].toString(),
          unit: '%',
        ),
        SensorCard(
          icon: Icons.thermostat,
          title: tr('temperature'),
          value: s['temperature'].toString(),
          unit: '°C',
        ),
        SensorCard(
          icon: Icons.water_drop,
          title: tr('humidity'),
          value: s['humidity'].toString(),
          unit: '%',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildWeatherCard(),
        Expanded(child: _buildSensorGrid()),
        if (_error.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(_error, style: const TextStyle(color: Colors.red)),
          ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            _isOfflineData
                ? tr('offline_data_message')
                : tr('live_data_message'),
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: _isOfflineData ? Colors.red : Colors.green,
            ),
          ),
        ),
      ],
    );
  }

//   void fetchAllData() {}
// }
}