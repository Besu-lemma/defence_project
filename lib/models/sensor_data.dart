import 'package:hive/hive.dart';

part 'sensor_data.g.dart';

@HiveType(typeId: 0)
class SensorData extends HiveObject {
  @HiveField(0)
  final double soilMoisture;

  @HiveField(1)
  final double temperature;

  @HiveField(2)
  final double humidity;

  @HiveField(3)
  final double waterLevel;

  SensorData({
    required this.soilMoisture,
    required this.temperature,
    required this.humidity,
    required this.waterLevel,
  });
}
