import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'design_system/colors.dart';
import 'design_system/typography.dart';
import 'models/participante.dart';
import 'providers/participantes_provider.dart';
import 'providers/theme_provider.dart';
import 'services/algoritmo_liquidacion.dart';
import 'services/app_theme.dart';
import 'widgets/participante_card.dart';
import 'widgets/participante_sheet.dart';
import 'widgets/resultado_modal.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ParticipanteAdapter());
  await Hive.openBox<Participante>('participantes');

  final themeProvider = ThemeProvider();
  await themeProvider.loadTheme();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: themeProvider),
      ChangeNotifierProvider(
          create: (_) => ParticipantesProvider()..cargarParticipantes()),
    ],
    child: const CuentasClarisimasApp(),
  ));
}

class CuentasClarisimasApp extends StatelessWidget {
  const CuentasClarisimasApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeProvider>().themeMode;

    return MaterialApp(
      title: 'Cuentas Clarisimas',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(themeMode),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _mostrarSheet({BuildContext? context, Participante? participante}) {
    final provider = context!.read<ParticipantesProvider>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ParticipanteSheet(
        participante: participante,
        onSave: (nombre, monto) {
          if (participante == null) {
            provider.agregarParticipante(nombre, monto);
          } else {
            provider.actualizarParticipante(participante.id, nombre, monto);
          }
        },
      ),
    );
  }

  void _mostrarResultados(BuildContext context) {
    final provider = context.read<ParticipantesProvider>();
    final themeMode = context.read<ThemeProvider>().themeMode;
    final transacciones = AlgoritmoService.liquidar(provider.participantes);
    final total = provider.totalGastado;

    if (themeMode == AppThemeMode.old) {
      _mostrarResultadosOld(
          context, transacciones, total, provider.participantes);
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => ResultadoModal(
          transacciones: transacciones,
          totalGastado: total,
          participantes: provider.participantes,
        ),
      );
    }
  }

  void _mostrarResultadosOld(BuildContext context, List transacciones,
      double total, List participantes) {
    final cuota = participantes.isNotEmpty ? total / participantes.length : 0.0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.monetization_on, color: Color(0xFFD35400)),
            SizedBox(width: 8),
            Text('LIQUIDACIÓN'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF39C12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text('TOTAL', style: TextStyle(fontSize: 10)),
                        Text('\$${total.toStringAsFixed(0)}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Container(width: 1, height: 30, color: Colors.black26),
                    Column(
                      children: [
                        const Text('POR PERSONA',
                            style: TextStyle(fontSize: 10)),
                        Text('\$${cuota.toStringAsFixed(0)}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (transacciones.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                      child: Text('¡Todos square!',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16))),
                )
              else
                ...transacciones.map((t) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.arrow_right,
                              color: Color(0xFFD35400)),
                          Expanded(
                            child: Text(
                                '${t.deudorNombre} debe \$${t.monto.toStringAsFixed(0)} a ${t.acreedorNombre}'),
                          ),
                        ],
                      ),
                    )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final buffer = StringBuffer();
              buffer.writeln('LIQUIDACIÓN');
              buffer.writeln('Total: \$${total.toStringAsFixed(0)}');
              buffer.writeln('Por persona: \$${cuota.toStringAsFixed(0)}');
              buffer.writeln('');
              if (transacciones.isEmpty) {
                buffer.writeln('¡Hay uno solo! ¿Qué querés dividir?');
              } else {
                for (final t in transacciones) {
                  buffer.writeln(
                      '${t.deudorNombre} -> \$${t.monto.toStringAsFixed(0)} -> ${t.acreedorNombre}');
                }
              }
              Clipboard.setData(ClipboardData(text: buffer.toString()));
              HapticFeedback.mediumImpact();
              Navigator.pop(context);
            },
            child: const Text('COPIAR'),
          ),
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CERRAR')),
        ],
      ),
    );
  }

  void _confirmarEliminar(BuildContext context, Participante participante) {
    final themeMode = context.read<ThemeProvider>().themeMode;
    final cardBg = ThemeColors.getCard(themeMode);
    final error = ThemeColors.getError(themeMode);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardBg,
        title: const Text('Eliminar'),
        content: Text('¿Eliminar a ${participante.nombre}?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCELAR')),
          TextButton(
            onPressed: () {
              context
                  .read<ParticipantesProvider>()
                  .eliminarParticipante(participante.id);
              Navigator.pop(context);
              HapticFeedback.mediumImpact();
            },
            child: Text('ELIMINAR', style: TextStyle(color: error)),
          ),
        ],
      ),
    );
  }

  void _confirmarLimpiarTodo(BuildContext context) {
    final themeMode = context.read<ThemeProvider>().themeMode;
    final cardBg = ThemeColors.getCard(themeMode);
    final error = ThemeColors.getError(themeMode);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardBg,
        title: const Text('Limpiar Todo'),
        content: const Text('¿Eliminar todos los participantes?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCELAR')),
          TextButton(
            onPressed: () {
              context.read<ParticipantesProvider>().limpiarTodos();
              Navigator.pop(context);
              HapticFeedback.mediumImpact();
            },
            child: Text('LIMPIAR', style: TextStyle(color: error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeProvider>().themeMode;
    final themeLabel = context.watch<ThemeProvider>().themeLabel;
    final bg = ThemeColors.getBackground(themeMode);
    final gradient = ThemeColors.getBackgroundGradient(themeMode);
    final appBarBg = ThemeColors.getAppBarBg(themeMode);
    final accent = ThemeColors.getAccent(themeMode);
    final textColor =
        themeMode == AppThemeMode.old ? Colors.white : Colors.white70;

    return Scaffold(
      body: Container(
        decoration: themeMode == AppThemeMode.old
            ? BoxDecoration(gradient: gradient)
            : BoxDecoration(color: bg),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                color: appBarBg,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Cuentas Clarisimas',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            themeLabel,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 10,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Consumer<ParticipantesProvider>(
                      builder: (context, provider, _) {
                        if (!provider.tieneParticipantes)
                          return const SizedBox.shrink();
                        return IconButton(
                          icon: Icon(Icons.delete_sweep, color: textColor),
                          onPressed: () => _confirmarLimpiarTodo(context),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.palette, color: textColor),
                      onPressed: () =>
                          context.read<ThemeProvider>().cycleTheme(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Consumer<ParticipantesProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading)
                      return Center(
                          child: CircularProgressIndicator(color: accent));
                    if (!provider.tieneParticipantes)
                      return _buildEmptyState(context);
                    return _buildContent(context, provider);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: themeMode == AppThemeMode.old
              ? const LinearGradient(
                  colors: [Color(0xFFD35400), Color(0xFFA04000)])
              : const LinearGradient(
                  colors: [Color(0xFF007bff), Color(0xFF0056b3)]),
          shape: BoxShape.circle,
          border: themeMode == AppThemeMode.old
              ? Border.all(color: const Color(0xFF333333), width: 2)
              : null,
        ),
        child: FloatingActionButton(
          onPressed: () => _mostrarSheet(context: context),
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final themeMode = context.read<ThemeProvider>().themeMode;
    final cardBg = ThemeColors.getCard(themeMode);
    final accent = ThemeColors.getAccent(themeMode);
    final textPrimary = themeMode == AppThemeMode.old
        ? const Color(0xFF333333)
        : Colors.white70;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                  color: cardBg,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: themeMode == AppThemeMode.old
                          ? const Color(0xFF333333)
                          : Colors.transparent)),
              child: Icon(Icons.people_outline, size: 48, color: textPrimary),
            ),
            const SizedBox(height: 24),
            Text('Sin participantes',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textPrimary)),
            const SizedBox(height: 8),
            Text('Agregá personas y cuánto gastaron',
                style: TextStyle(color: textPrimary.withOpacity(0.7)),
                textAlign: TextAlign.center),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _mostrarSheet(context: context),
              icon: const Icon(Icons.person_add),
              label: const Text('AGREGAR'),
              style: ElevatedButton.styleFrom(backgroundColor: accent),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ParticipantesProvider provider) {
    final themeMode = context.read<ThemeProvider>().themeMode;
    final cardBg = ThemeColors.getCard(themeMode);
    final accent = ThemeColors.getAccent(themeMode);
    final border = themeMode == AppThemeMode.promiedos
        ? const Color(0xFF333333)
        : const Color(0xFF333333);
    final radius = ThemeColors.getRadius(themeMode);
    final textPrimary =
        themeMode == AppThemeMode.old ? const Color(0xFF333333) : Colors.white;
    final textSecondary = themeMode == AppThemeMode.old
        ? const Color(0xFF666666)
        : Colors.white70;
    final cuotaIdeal = provider.cuotaIdeal;

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: cardBg,
              borderRadius: radius,
              border: Border.all(
                  color: border, width: themeMode == AppThemeMode.old ? 2 : 1)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Personas', '${provider.participantes.length}',
                  Icons.people, accent, textSecondary),
              Container(width: 1, height: 40, color: border),
              _buildStatItem(
                  'Total',
                  '\$${provider.totalGastado.toStringAsFixed(0)}',
                  Icons.attach_money,
                  accent,
                  textSecondary),
              Container(width: 1, height: 40, color: border),
              _buildStatItem('Cuota', '\$${cuotaIdeal.toStringAsFixed(0)}',
                  Icons.trending_up, accent, textSecondary),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _mostrarResultados(context),
              icon: const Icon(Icons.calculate),
              label: const Text('CALCULAR'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: accent, foregroundColor: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.participantes.length,
            itemBuilder: (context, index) {
              final p = provider.participantes[index];
              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 300 + (index * 100)),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) => Opacity(
                  opacity: value,
                  child: Transform.translate(
                      offset: Offset(0, 20 * (1 - value)), child: child),
                ),
                child: ParticipanteCard(
                  nombre: p.nombre,
                  montoGasto: p.montoGasto,
                  cuotaIdeal: cuotaIdeal,
                  onEdit: () =>
                      _mostrarSheet(context: context, participante: p),
                  onDelete: () => _confirmarEliminar(context, p),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color accent,
      Color textSecondary) {
    return Column(
      children: [
        Icon(icon, color: accent, size: 20),
        const SizedBox(height: 4),
        Text(value,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: accent)),
        Text(label, style: TextStyle(fontSize: 11, color: textSecondary)),
      ],
    );
  }
}
