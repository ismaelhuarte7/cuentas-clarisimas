import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../services/app_theme.dart';
import '../models/participante.dart';
import '../models/liquidacion_resultado.dart';
import '../widgets/primary_button.dart';

class ResultadoModal extends StatefulWidget {
  final List<Transaccion> transacciones;
  final double totalGastado;
  final List<Participante> participantes;

  const ResultadoModal({
    super.key,
    required this.transacciones,
    required this.totalGastado,
    required this.participantes,
  });

  @override
  State<ResultadoModal> createState() => _ResultadoModalState();
}

class _ResultadoModalState extends State<ResultadoModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _slideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _generarTextoPremium() {
    final buffer = StringBuffer();
    final cuota = widget.participantes.isNotEmpty ? widget.totalGastado / widget.participantes.length : 0.0;

    buffer.writeln('--------------------------');
    buffer.writeln('CUENTAS CLARISIMAS');
    buffer.writeln('--------------------------');
    buffer.writeln('Total: \$${widget.totalGastado.toStringAsFixed(0)}');
    buffer.writeln('Por persona: \$${cuota.toStringAsFixed(0)}');
    buffer.writeln('');
    buffer.writeln('PAGOS:');

    if (widget.transacciones.isEmpty) {
      buffer.writeln('¡Todos square!');
    } else {
      for (final t in widget.transacciones) {
        buffer.writeln('${t.deudorNombre} → \$${t.monto.toStringAsFixed(0)} → ${t.acreedorNombre}');
      }
    }

    buffer.writeln('--------------------------');
    return buffer.toString();
  }

  void _copiarResultados() {
    Clipboard.setData(ClipboardData(text: _generarTextoPremium()));
    HapticFeedback.mediumImpact();
    final accent = ThemeColors.getAccent(context.read<ThemeProvider>().themeMode);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('📋 Copiado'),
        backgroundColor: accent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeProvider>().themeMode;
    final bg = ThemeColors.getBackground(themeMode);
    final cardBg = ThemeColors.getCard(themeMode);
    final accent = ThemeColors.getAccent(themeMode);
    final error = ThemeColors.getError(themeMode);
    final success = ThemeColors.getSuccess(themeMode);
    final textPrimary = themeMode == AppThemeMode.old ? Colors.black87 : Colors.white;
    final textSecondary = themeMode == AppThemeMode.old ? Colors.black54 : Colors.white70;
    final border = themeMode == AppThemeMode.promiedos ? const Color(0xFF333333) : Colors.black12;
    final radius = ThemeColors.getRadius(themeMode);
    
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    final cuota = widget.participantes.isNotEmpty ? widget.totalGastado / widget.participantes.length : 0.0;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Transform.translate(offset: Offset(0, _slideAnimation.value), child: child),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: bottomPadding),
        decoration: BoxDecoration(
          gradient: themeMode == AppThemeMode.old
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFF39C12), Color(0xFFD35400)],
                )
              : LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [bg.withOpacity(0.95), bg],
                ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40, height: 4,
                    decoration: BoxDecoration(color: textSecondary, borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 20),
                _buildHeader(cuota, themeMode),
                const SizedBox(height: 24),
                if (widget.transacciones.isEmpty)
                  _buildNoHayDeudas(success, textPrimary, textSecondary, cardBg, radius, border)
                else
                  _buildListaPagos(themeMode, cardBg, radius, border),
                const SizedBox(height: 24),
                SizedBox(
                  height: 60,
                  child: ElevatedButton.icon(
                    onPressed: _copiarResultados,
                    icon: const Icon(Icons.copy, size: 24),
                    label: const Text('COPIAR RESULTADOS', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: radius),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(double cuota, AppThemeMode themeMode) {
    final accent = ThemeColors.getAccent(themeMode);
    final cardBg = ThemeColors.getCard(themeMode);
    final radius = ThemeColors.getRadius(themeMode);
    final textPrimary = themeMode == AppThemeMode.old ? Colors.black87 : Colors.white;
    final textSecondary = themeMode == AppThemeMode.old ? Colors.black54 : Colors.white70;
    final border = themeMode == AppThemeMode.promiedos ? const Color(0xFF333333) : Colors.transparent;
    
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              gradient: themeMode == AppThemeMode.old 
                  ? const LinearGradient(colors: [Color(0xFFD35400), Color(0xFFA04000)])
                  : (themeMode == AppThemeMode.promiedos 
                      ? const LinearGradient(colors: [Color(0xFF007bff), Color(0xFF0056b3)])
                      : null),
              borderRadius: radius,
            ),
            child: Column(
              children: [
                Text('TOTAL', style: TextStyle(fontSize: 12, color: textSecondary)),
                const SizedBox(height: 4),
                Text('\$${widget.totalGastado.toStringAsFixed(0)}', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textPrimary)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: radius,
              border: Border.all(color: border),
            ),
            child: Column(
              children: [
                Text('POR PERSONA', style: TextStyle(fontSize: 12, color: textSecondary)),
                const SizedBox(height: 4),
                Text('\$${cuota.toStringAsFixed(0)}', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: accent)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoHayDeudas(Color success, Color textPrimary, Color textSecondary, Color cardBg, BorderRadius radius, Color border) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: cardBg, borderRadius: radius, border: Border.all(color: border)),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(color: success.withOpacity(0.2), shape: BoxShape.circle),
            child: Icon(Icons.check_circle, color: success, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('¡Todos square!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimary)),
                const SizedBox(height: 4),
                Text('Nadie debe nada', style: TextStyle(color: textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListaPagos(AppThemeMode themeMode, Color cardBg, BorderRadius radius, Color border) {
    final accent = ThemeColors.getAccent(themeMode);
    final textPrimary = themeMode == AppThemeMode.old ? Colors.black87 : Colors.white;
    final textSecondary = themeMode == AppThemeMode.old ? Colors.black54 : Colors.white70;
    final isPromiedos = themeMode == AppThemeMode.promiedos;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('PAGOS A REALIZAR', style: TextStyle(fontSize: 12, letterSpacing: 2, color: textSecondary)),
        const SizedBox(height: 12),
        ...widget.transacciones.asMap().entries.map((entry) {
          final t = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildPagoCard(t, cardBg, radius, border, accent, textPrimary, textSecondary, isPromiedos),
          );
        }),
      ],
    );
  }

  Widget _buildPagoCard(Transaccion t, Color cardBg, BorderRadius radius, Color border, Color accent, Color textPrimary, Color textSecondary, bool isPromiedos) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: cardBg, borderRadius: radius, border: Border.all(color: border)),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: accent.withOpacity(0.15), shape: BoxShape.circle),
            child: Icon(Icons.person, color: accent, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.deudorNombre, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textPrimary)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.arrow_forward, size: 14, color: textSecondary),
                    const SizedBox(width: 4),
                    Text(t.acreedorNombre, style: TextStyle(color: textSecondary)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: isPromiedos 
                  ? const LinearGradient(colors: [Color(0xFF007bff), Color(0xFF0056b3)])
                  : null,
              color: !isPromiedos ? accent : null,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.arrow_forward, size: 16, color: Colors.white),
                const SizedBox(width: 6),
                Text('\$${t.monto.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}