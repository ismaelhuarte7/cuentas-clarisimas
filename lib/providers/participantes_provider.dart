import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/participante.dart';

class ParticipantesProvider extends ChangeNotifier {
  List<Participante> _participantes = [];
  bool _isLoading = false;

  List<Participante> get participantes => _participantes;
  bool get isLoading => _isLoading;
  bool get tieneParticipantes => _participantes.isNotEmpty;

  double get totalGastado => _participantes.fold(0, (sum, p) => sum + p.montoGasto);
  double get cuotaIdeal => tieneParticipantes ? totalGastado / _participantes.length : 0;

  static Box<Participante>? _box;

  Future<void> _getBox() async {
    if (_box == null || !_box!.isOpen) {
      _box = Hive.box<Participante>('participantes');
    }
  }

  Future<void> cargarParticipantes() async {
    _isLoading = true;
    notifyListeners();

    await _getBox();
    _participantes = _box!.values.toList();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> agregarParticipante(String nombre, double monto) async {
    await _getBox();

    final participante = Participante(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nombre: nombre.trim(),
      montoGasto: monto,
      createdAt: DateTime.now(),
    );

    await _box!.put(participante.id, participante);
    _participantes.add(participante);
    notifyListeners();
  }

  Future<void> actualizarParticipante(String id, String nombre, double monto) async {
    await _getBox();
    final index = _participantes.indexWhere((p) => p.id == id);
    if (index != -1) {
      _participantes[index].nombre = nombre;
      _participantes[index].montoGasto = monto;
      await _box!.put(id, _participantes[index]);
      notifyListeners();
    }
  }

  Future<void> eliminarParticipante(String id) async {
    await _getBox();
    await _box!.delete(id);
    _participantes.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  Future<void> limpiarTodos() async {
    await _getBox();
    await _box!.clear();
    _participantes.clear();
    notifyListeners();
  }

  Map<String, double> getBalances() {
    final Map<String, double> balances = {};
    for (final p in _participantes) {
      balances[p.id] = p.montoGasto - cuotaIdeal;
    }
    return balances;
  }
}