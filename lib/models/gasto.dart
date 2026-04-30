import 'package:hive/hive.dart';

part 'gasto.g.dart';

@HiveType(typeId: 1)
class Gasto extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String descripcion;

  @HiveField(2)
  double monto;

  @HiveField(3)
  String pagadorId;

  @HiveField(4)
  String categoriaEmoji;

  @HiveField(5)
  DateTime fecha;

  @HiveField(6)
  List<String> participantesIds; // Quiénes comparten este gasto

  Gasto({
    required this.id,
    required this.descripcion,
    required this.monto,
    required this.pagadorId,
    this.categoriaEmoji = '🍽️',
    DateTime? fecha,
    required this.participantesIds,
  }) : fecha = fecha ?? DateTime.now();

  Gasto copyWith({
    String? id,
    String? descripcion,
    double? monto,
    String? pagadorId,
    String? categoriaEmoji,
    DateTime? fecha,
    List<String>? participantesIds,
  }) {
    return Gasto(
      id: id ?? this.id,
      descripcion: descripcion ?? this.descripcion,
      monto: monto ?? this.monto,
      pagadorId: pagadorId ?? this.pagadorId,
      categoriaEmoji: categoriaEmoji ?? this.categoriaEmoji,
      fecha: fecha ?? this.fecha,
      participantesIds: participantesIds ?? this.participantesIds,
    );
  }
}