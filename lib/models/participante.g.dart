// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participante.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ParticipanteAdapter extends TypeAdapter<Participante> {
  @override
  final int typeId = 0;

  @override
  Participante read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Participante(
      id: fields[0] as String,
      nombre: fields[1] as String,
      montoGasto: fields[2] as double,
      createdAt: fields[3] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Participante obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nombre)
      ..writeByte(2)
      ..write(obj.montoGasto)
      ..writeByte(3)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParticipanteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
