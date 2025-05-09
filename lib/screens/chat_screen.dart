// lib/screens/chat_screen.dart

import 'package:final_project/services/gemini_Service.dart';
import 'package:flutter/material.dart';
import '../models/message.dart';
// import '../services/gemini_service.dart';
import '../services/local_storage.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _ctrl = TextEditingController();
  final GeminiService _gemini = GeminiService();

  List<List<Message>> _history = [];
  int _currentIdx = -1;
  List<Message> _msgs = [];

  @override
  void initState() {
    super.initState();
    LocalStorage.init().then((_) => _loadHistory());
  }

  Future<void> _loadHistory() async {
    final data = await LocalStorage.getFullHistory();
    final raw = data['conversations'] as List;
    setState(() {
      _history = raw.map((conv) {
        return (conv as List)
            .map((m) => Message.fromJson(m as Map<String, dynamic>))
            .toList();
      }).toList();
      if (_history.isNotEmpty) {
        _currentIdx = _history.length - 1;
        _msgs = List.from(_history[_currentIdx]);
      }
    });
  }

  Future<void> _saveHistory() async {
    if (_currentIdx >= 0 && _currentIdx < _history.length) {
      _history[_currentIdx] = _msgs;
    } else {
      _history.add(_msgs);
      _currentIdx = _history.length - 1;
    }
    await LocalStorage.saveConversationHistory(_history);
  }

  void _newChat() {
    setState(() {
      _msgs = [];
      _history.add(_msgs);
      _currentIdx = _history.length - 1;
    });
    _saveHistory();
  }

  void _selectChat(int i) {
    Navigator.pop(context);
    setState(() {
      _currentIdx = i;
      _msgs = List.from(_history[i]);
    });
  }

  Future<void> _deleteChat(int i) async {
    setState(() {
      _history.removeAt(i);
      if (_history.isEmpty) {
        _currentIdx = -1;
        _msgs = [];
      } else if (_currentIdx >= i) {
        _currentIdx = _history.length - 1;
        _msgs = List.from(_history[_currentIdx]);
      }
    });
    await LocalStorage.saveConversationHistory(_history);
  }

  Future<void> _clearAll() async {
    Navigator.pop(context);
    setState(() {
      _history.clear();
      _currentIdx = -1;
      _msgs = [];
    });
    await LocalStorage.clearHistory();
  }

  Future<void> _send(String text) async {
    if (text.trim().isEmpty) return;
    setState(() {
      _msgs.add(Message(text: text, isUser: true));
      _ctrl.clear();
    });
    final ai = await _gemini.sendMessage(text);
    setState(() => _msgs.add(Message(text: ai, isUser: false)));
    await _saveHistory();
  }

  Widget _drawer() {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.green),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text('Chat History',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _history.length,
              itemBuilder: (_, i) {
                final title = _history[i].isNotEmpty
                    ? _history[i].first.text
                    : 'Untitled';
                return ListTile(
                  title: Text(title, overflow: TextOverflow.ellipsis),
                  selected: i == _currentIdx,
                  onTap: () => _selectChat(i),
                  trailing: PopupMenuButton(
                    icon: const Icon(Icons.more_vert),
                    itemBuilder: (_) => [
                      const PopupMenuItem(
                          value: 'delete', child: Text('Delete'))
                    ],
                    onSelected: (v) {
                      if (v == 'delete') _deleteChat(i);
                    },
                  ),
                );
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.clear_all, color: Colors.red),
            title:
                const Text('Clear All', style: TextStyle(color: Colors.red)),
            onTap: _clearAll,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: _newChat),
        ],
      ),
      drawer: _drawer(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(8),
              itemCount: _msgs.length,
              itemBuilder: (_, i) {
                final m = _msgs[_msgs.length - 1 - i];
                return Align(
                  alignment:
                      m.isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: m.isUser ? Colors.green[100] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(m.text),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ctrl,
                    onSubmitted: _send,
                    decoration: const InputDecoration(
                      hintText: 'Enter message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.green),
                  onPressed: () => _send(_ctrl.text),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
