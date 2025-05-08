/// lib/services/local_storage.dart
library;

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/message.dart';

class LocalStorage {
  /// Must be called once at app startup
  static Future<void> init() async {
    // no-op here, but could preload prefs if you like
    await SharedPreferences.getInstance();
  }

  /// Save the entire chat-history (many conversations)
  static Future<void> saveConversationHistory(
      List<List<Message>> history) async {
    final prefs = await SharedPreferences.getInstance();
    final payload = {
      'titles': history
          .map((conv) => conv.isNotEmpty ? conv.first.text : '')
          .toList(),
      'conversations': history
          .map((conv) => conv.map((m) => m.toJson()).toList())
          .toList(),
    };
    await prefs.setString('chat_history_v2', jsonEncode(payload));
  }

  /// Load all past conversations as a map: { 'titles': [...], 'conversations': [[{...}, …], …] }
  static Future<Map<String, dynamic>> getFullHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('chat_history_v2');
    if (raw == null) return {'titles': <String>[], 'conversations': <List>[]};

    final Map<String, dynamic> data = jsonDecode(raw);
    return data;
  }

  /// Clear everything
  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('chat_history_v2');
  }
}
