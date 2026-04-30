import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../services/app_theme.dart';
import '../widgets/custom_input.dart';

class ParticipanteSheet extends StatefulWidget {
  final dynamic participante;
  final Function(String nombre, double monto) onSave;

  const ParticipanteSheet({
    super.key,
    this.participante,
    required this.onSave,
  });

  @override
  State<ParticipanteSheet> createState() => _ParticipanteSheetState();
}

class _ParticipanteSheetState extends State<ParticipanteSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  late TextEditingController _nombreController;
  late TextEditingController _montoController;
  final _nombreFocus = FocusNode();
  String? _errorNombre;
  String? _errorMonto;

  bool get isEditing => widget.participante != null;

  static const List<double> _quickAmounts = [0, 5000, 10000, 15000, 20000, 50000];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();

    _nombreController = TextEditingController(text: widget.participante?.nombre ?? '');
    _montoController = TextEditingController(
      text: widget.participante != null && widget.participante.montoGasto > 0 
          ? widget.participante.montoGasto.toStringAsFixed(0) 
          : '',
    );

    Future.delayed(const Duration(milliseconds: 100), () => _nombreFocus.requestFocus());
  }

  @override
  void dispose() {
    _controller.dispose();
    _nombreController.dispose();
    _montoController.dispose();
    _nombreFocus.dispose();
    super.dispose();
  }

  void _setQuickAmount(double amount) {
    _montoController.text = amount > 0 ? amount.toStringAsFixed(0) : '';
    setState(() => _errorMonto = null);
    HapticFeedback.selectionClick();
  }

  void _guardar() {
    final nombre = _nombreController.text.trim();
    final monto = double.tryParse(_montoController.text.replaceAll(',', '.')) ?? 0;
    bool hasError = false;

    if (nombre.isEmpty) {
      setState(() => _errorNombre = 'Ingresá un nombre');
      hasError = true;
    } else if (nombre.length < 2) {
      setState(() => _errorNombre = 'Mínimo 2 caracteres');
      hasError = true;
    }

    if (monto < 0) {
      setState(() => _errorMonto = 'El monto no puede ser negativo');
      hasError = true;
    }

    if (hasError) {
      HapticFeedback.heavyImpact();
      return;
    }

    widget.onSave(nombre, monto);
    Navigator.of(context).pop();
    HapticFeedback.mediumImpact();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeProvider>().themeMode;
    final bg = ThemeColors.getBackground(themeMode);
    final cardBg = ThemeColors.getCard(themeMode);
    final accent = ThemeColors.getAccent(themeMode);
    final textPrimary = themeMode == AppThemeMode.old ? const Color(0xFF333333) : Colors.white;
    final textSecondary = themeMode == AppThemeMode.old ? const Color(0xFF666666) : Colors.white70;
    final radius = ThemeColors.getRadius(themeMode);
    final borderColor = themeMode == AppThemeMode.old ? const Color(0xFF333333) : Colors.transparent;
    
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Transform.scale(scale: _scaleAnimation.value, child: child),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: bottomPadding),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: themeMode == AppThemeMode.old ? Border.all(color: const Color(0xFF333333), width: 2) : Border.all(color: Colors.white24),
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
                const SizedBox(height: 24),
                Text(
                  isEditing ? 'EDITAR PERSONA' : 'AGREGAR PERSONA',
                  style: TextStyle(
                    fontSize: 20, 
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isEditing ? 'Actualizá el nombre y/o monto' : 'Ingresá el nombre y cuánto gastó',
                  style: TextStyle(color: textSecondary),
                ),
                const SizedBox(height: 24),
                CustomInput(
                  controller: _nombreController,
                  focusNode: _nombreFocus,
                  hintText: 'Ej: Juan Pérez',
                  labelText: 'Nombre',
                  errorText: _errorNombre,
                  autofocus: true,
                  onChanged: (_) => setState(() => _errorNombre = null),
                  prefix: Icon(Icons.person_outline, color: textSecondary),
                ),
                const SizedBox(height: 16),
                CustomInput(
                  controller: _montoController,
                  hintText: '0',
                  labelText: 'Monto que gastó',
                  keyboardType: TextInputType.number,
                  errorText: _errorMonto,
                  onChanged: (_) => setState(() => _errorMonto = null),
                  prefix: Icon(Icons.attach_money, color: textSecondary),
                ),
                const SizedBox(height: 12),
                Text('Quick Amounts', style: TextStyle(fontSize: 12, color: textSecondary)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8, runSpacing: 8,
                  children: _quickAmounts.map((amount) {
                    final isSelected = _montoController.text == (amount > 0 ? amount.toStringAsFixed(0) : '');
                    return GestureDetector(
                      onTap: () => _setQuickAmount(amount),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? accent.withOpacity(0.2) : (themeMode == AppThemeMode.old ? Colors.white : Colors.white12),
                          borderRadius: radius,
                          border: Border.all(color: isSelected ? accent : borderColor),
                        ),
                        child: Text(
                          amount == 0 ? '0' : '\$${amount.toStringAsFixed(0)}',
                          style: TextStyle(color: isSelected ? accent : textPrimary),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _guardar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: radius, side: themeMode == AppThemeMode.old ? BorderSide(color: borderColor) : BorderSide.none),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(isEditing ? Icons.check : Icons.person_add, size: 20),
                        const SizedBox(width: 8),
                        Text(isEditing ? 'GUARDAR' : 'AGREGAR', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
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
}