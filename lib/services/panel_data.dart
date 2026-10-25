import '../models/curso.dart';
import '../models/tarea.dart';
import 'database_service.dart';

/// Instantánea de datos que consumen las pantallas del panel.
class PanelData {
  final List<Curso> cursos;
  final List<Tarea> tareas;
  final Map<String, dynamic> kpis;
  final Map<int, double> progreso;

  const PanelData({
    required this.cursos,
    required this.tareas,
    required this.kpis,
    required this.progreso,
  });

  static Future<PanelData> cargar() async {
    final db = DatabaseService.instance;
    final cursos = await db.getCursos();
    final tareas = await db.getTareas();
    final kpis = await db.getKpis();
    final progreso = <int, double>{};
    for (final c in cursos) {
      progreso[c.id!] = await db.progresoCurso(c.id!);
    }
    return PanelData(cursos: cursos, tareas: tareas, kpis: kpis, progreso: progreso);
  }

  Curso? cursoDe(int cursoId) {
    for (final c in cursos) {
      if (c.id == cursoId) return c;
    }
    return null;
  }

  int pendientesDe(int cursoId) =>
      tareas.where((t) => t.cursoId == cursoId && !t.completada).length;

  List<Tarea> get pendientes =>
      tareas.where((t) => !t.completada).toList()
        ..sort((a, b) => a.fechaEntrega.compareTo(b.fechaEntrega));
}
