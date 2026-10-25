import 'package:flutter/material.dart';
import '../models/tarea.dart';
import '../theme/app_theme.dart';

/// Calendario mensual compacto; marca con punto los días con entregas.
class MiniCalendar extends StatefulWidget {
  final List<Tarea> tareas;
  final DateTime? seleccionado;
  final ValueChanged<DateTime>? onSelect;

  const MiniCalendar({
    super.key,
    required this.tareas,
    this.seleccionado,
    this.onSelect,
  });

  @override
  State<MiniCalendar> createState() => _MiniCalendarState();
}

class _MiniCalendarState extends State<MiniCalendar> {
  late DateTime _mes;

  @override
  void initState() {
    super.initState();
    final base = widget.seleccionado ?? DateTime.now();
    _mes = DateTime(base.year, base.month, 1);
  }

  void _cambiarMes(int delta) {
    setState(() => _mes = DateTime(_mes.year, _mes.month + delta, 1));
  }

  bool _mismoDia(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final hoy = DateTime.now();
    final offset = _mes.weekday - 1; // lunes = 0
    final diasMes = DateTime(_mes.year, _mes.month + 1, 0).day;
    final filas = ((offset + diasMes) / 7).ceil();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              visualDensity: VisualDensity.compact,
              tooltip: 'Mes anterior',
              icon: const Icon(Icons.chevron_left),
              onPressed: () => _cambiarMes(-1),
            ),
            Text(
              '${kMeses[_mes.month - 1]} ${_mes.year}',
              style: const TextStyle(
                  fontWeight: FontWeight.w800, color: AppColors.primary, fontSize: 14.5),
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              tooltip: 'Mes siguiente',
              icon: const Icon(Icons.chevron_right),
              onPressed: () => _cambiarMes(1),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            for (final d in kDiasCortos)
              Expanded(
                child: Center(
                  child: Text(d,
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.muted)),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        for (int f = 0; f < filas; f++)
          Row(
            children: [
              for (int c = 0; c < 7; c++)
                Expanded(child: _celda(f * 7 + c - offset + 1, diasMes, hoy)),
            ],
          ),
      ],
    );
  }

  Widget _celda(int dia, int diasMes, DateTime hoy) {
    if (dia < 1 || dia > diasMes) return const SizedBox(height: 38);
    final fecha = DateTime(_mes.year, _mes.month, dia);
    final delDia = widget.tareas.where((t) => _mismoDia(t.fechaEntrega, fecha)).toList();
    final hayPendiente = delDia.any((t) => !t.completada);
    final hayCompletada = delDia.any((t) => t.completada);
    final esHoy = _mismoDia(fecha, hoy);
    final esSel = widget.seleccionado != null && _mismoDia(fecha, widget.seleccionado!);

    return InkWell(
      borderRadius: BorderRadius.zero,
      onTap: widget.onSelect == null ? null : () => widget.onSelect!(fecha),
      child: SizedBox(
        height: 38,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 26,
              height: 26,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: esHoy ? AppColors.primary : null,
                borderRadius: BorderRadius.zero,
                border: esSel && !esHoy
                    ? Border.all(color: AppColors.gold, width: 2)
                    : null,
              ),
              child: Text(
                '$dia',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: esHoy || esSel ? FontWeight.w900 : FontWeight.w500,
                  color: esHoy ? Colors.white : AppColors.ink,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: hayPendiente
                    ? AppColors.gold
                    : (hayCompletada ? AppColors.success.withValues(alpha: 0.6) : Colors.transparent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
