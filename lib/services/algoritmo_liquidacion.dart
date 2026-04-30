import '../models/participante.dart';
import '../models/liquidacion_resultado.dart';

class AlgoritmoService {
  static List<Transaccion> liquidar(List<Participante> participantes) {
    if (participantes.isEmpty) return [];

    final total = participantes.fold(0.0, (sum, p) => sum + p.montoGasto);
    final cuotaIdeal = total / participantes.length;

    final List<_PersonaBalance> deudores = [];
    final List<_PersonaBalance> listaAcreedores = [];

    for (final p in participantes) {
      final balance = p.montoGasto - cuotaIdeal;
      if (balance < -0.01) {
        deudores.add(_PersonaBalance(p, balance));
      } else if (balance > 0.01) {
        listaAcreedores.add(_PersonaBalance(p, balance));
      }
    }

    deudores.sort((a, b) => a.balance.abs().compareTo(b.balance.abs()));
    listaAcreedores.sort((a, b) => b.balance.compareTo(a.balance));

    final List<Transaccion> transacciones = [];
    int i = 0, j = 0;

    while (i < deudores.length && j < listaAcreedores.length) {
      final deudor = deudores[i];
      final acreedor = listaAcreedores[j];

      final montoDeudor = deudor.balance.abs();
      final montoAcreedor = acreedor.balance;
      final monto = montoDeudor < montoAcreedor ? montoDeudor : montoAcreedor;

      if (monto > 0.01) {
        transacciones.add(Transaccion(
          deudorId: deudor.participante.id,
          deudorNombre: deudor.participante.nombre,
          acreedorId: acreedor.participante.id,
          acreedorNombre: acreedor.participante.nombre,
          monto: monto,
        ));
      }

      deudor.balance += monto;
      acreedor.balance -= monto;

      if (deudor.balance.abs() < 0.01) i++;
      if (acreedor.balance.abs() < 0.01) j++;
    }

    return transacciones;
  }

  static String generarTextoResultados(List<Transaccion> transacciones, double total) {
    if (transacciones.isEmpty) {
      return '¡Todos square! Nadie debe nada.';
    }

    final buffer = StringBuffer();
    buffer.writeln('LIQUIDACIÓN');
    buffer.writeln('Total: \$${total.toStringAsFixed(0)}');
    buffer.writeln('');

    for (final t in transacciones) {
      buffer.writeln('${t.deudorNombre} → ${t.acreedorNombre}: \$${t.monto.toStringAsFixed(0)}');
    }

    return buffer.toString();
  }
}

class _PersonaBalance {
  final Participante participante;
  double balance;
  _PersonaBalance(this.participante, this.balance);
}