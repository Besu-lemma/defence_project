import 'dart:async';
import 'package:final_project/models/sensor_data.dart';

class SensorService {
  StreamController<SensorData> _controller = StreamController.broadcast();
  Timer? _demoTimer;

  void startListening(void Function(SensorData) onData) {
    _controller.stream.listen(onData);

    // For demo: simulate data updates every 3 seconds
    _demoTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      final data = SensorData(
        soilMoisture: 60 + (10 * _randomFactor()),
        temperature: 25 + (5 * _randomFactor()),
        humidity: 50 + (10 * _randomFactor()),
        waterLevel: 80 + (10 * _randomFactor()),
      );
      _controller.add(data);
    });
  }

  void stopListening() {
    _demoTimer?.cancel();
    _controller.close();
  }

  double _randomFactor() {
    return (DateTime.now().millisecondsSinceEpoch % 100) / 100.0;
  }
}
