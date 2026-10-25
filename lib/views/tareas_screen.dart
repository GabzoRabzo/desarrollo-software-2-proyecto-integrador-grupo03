import 'package:flutter/material.dart';
import '../models/tarea.dart';
import '../services/database_service.dart';
import '../services/panel_data.dart';
import '../theme/app_theme.dart';
import '../widgets/app_shell.dart';
import '../widgets/common.dart';

class TareasScreen extends StatefulWidget {
  const TareasScreen({super.key});

  @override
  State<TareasScreen> createState() => _TareasScreenState();
}

class _TareasScreenState extends State<TareasScreen> {
  PanelData? _data;
  String _filtro = 'Todas';
  static const _filtros = ['Todas', 'Pendientes', 'Urgentes', 'Completadas'];

  @override
  void initState() {
    super.initState();
    _recargar();
  }

  Future<void> _recargar() async {
    final d = await PanelData.cargar();
    if (mounted) setState(() => _data = d);
  }

  List<Tarea> _filtradas(PanelData d) {
    return d.tareas.where((t) {
      switch (_filtro) {
        case 'Pendientes':
          return !t.completada;
        case 'Urgentes':
          return !t.completada && t.prioridad == 'Alta';
        case 'Completadas':
          return t.completada;
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final d = _data;
    return AppShell(
      route: '/tareas',
      title: 'Tareas',
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
      child: d == null
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 960),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 90),
                  children: [
                    SectionTitle(
                      icon: Icons.checklist_rounded,
                      text: 'Tareas y entregables',
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        for (final f in _filtros)
                          ChoiceChip(
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                            label: Text(f),
                            selected: _filtro == f,
                            selectedColor: AppColors.primary,
                            backgroundColor: Colors.white,
                            labelStyle: TextStyle(
                              color: _filtro == f ? Colors.white : AppColors.ink,
                              fontWeight: FontWeight.w700,
                            ),
                            checkmarkColor: Colors.white,
                            onSelected: (_) => setState(() => _filtro = f),
                          ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    ..._lista(d),
                  ],
                ),
              ),
            ),
    );
  }

  List<Widget> _lista(PanelData d) {
    final items = _filtradas(d);
    if (items.isEmpty) {
      return const [
        Panel(child: EmptyState(icon: Icons.inbox_outlined, message: 'No hay tareas en esta vista')),
      ];
    }
    return [
      for (final t in items)
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _TareaTile(
            tarea: t,
            cursoNombre: d.cursoDe(t.cursoId)?.nombre ?? '',
            cursoColor: d.cursoDe(t.cursoId) == null
                ? AppColors.primary
                : colorDesdeHex(d.cursoDe(t.cursoId)!.colorHex),
            onToggle: () async {
              await DatabaseService.instance.toggleTareaCompletada(t.id!);
              _recargar();
            },
            onDelete: () async {
              await DatabaseService.instance.deleteTarea(t.id!);
              _recargar();
            },
          ),
        ),
    ];
  }
}

class _TareaTile extends StatelessWidget {
  final Tarea tarea;
  final String cursoNombre;
  final Color cursoColor;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _TareaTile({
    required this.tarea,
    required this.cursoNombre,
    required this.cursoColor,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Panel(
      padding: const EdgeInsets.fromLTRB(8, 10, 10, 10),
      child: Row(
        children: [
          Checkbox(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            value: tarea.completada,
            activeColor: AppColors.success,
            onChanged: (_) => onToggle(),
          ),
          Container(width: 4, height: 40, color: cursoColor),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tarea.titulo,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    decoration: tarea.completada ? TextDecoration.lineThrough : null,
                    color: tarea.completada ? AppColors.muted : AppColors.ink,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '$cursoNombre · ${fechaCorta(tarea.fechaEntrega)} · ${tarea.horasEstimadas} h · '
                  '${tarea.completada ? 'Completada' : venceEn(tarea.fechaEntrega)}',
                  style: const TextStyle(fontSize: 12, color: AppColors.muted),
                ),
              ],
            ),
          ),
          PrioridadChip(tarea.prioridad),
          IconButton(
            tooltip: 'Eliminar tarea',
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline, color: AppColors.muted, size: 20),
          ),
        ],
      ),
    );
  }
}
