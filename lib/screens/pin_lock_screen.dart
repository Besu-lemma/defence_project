import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/language_strings.dart';
import 'main_screen.dart';
import 'notification_screen.dart';

class PinLockScreen extends StatefulWidget {
  const PinLockScreen({super.key});
  @override
  _PinLockScreenState createState() => _PinLockScreenState();
}

class _PinLockScreenState extends State<PinLockScreen> {
  final TextEditingController _pinCtrl = TextEditingController();
  String? _err;
  String _lang = 'en';

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final p = await SharedPreferences.getInstance();
    p.getString('user_pin') ?? await p.setString('user_pin', "1234");
    _lang = p.getString('app_language') ?? 'en';
    setLanguage(_lang);
    setState(() {});
  }

  Future<void> _check() async {
    final p = await SharedPreferences.getInstance();
    if (_pinCtrl.text == (p.getString('user_pin') ?? "1234")) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainScreen()));
    } else {
      setState(() => _err = tr('cancel')); // reuse a generic key or define `incorrect_pin`
    }
  }

  Future<void> _reset() async {
    final p = await SharedPreferences.getInstance();
    await p.setString('user_pin', "1234");
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(tr('ok'))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              TextButton(onPressed: _reset, child: Text(tr('ok'))),
              DropdownButton<String>(
                value: _lang,
                items: const [
                  DropdownMenuItem(value: 'en', child: Text('English')),
                  DropdownMenuItem(value: 'am', child: Text('Amharic')),
                  DropdownMenuItem(value: 'om', child: Text('Afaan Oromo')),
                ],
                onChanged: (v) {
                  if (v != null) {
                    setLanguage(v);
                    setState(() => _lang = v);
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () => Navigator.push(
                    context, MaterialPageRoute(builder: (_) =>NotificationScreen())),
              ),
            ]),
          ),
          Expanded(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(tr('title'),
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green)),
              const SizedBox(height: 8),
              Text(tr('to'), style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
              Text(tr('title'),
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green.shade700)),
              const SizedBox(height: 30),
              Container(
                width: 200,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.green, width: 1.5),
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: _pinCtrl,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: tr('enter_pin'), border: InputBorder.none),
                  textAlign: TextAlign.center,
                ),
              ),
              if (_err != null) ...[
                const SizedBox(height: 5),
                Text(_err!, style: const TextStyle(color: Colors.red, fontSize: 14)),
              ],
              const SizedBox(height: 30),
              GestureDetector(
                onTap: _check,
                child: CircleAvatar(radius: 30, backgroundColor: Colors.green, child: const Icon(Icons.arrow_forward, color: Colors.white, size: 30)),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}
