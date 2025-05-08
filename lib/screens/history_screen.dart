import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/language_strings.dart';

class HistoryScreen extends StatelessWidget {
  final List<HistoryItem> historyItems;

  const HistoryScreen({super.key, this.historyItems = const []});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('history')), // translated
        backgroundColor: Colors.green,
      ),
      body: historyItems.isEmpty
          ? Center(
              child: Text(
                tr('no_history'), // translated
                style: const TextStyle(fontSize: 16.0, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: historyItems.length,
              itemBuilder: (context, idx) {
                final item = historyItems[idx];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.description, style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8.0),
                        Text(
                          DateFormat('yyyy-MM-dd HH:mm:ss').format(item.timestamp),
                          style: const TextStyle(color: Colors.grey),
                        ),
                        if (item.details != null && item.details!.isNotEmpty) ...[
                          const SizedBox(height: 8.0),
                          Text('${tr('details')} ${item.details}'), // translated label
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class HistoryItem {
  final String description;
  final DateTime timestamp;
  final String? details;

  HistoryItem({required this.description, required this.timestamp, this.details});
}
