// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gasto.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GastoAdapter extends TypeAdapter<Gasto> {
  @override
  final int typeId = 1;

  @override
  Gasto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Gasto(
      id: fields[0] as String,
      descripcion: fields[1] as String,
      monto: fields[2] as double,
      pagadorId: fields[3] as String,
      categoriaEmoji: fields[4] as String,
      fecha: fields[5] as DateTime?,
      participantesIds: (fields[6] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Gasto obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.descripcion)
      ..writeByte(2)
      ..write(obj.monto)
      ..writeByte(3)
      ..write(obj.pagadorId)
      ..writeByte(4)
      ..write(obj.categoriaEmoji)
      ..writeByte(5)
      ..write(obj.fecha)
      ..writeByte(6)
      ..write(obj.participantesIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GastoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
