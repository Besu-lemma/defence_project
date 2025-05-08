import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/message.dart';

class LocalStorage {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Save chat messages
  static Future<void> saveMessages(List<Message> messages) async {
    List<String> messagesJson =
        messages.map((message) => jsonEncode(message.toJson())).toList();
    await _prefs.setStringList('chat_history', messagesJson);
  }

  // Load chat messages
  static Future<List<Message>> getMessages() async {
    List<String>? messagesJson = _prefs.getStringList('chat_history');
    if (messagesJson == null) return [];
    return messagesJson
        .map((msg) => Message.fromJson(jsonDecode(msg)))
        .toList();
  }

  // Clear chat history
  static Future<void> clearMessages() async {
    await _prefs.remove('chat_history');
  }
}