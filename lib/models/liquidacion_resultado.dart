class LiquidacionResultado {
  final double gastoTotal;
  final double cuotaIdeal;
  final Map<String, double> balances;
  final List<Transferencia> transferencias;

  LiquidacionResultado({
    required this.gastoTotal,
    required this.cuotaIdeal,
    required this.balances,
    required this.transferencias,
  });
}

class Transaccion {
  final String deudorId;
  final String deudorNombre;
  final String acreedorId;
  final String acreedorNombre;
  final double monto;

  Transaccion({
    required this.deudorId,
    required this.deudorNombre,
    required this.acreedorId,
    required this.acreedorNombre,
    required this.monto,
  });
}

class Transferencia {
  final String deudorId;
  final String deudorNombre;
  final String acreedorId;
  final String acreedorNombre;
  final double monto;

  Transferencia({
    required this.deudorId,
    required this.deudorNombre,
    required this.acreedorId,
    required this.acreedorNombre,
    required this.monto,
  });
}