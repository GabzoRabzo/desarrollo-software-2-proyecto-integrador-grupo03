import 'package:flutter/material.dart';
import '../models/tarea.dart';
import '../services/panel_data.dart';
import '../services/preferences_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_shell.dart';
import '../widgets/common.dart';
import '../widgets/course_card.dart';
import '../widgets/mini_calendar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final PreferencesService _prefs = PreferencesService.instance;
  PanelData? _data;

  @override
  void initState() {
    super.initState();
    _recargar();
  }

  Future<void> _recargar() async {
    final d = await PanelData.cargar();
    if (mounted) setState(() => _data = d);
  }


  @override
  Widget build(BuildContext context) {
    final data = _data;
    return AppShell(
      route: '/',
      title: 'Dashboard',
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.pushNamed(context, '/tareas/nueva');
          _recargar();
        },
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_task),
        label: const Text('Nueva tarea'),
      ),
      child: data == null
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : RefreshIndicator(
              color: AppColors.primary,
              onRefresh: _recargar,
              child: LayoutBuilder(builder: (context, c) {
                final dosColumnas = c.maxWidth >= 860;
                final centro = _columnaCentral(data, dosColumnas);
                final derecha = _columnaDerecha(data);
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(20, 20, 20, dosColumnas ? 24 : 90),
                  child: dosColumnas
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: centro),
                            const SizedBox(width: 20),
                            SizedBox(width: 318, child: derecha),
                          ],
                        )
                      : Column(
                          children: [
                            _bienvenida(data, false),
                            const SizedBox(height: 16),
                            _cursos(data),
                            const SizedBox(height: 16),
                            _actividadYAvisos(data, false),
                            const SizedBox(height: 16),
                            derecha,
                          ],
                        ),
                );
              }),
            ),
    );
  }

  // ---------------------------------------------------------------- centro
  Widget _columnaCentral(PanelData d, bool wide) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _bienvenida(d, wide),
        const SizedBox(height: 22),
        _cursos(d),
        const SizedBox(height: 22),
        _actividadYAvisos(d, wide),
      ],
    );
  }

  Widget _bienvenida(PanelData d, bool wide) {
    final nombre = _prefs.estudianteActivo['corto']!;
    final k = d.kpis;
    final stats = Wrap(
      spacing: 26,
      runSpacing: 14,
      children: [
        StatTile(
            icon: Icons.menu_book_rounded,
            color: AppColors.primary,
            value: '${k['cursosActivos']}',
            label: 'Cursos activos'),
        StatTile(
            icon: Icons.assignment_late_outlined,
            color: AppColors.info,
            value: '${k['tareasPendientes']}',
            label: 'Tareas pendientes'),
        StatTile(
            icon: Icons.star_rounded,
            color: AppColors.gold,
            value: '${k['entregasEstaSemana']}',
            label: 'Entregas esta semana'),
        StatTile(
            icon: Icons.schedule_rounded,
            color: AppColors.success,
            value: '${k['horasPendientes']}',
            label: 'Horas de estudio'),
      ],
    );
    final saludo = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                '¡Bienvenido de regreso, $nombre!',
                style: const TextStyle(
                    fontSize: 21, fontWeight: FontWeight.w900, color: AppColors.ink),
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.waving_hand_rounded, color: AppColors.gold, size: 22),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'Revisa tus cursos, organiza tus entregas y mantén tu avance académico al día.',
          style: TextStyle(color: AppColors.muted, height: 1.35),
        ),
      ],
    );
    return Panel(
      padding: const EdgeInsets.all(20),
      child: wide
          ? Row(
              children: [
                Expanded(flex: 4, child: saludo),
                const SizedBox(width: 20),
                Expanded(flex: 6, child: Align(alignment: Alignment.centerRight, child: stats)),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [saludo, const SizedBox(height: 16), stats],
            ),
    );
  }

  Widget _cursos(PanelData d) {
    final lista = d.cursos.take(3).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          icon: Icons.school_outlined,
          text: 'Mis cursos',
          actionLabel: 'Ver todos',
          onAction: () => AppShell.navegar(context, '/cursos', '/'),
        ),
        const SizedBox(height: 12),
        if (lista.isEmpty)
          const Panel(child: EmptyState(icon: Icons.menu_book_outlined, message: 'Aún no registras cursos'))
        else
          CourseGrid(
            minCardWidth: 220,
            children: [
              for (final c in lista)
                CourseCard(
                  curso: c,
                  progreso: d.progreso[c.id] ?? 0,
                  pendientes: d.pendientesDe(c.id!),
                  onTap: () => AppShell.navegar(context, '/cursos', '/'),
                ),
            ],
          ),
      ],
    );
  }

  Widget _actividadYAvisos(PanelData d, bool wide) {
    final actividad = _panelActividad(d);
    final avisos = _panelAvisos(d);
    if (!wide) {
      return Column(children: [actividad, const SizedBox(height: 16), avisos]);
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 6, child: actividad),
        const SizedBox(width: 16),
        Expanded(flex: 5, child: avisos),
      ],
    );
  }

  Widget _panelActividad(PanelData d) {
    final ahora = DateTime.now();
    final orden = List<Tarea>.from(d.tareas)
      ..sort((a, b) => a.fechaEntrega
          .difference(ahora)
          .abs()
          .compareTo(b.fechaEntrega.difference(ahora).abs()));
    final items = orden.take(4).toList();

    return Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(icon: Icons.trending_up_rounded, text: 'Actividad reciente'),
          const SizedBox(height: 8),
          if (items.isEmpty)
            const EmptyState(icon: Icons.inbox_outlined, message: 'Sin actividad registrada')
          else
            for (final t in items) _filaActividad(d, t),
        ],
      ),
    );
  }

  Widget _filaActividad(PanelData d, Tarea t) {
    final curso = d.cursoDe(t.cursoId);
    final color = curso == null ? AppColors.primary : colorDesdeHex(curso.colorHex);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: (t.completada ? AppColors.success : color).withValues(alpha: 0.13),
              borderRadius: BorderRadius.zero,
              border: Border.all(color: (t.completada ? AppColors.success : color).withValues(alpha: 0.35)),
            ),
            child: Icon(
              t.completada ? Icons.check_rounded : Icons.assignment_outlined,
              size: 18,
              color: t.completada ? AppColors.success : color,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.titulo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                Text((curso?.nombre ?? '').toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 10.5, color: AppColors.muted)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            t.completada ? 'Completada' : venceEn(t.fechaEntrega),
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: t.completada ? AppColors.success : AppColors.muted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _panelAvisos(PanelData d) {
    final proxima = d.pendientes.isEmpty ? null : d.pendientes.first;
    final nSemana = d.kpis['entregasEstaSemana'] as int;
    return Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(icon: Icons.campaign_outlined, text: 'Avisos importantes'),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.goldSoft,
              borderRadius: BorderRadius.zero,
              border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Semana académica',
                          style: TextStyle(
                              fontWeight: FontWeight.w900, color: AppColors.primaryDark)),
                      const SizedBox(height: 4),
                      Text(
                        proxima == null
                            ? 'No tienes entregas pendientes. ¡Buen trabajo!'
                            : 'Tienes $nSemana entrega(s) en los próximos 7 días. '
                                'Siguiente: ${proxima.titulo} (${venceEn(proxima.fechaEntrega).toLowerCase()}).',
                        style: const TextStyle(fontSize: 12.5, height: 1.35, color: AppColors.ink),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.event_available_rounded, size: 44, color: AppColors.primary),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------- derecha
  Widget _columnaDerecha(PanelData d) {
    return Column(
      children: [
        Panel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(icon: Icons.calendar_month_outlined, text: 'Calendario académico'),
              const SizedBox(height: 6),
              MiniCalendar(
                tareas: d.tareas,
                onSelect: (_) => AppShell.navegar(context, '/calendario', '/'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _eventos(d),
      ],
    );
  }


  Widget _eventos(PanelData d) {
    final prox = d.pendientes.take(3).toList();
    return Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            icon: Icons.history_toggle_off_rounded,
            text: 'Eventos próximos',
            actionLabel: 'Ver todo',
            onAction: () => AppShell.navegar(context, '/tareas', '/'),
          ),
          const SizedBox(height: 8),
          if (prox.isEmpty)
            const EmptyState(icon: Icons.event_busy_outlined, message: 'Sin eventos próximos')
          else
            for (final t in prox)
              Builder(builder: (_) {
                final curso = d.cursoDe(t.cursoId);
                final color = curso == null ? AppColors.primary : colorDesdeHex(curso.colorHex);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.zero,
                          border: Border.all(color: color.withValues(alpha: 0.35)),
                        ),
                        child: Icon(Icons.assignment_turned_in_outlined, size: 19, color: color),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t.titulo,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 12.5)),
                            Text('${fechaCorta(t.fechaEntrega)}, 23:59',
                                style: const TextStyle(fontSize: 11, color: AppColors.muted)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }
}
