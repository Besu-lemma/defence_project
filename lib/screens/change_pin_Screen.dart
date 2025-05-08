import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/language_strings.dart';

class ChangePinScreen extends StatefulWidget {
  const ChangePinScreen({super.key});
  @override
  _ChangePinScreenState createState() => _ChangePinScreenState();
}

class _ChangePinScreenState extends State<ChangePinScreen> {
  final _c = TextEditingController(), _n = TextEditingController(), _c2 = TextEditingController();
  String? _err;

  Future<void> _save() async {
    final p = await SharedPreferences.getInstance();
    if (_c.text != (p.getString('user_pin') ?? '1234')) return setState(() => _err = tr('incorrect_pin'));
    if (_n.text.length != 4) return setState(() => _err = tr('pin_4_digits'));
    if (_n.text != _c2.text) return setState(() => _err = tr('pins_no_match'));
    await p.setString('user_pin', _n.text);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(tr('pin_changed'))));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext c) {
    return Scaffold(
      appBar: AppBar(title: Text(tr('change_pin')), backgroundColor: Colors.green),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          TextField(controller: _c, obscureText: true, decoration: InputDecoration(labelText: tr('current_pin'))),
          TextField(controller: _n, obscureText: true, decoration: InputDecoration(labelText: tr('new_pin'))),
          TextField(controller: _c2, obscureText: true, decoration: InputDecoration(labelText: tr('confirm_pin'))),
          if (_err != null) Text(_err!, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: _save, child: Text(tr('change_pin'))),
        ]),
      ),
    );
  }
}
