// ✅ Updated main.dart (no Gemini)

import 'package:flutter/material.dart';
import 'screens/pin_lock_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
