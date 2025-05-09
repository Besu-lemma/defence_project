// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../utils/language_strings.dart';

// class HistoryScreen extends StatefulWidget {
//   final List<HistoryItem> initialHistoryItems;

//   const HistoryScreen({super.key, this.initialHistoryItems = const []});

//   @override
//   State<HistoryScreen> createState() => _HistoryScreenState();
// }

// class _HistoryScreenState extends State<HistoryScreen> {
//   late List<HistoryItem> historyItems;

//   @override
//   void initState() {
//     super.initState();
//     historyItems = List.from(widget.initialHistoryItems);
//   }

//   void _clearHistory() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(tr('clear_history')),
//         content: Text(tr('confirm_clear_history')),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text(tr('cancel')),
//           ),
//           TextButton(
//             onPressed: () {
//               setState(() {
//                 historyItems.clear();
//               });
//               Navigator.pop(context);
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text(tr('history_cleared'))),
//               );
//             },
//             child: Text(tr('confirm')),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(tr('history')),
//         backgroundColor: Colors.green,
//         actions: [
//           if (historyItems.isNotEmpty)
//             IconButton(
//               icon: const Icon(Icons.delete),
//               tooltip: tr('clear_history'),
//               onPressed: _clearHistory,
//             ),
//         ],
//       ),
//       body: historyItems.isEmpty
//           ? Center(
//               child: Text(
//                 tr('no_history'),
//                 style: const TextStyle(fontSize: 16.0, color: Colors.grey),
//               ),
//             )
//           : ListView.builder(
//               padding: const EdgeInsets.all(16.0),
//               itemCount: historyItems.length,
//               itemBuilder: (context, idx) {
//                 final item = historyItems[idx];
//                 return Card(
//                   margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(item.description, style: const TextStyle(fontWeight: FontWeight.bold)),
//                         const SizedBox(height: 8.0),
//                         Text(
//                           DateFormat('yyyy-MM-dd HH:mm:ss').format(item.timestamp),
//                           style: const TextStyle(color: Colors.grey),
//                         ),
//                         if (item.details != null && item.details!.isNotEmpty) ...[
//                           const SizedBox(height: 8.0),
//                           Text('${tr('details')} ${item.details}'),
//                         ],
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }

// class HistoryItem {
//   final String description;
//   final DateTime timestamp;
//   final String? details;

//   HistoryItem({required this.description, required this.timestamp, this.details});
// }
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../models/pump_log.dart';
import '../utils/language_strings.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Box<PumpLog> pumpLogBox;

  @override
  void initState() {
    super.initState();
    pumpLogBox = Hive.box<PumpLog>('pumpLogBox');
  }

  void _clearHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tr('clear_history')),
        content: Text(tr('confirm_clear_history')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(tr('cancel')),
          ),
          TextButton(
            onPressed: () async {
              await pumpLogBox.clear();
              if (mounted) {
                setState(() {});
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(tr('history_cleared'))),
                );
              }
            },
            child: Text(tr('confirm')),
          ),
        ],
      ),
    );
  }

  String formatDate(DateTime dt) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final logs = pumpLogBox.values.toList().reversed.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(tr('history')),
        backgroundColor: Colors.green,
        actions: [
          if (logs.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: tr('clear_history'),
              onPressed: _clearHistory,
            ),
        ],
      ),
      body: logs.isEmpty
          ? Center(
              child: Text(
                tr('no_history'),
                style: const TextStyle(fontSize: 16.0, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: logs.length,
              itemBuilder: (context, idx) {
                final log = logs[idx];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tr('pump_activated'),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6.0),
                        Text('${tr('started_at')}: ${formatDate(log.startedAt)}'),
                        if (log.endedAt != null)
                          Text('${tr('ended_at')}: ${formatDate(log.endedAt!)}'),
                        if (log.endedAt == null)
                          Text(tr('still_running'), style: const TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
