import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'screens/pin_lock_screen.dart';
import 'screens/main_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Gemini.init(
    apiKey: 'AIzaSyBNRytdMFGl1SMX0SUK-IFx3217tpVTLP4', // Replace with your Gemini API key
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Irrigation',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const PinLockScreen(), // Start with PIN lock
    );
  }
}

// import 'package:flutter/material.dart';
// import '../screens/home_screen.dart';
// import '../screens/control_screen.dart';
// // import 'settings_screen.dart';
// import '../widgets/custom_navbar.dart';

// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});

//   @override
//   _MainScreenState createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   int _selectedIndex = 0; // Default screen index

//   final List<Widget> _screens = [
//     HomeScreen(),
//     ControlScreen(),
//     // SettingsScreen(),
//   ];

//   void _onItemTapped(int index) {
//     if (index >= 0 && index < _screens.length) {
//       setState(() {
//         _selectedIndex = index;
//       });
//     }
//   }

//   void _lockApp() {
//     // Placeholder for lock app logic
//     print("App Locked");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(  // ✅ TOP NAVIGATION BAR
//         title: Text('Smart Irrigation'),
//         backgroundColor: Colors.green,
//         actions: [
//           // Language Dropdown
//           Padding(
//             padding: const EdgeInsets.only(right: 10),
//             child: _buildLanguageDropdown(),
//           ),
//           // Refresh Button
//           IconButton(
//             icon: Icon(Icons.refresh),
//             onPressed: () {
//               setState(() {}); // Simulate refresh
//             },
//           ),
//           // Lock Button
//           IconButton(
//             icon: Icon(Icons.lock),
//             onPressed: _lockApp,
//           ),
//         ],
//       ),

//       body: _screens[_selectedIndex],

//       bottomNavigationBar: CustomNavBar(onLock: _lockApp), // ✅ USE CUSTOM NAVBAR
//     );
//   }

//   Widget _buildLanguageDropdown() {
//     return DropdownButton<String>(
//       dropdownColor: Colors.white,
//       icon: Icon(Icons.language, color: Colors.white),
//       underline: SizedBox(),
//       items: ['Amharic', 'Afaan Oromo', 'English']
//           .map((lang) => DropdownMenuItem(
//                 value: lang,
//                 child: Text(lang),
//               ))
//           .toList(),
//       onChanged: (value) {
//         // Implement language change logic here
//       },
//     );
//   }
// }

