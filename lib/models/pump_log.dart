import 'package:hive/hive.dart';

part 'pump_log.g.dart';

@HiveType(typeId: 1)
class PumpLog extends HiveObject {
  @HiveField(0)
  final DateTime startedAt;

  @HiveField(1)
  final DateTime? endedAt;

  PumpLog({
    required this.startedAt,
    this.endedAt,
  });
}
