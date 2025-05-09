// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pump_log.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PumpLogAdapter extends TypeAdapter<PumpLog> {
  @override
  final int typeId = 1;

  @override
  PumpLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PumpLog(
      startedAt: fields[0] as DateTime,
      endedAt: fields[1] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, PumpLog obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.startedAt)
      ..writeByte(1)
      ..write(obj.endedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PumpLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
