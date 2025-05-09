import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/sensor_data.dart';
import 'models/pump_log.dart';
import 'screens/pin_lock_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(SensorDataAdapter());
  Hive.registerAdapter(PumpLogAdapter());

  await Hive.openBox<SensorData>('sensorDataBox');
  await Hive.openBox<PumpLog>('pumpLogBox');

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mesno-Tech',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const PinLockScreen(),
    );
  }
}
