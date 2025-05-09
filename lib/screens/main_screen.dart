// lib/screens/main_screen.dart
import 'package:flutter/material.dart';
import 'package:restart_app/restart_app.dart';
import '../utils/language_strings.dart';
import 'home_screen.dart';
import 'chat_screen.dart';
import 'control_screen.dart';
import 'history_screen.dart';
import 'notification_screen.dart';
import 'change_pin_screen.dart';
import 'pin_lock_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  String _selectedLanguage = 'en';

  final GlobalKey<HomeScreenState> _homeKey = GlobalKey();

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(key: _homeKey),
      ControlScreen(),
      const HistoryScreen(),  // ✅ Replaced Chat with History
    ];
  }

  void _onItemTapped(int i) => setState(() => _selectedIndex = i);
  void _restart() => Restart.restartApp();
  void _lock() => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PinLockScreen()),
      );
  void _changePin() => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ChangePinScreen()),
      );
  void _setLang(String code) {
    setState(() => _selectedLanguage = code);
    setLanguage(code);
  }

  void _refreshHome() {
    if (_selectedIndex == 0) _homeKey.currentState?.fetchAllData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(padding: EdgeInsets.zero, children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.green),
            child: Text(tr('settings'),
                style: const TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: Text(tr('history')),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HistoryScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: Text(tr('notifications')),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotificationScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: Text(tr('Chat')),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ChatScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: Text(tr('change_pin')),
            onTap: _changePin,
          ),
        ]),
      ),
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(tr('title')),
        actions: [
          DropdownButton<String>(
            value: _selectedLanguage,
            dropdownColor: Colors.white,
            icon: const Icon(Icons.language, color: Colors.white),
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(value: 'en', child: Text('English')),
              DropdownMenuItem(value: 'am', child: Text('Amharic')),
              DropdownMenuItem(value: 'om', child: Text('Afaan Oromo')),
            ],
            onChanged: (v) {
              if (v != null) _setLang(v);
            },
          ),
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refreshHome),
          IconButton(icon: const Icon(Icons.lock), onPressed: _lock),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.green,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
              icon: const Icon(Icons.home), label: tr('home')),
          BottomNavigationBarItem(
              icon: const Icon(Icons.power), label: tr('controller')),
          BottomNavigationBarItem(
              icon: const Icon(Icons.history), label: tr('history')),  // ✅ Updated icon/label
        ],
      ),
    );
  }
}
