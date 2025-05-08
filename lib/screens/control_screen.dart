import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/language_strings.dart';

class ControlScreen extends StatefulWidget {
  const ControlScreen({super.key});
  @override
  _ControlScreenState createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  bool _pumpOn = false;
  double _waterLevel = 0.0;
  String _error = '';
  late Timer _timer;
  final String _ip = '192.168.0.12';

  @override
  void initState() {
    super.initState();
    _fetch();
    _timer = Timer.periodic(const Duration(seconds: 2), (_) => _fetch());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _fetch() async {
    try {
      final r = await http.get(Uri.parse('http://$_ip/data')).timeout(const Duration(seconds: 2));
      if (r.statusCode == 200) {
        final d = json.decode(r.body);
        setState(() {
          _waterLevel = (d['waterLevel'] ?? 0) / 100.0;
          _pumpOn = d['pumpStatus'] == 'ON';
          _error = '';
        });
      }
    } catch (e) {
      setState(() => _error = e is TimeoutException ? 'Connection timeout' : 'Error: $e');
    }
  }

  Future<void> _toggle() async {
    if (_waterLevel < 0.2) {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(tr('tank_empty_title')),
          content: Text(tr('tank_empty_msg')),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text(tr('ok'))),
          ],
        ),
      );
      return;
    }
    if (!_pumpOn) {
      final confirm = await showDialog<bool>(
            context: context,
            builder: (_) => AlertDialog(
              title: Text(tr('confirm_pump_title')),
              content: Text(tr('confirm_pump_msg')),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context, false), child: Text(tr('cancel'))),
                TextButton(onPressed: () => Navigator.pop(context, true), child: Text(tr('turn_on'))),
              ],
            ),
          ) ??
          false;
      if (!confirm) return;
    }
    final cmd = _pumpOn ? 'off' : 'on';
    final r = await http.get(Uri.parse('http://$_ip/control?pump=$cmd'));
    if (r.statusCode == 200) {
      setState(() => _pumpOn = !_pumpOn);
    } else {
      setState(() => _error = 'Control failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr('pump_control')), backgroundColor: Colors.green),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                Text(tr('water_tank_status'),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal)),
                const SizedBox(height: 12),
                CircularProgressIndicator(
                  value: _waterLevel,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(_waterLevel < 0.2 ? Colors.red : Colors.blue),
                  strokeWidth: 12,
                ),
                const SizedBox(height: 12),
                Text('${(_waterLevel * 100).toStringAsFixed(1)}% full', style: const TextStyle(fontSize: 18)),
              ]),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                SwitchListTile(
                  title: Text(
                    _pumpOn ? tr('confirm_pump_title') : tr('pump_control'),
                    style: TextStyle(fontWeight: FontWeight.bold, color: _pumpOn ? Colors.green : Colors.red),
                  ),
                  value: _pumpOn,
                  secondary: Icon(Icons.power, color: _pumpOn ? Colors.green : Colors.red),
                  onChanged: (_) => _toggle(),
                ),
                if (_pumpOn)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(tr('confirm_pump_msg'), style: const TextStyle(color: Colors.orange)),
                  ),
              ]),
            ),
          ),
          if (_error.isNotEmpty)
            Padding(padding: const EdgeInsets.only(top: 16), child: Text(_error, style: const TextStyle(color: Colors.red))),
        ]),
      ),
    );
  }
}
