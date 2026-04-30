import 'package:hive/hive.dart';

part 'participante.g.dart';

@HiveType(typeId: 0)
class Participante extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String nombre;

  @HiveField(2)
  double montoGasto;

  @HiveField(3)
  DateTime createdAt;

  Participante({
    required this.id,
    required this.nombre,
    this.montoGasto = 0.0,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Participante copyWith({
    String? id,
    String? nombre,
    double? montoGasto,
  }) {
    return Participante(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      montoGasto: montoGasto ?? this.montoGasto,
    );
  }
}