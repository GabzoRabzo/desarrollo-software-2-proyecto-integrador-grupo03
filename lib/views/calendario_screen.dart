import 'package:flutter/material.dart';
import '../models/tarea.dart';
import '../services/panel_data.dart';
import '../theme/app_theme.dart';
import '../widgets/app_shell.dart';
import '../widgets/common.dart';
import '../widgets/mini_calendar.dart';

class CalendarioScreen extends StatefulWidget {
  const CalendarioScreen({super.key});

  @override
  State<CalendarioScreen> createState() => _CalendarioScreenState();
}

class _CalendarioScreenState extends State<CalendarioScreen> {
  PanelData? _data;
  DateTime _dia = DateTime.now();

  @override
  void initState() {
    super.initState();
    PanelData.cargar().then((d) {
      if (mounted) setState(() => _data = d);
    });
  }

  bool _mismo(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final d = _data;
    return AppShell(
      route: '/calendario',
      title: 'Calendario académico',
      child: d == null
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : LayoutBuilder(builder: (context, c) {
              final wide = c.maxWidth >= 760;
              final calendario = Panel(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionTitle(
                        icon: Icons.calendar_month_rounded, text: 'Calendario académico'),
                    const SizedBox(height: 8),
                    MiniCalendar(
                      tareas: d.tareas,
                      seleccionado: _dia,
                      onSelect: (f) => setState(() => _dia = f),
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      children: [
                        Icon(Icons.circle, size: 9, color: AppColors.gold),
                        SizedBox(width: 6),
                        Text('Entrega pendiente', style: TextStyle(fontSize: 11.5)),
                        SizedBox(width: 16),
                        Icon(Icons.circle, size: 9, color: AppColors.success),
                        SizedBox(width: 6),
                        Text('Completada', style: TextStyle(fontSize: 11.5)),
                      ],
                    ),
                  ],
                ),
              );
              final detalle = _detalle(d);
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: wide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 5, child: calendario),
                          const SizedBox(width: 20),
                          Expanded(flex: 5, child: detalle),
                        ],
                      )
                    : Column(children: [calendario, const SizedBox(height: 16), detalle]),
              );
            }),
    );
  }

  Widget _detalle(PanelData d) {
    final delDia = d.tareas.where((t) => _mismo(t.fechaEntrega, _dia)).toList();
    return Panel(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            icon: Icons.event_note_rounded,
            text: 'Entregas del ${_dia.day} de ${kMeses[_dia.month - 1].toLowerCase()}',
          ),
          const SizedBox(height: 10),
          if (delDia.isEmpty)
            const EmptyState(
                icon: Icons.event_available_outlined, message: 'Sin entregas este día')
          else
            for (final Tarea t in delDia)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: (t.completada ? AppColors.success : AppColors.gold).withValues(alpha: 0.18),
                    border: Border.all(
                      color: (t.completada ? AppColors.success : AppColors.gold).withValues(alpha: 0.4),
                    ),
                  ),
                  child: Icon(
                    t.completada ? Icons.check : Icons.assignment_outlined,
                    color: t.completada ? AppColors.success : AppColors.primary,
                  ),
                ),
                title: Text(t.titulo, style: const TextStyle(fontWeight: FontWeight.w700)),
                subtitle: Text(
                    '${d.cursoDe(t.cursoId)?.nombre ?? ''} · ${t.horasEstimadas} h estimadas'),
                trailing: PrioridadChip(t.prioridad),
              ),
          const Divider(height: 28),
          const Text('Próximas entregas',
              style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary)),
          const SizedBox(height: 6),
          for (final t in d.pendientes.take(4))
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  SizedBox(
                    width: 62,
                    child: Text(fechaCorta(t.fechaEntrega),
                        style: const TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 12.5)),
                  ),
                  Expanded(
                    child: Text(t.titulo,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12.5)),
                  ),
                  Text(venceEn(t.fechaEntrega),
                      style: const TextStyle(fontSize: 11.5, color: AppColors.muted)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
