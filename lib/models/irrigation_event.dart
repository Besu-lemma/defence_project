// lib/models/irrigation_event.dart
import 'package:intl/intl.dart';

class IrrigationEvent {
  final String? id;
  final String eventType; // 'AUTO' or 'MANUAL'
  final DateTime timestamp;
  final int durationInMinutes;
  final double? waterUsed; // in liters
  final double? soilMoisture; // percentage
  final double? temperature; // celsius
  final double? humidity; // percentage
  final String? pumpStatus; // 'ON' or 'OFF'
  final bool isOverride;
  final String? notes;

  IrrigationEvent({
    this.id,
    required this.eventType,
    required this.timestamp,
    required this.durationInMinutes,
    this.waterUsed,
    this.soilMoisture,
    this.temperature,
    this.humidity,
    this.pumpStatus,
    this.isOverride = false,
    this.notes,
  });

  String get formattedDate {
    return DateFormat('MMM dd, yyyy HH:mm').format(timestamp);
  }

  String get durationFormatted {
    if (durationInMinutes < 60) return '$durationInMinutes min';
    final hours = durationInMinutes ~/ 60;
    final minutes = durationInMinutes % 60;
    return '${hours}h ${minutes}min';
  }
}