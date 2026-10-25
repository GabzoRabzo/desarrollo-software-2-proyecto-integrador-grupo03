import 'package:flutter/material.dart';
import '../models/curso.dart';
import '../services/database_service.dart';
import '../services/panel_data.dart';
import '../theme/app_theme.dart';
import '../widgets/app_shell.dart';
import '../widgets/common.dart';
import '../widgets/course_card.dart';

class CursosScreen extends StatefulWidget {
  const CursosScreen({super.key});

  @override
  State<CursosScreen> createState() => _CursosScreenState();
}

class _CursosScreenState extends State<CursosScreen> {
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

  Future<void> _abrirFormulario([Curso? curso]) async {
    await Navigator.pushNamed(context, '/cursos/nuevo', arguments: curso);
    _recargar();
  }

  Future<void> _eliminar(Curso c) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar curso'),
        content: Text(
            '¿Eliminar "${c.nombre}"? También se eliminarán sus tareas (eliminación en cascada).'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await DatabaseService.instance.deleteCurso(c.id!);
      _recargar();
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = _data;
    return AppShell(
      route: '/cursos',
      title: 'Mis cursos',
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormulario(),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Nuevo curso'),
      ),
      child: d == null
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 90),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionTitle(
                    icon: Icons.menu_book_rounded,
                    text: 'Mis cursos (${d.cursos.length}) · ${d.kpis['totalCreditos']} créditos',
                  ),
                  const SizedBox(height: 14),
                  if (d.cursos.isEmpty)
                    const Panel(
                        child: EmptyState(
                            icon: Icons.menu_book_outlined,
                            message: 'No hay cursos. Usa "Nuevo curso" para registrar uno.'))
                  else
                    CourseGrid(
                      minCardWidth: 290,
                      children: [
                        for (final c in d.cursos)
                          CourseCard(
                            curso: c,
                            progreso: d.progreso[c.id] ?? 0,
                            pendientes: d.pendientesDe(c.id!),
                            onTap: () => _abrirFormulario(c),
                            onEdit: () => _abrirFormulario(c),
                            onDelete: () => _eliminar(c),
                          ),
                      ],
                    ),
                ],
              ),
            ),
    );
  }
}
