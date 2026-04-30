import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../services/app_theme.dart';

class ParticipanteCard extends StatelessWidget {
  final String nombre;
  final double montoGasto;
  final double cuotaIdeal;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ParticipanteCard({
    super.key,
    required this.nombre,
    required this.montoGasto,
    required this.cuotaIdeal,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeProvider>().themeMode;
    final bg = ThemeColors.getCard(themeMode);
    final accent = ThemeColors.getAccent(themeMode);
    final error = ThemeColors.getError(themeMode);
    final success = ThemeColors.getSuccess(themeMode);
    final textPrimary = themeMode == AppThemeMode.old ? const Color(0xFF333333) : Colors.white;
    final textSecondary = themeMode == AppThemeMode.old ? const Color(0xFF666666) : Colors.white70;
    final radius = ThemeColors.getRadius(themeMode);
    final borderColor = themeMode == AppThemeMode.old ? const Color(0xFF333333) : Colors.transparent;
    final borderWidth = themeMode == AppThemeMode.old ? 2.0 : 0.0;

    final balance = montoGasto - cuotaIdeal;
    final isPositive = balance >= 0;
    final progress = cuotaIdeal > 0 ? (montoGasto / cuotaIdeal).clamp(0.0, 1.5) : 0.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: radius,
          border: Border.all(color: borderColor, width: borderWidth),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: themeMode == AppThemeMode.old
                        ? const LinearGradient(colors: [Color(0xFFD35400), Color(0xFFA04000)])
                        : const LinearGradient(colors: [Color(0xFF007bff), Color(0xFF0056b3)]),
                    shape: BoxShape.circle,
                    border: themeMode == AppThemeMode.old ? Border.all(color: const Color(0xFF333333), width: 2) : null,
                  ),
                  child: Center(
                    child: Text(
                      nombre.isNotEmpty ? nombre[0].toUpperCase() : '?',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(nombre, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textPrimary)),
                      const SizedBox(height: 2),
                      Text('Gastó: \$${montoGasto.toStringAsFixed(0)}', style: TextStyle(fontSize: 12, color: textSecondary)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${balance.abs().toStringAsFixed(0)}',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isPositive ? success : error),
                    ),
                    Text(isPositive ? 'a favor' : 'debe', style: TextStyle(fontSize: 12, color: isPositive ? success : error)),
                  ],
                ),
                const SizedBox(width: 8),
                Column(
                  children: [
                    _buildActionButton(Icons.edit, accent, onEdit),
                    const SizedBox(height: 8),
                    _buildActionButton(Icons.delete_outline, error, onDelete),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                backgroundColor: themeMode == AppThemeMode.old ? const Color(0xFFddd) : Colors.white12,
                valueColor: AlwaysStoppedAnimation<Color>(progress > 1.0 ? error : accent),
                minHeight: 6,
              ),
            ),
            if (cuotaIdeal > 0) ...[
              const SizedBox(height: 4),
              Text(
                progress > 1.0
                    ? 'Excedió en \$${((montoGasto - cuotaIdeal)).toStringAsFixed(0)}'
                    : 'Faltan \$${(cuotaIdeal - montoGasto).toStringAsFixed(0)}',
                style: TextStyle(fontSize: 11, color: textSecondary),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, Color color, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}