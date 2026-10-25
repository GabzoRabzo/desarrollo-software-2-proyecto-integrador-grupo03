import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/curso.dart';
import '../models/tarea.dart';

/// Capa de datos local (offline-first).
///
/// Los datos iniciales se cargan desde assets/data/datos_academico.json y
/// se persisten de manera transparente en SharedPreferences.
class DatabaseService {
  static final DatabaseService instance = DatabaseService._internal();
  DatabaseService._internal();

  static const _kCursos = 'db_cursos_v4';
  static const _kTareas = 'db_tareas_v4';

  final List<Curso> _cursosDb = [];
  final List<Tarea> _tareasDb = [];
  int _cursoIdCounter = 1;
  int _tareaIdCounter = 1;
  bool _initialized = false;
  Future<void>? _initFuture;

  Future<void> initDatabase() {
    return _initFuture ??= _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final rawC = prefs.getString(_kCursos);
    final rawT = prefs.getString(_kTareas);
    if (rawC != null && rawT != null) {
      try {
        _cursosDb.addAll((jsonDecode(rawC) as List)
            .map((e) => Curso.fromMap(Map<String, dynamic>.from(e as Map))));
        _tareasDb.addAll((jsonDecode(rawT) as List)
            .map((e) => Tarea.fromMap(Map<String, dynamic>.from(e as Map))));
      } catch (_) {
        _cursosDb.clear();
        _tareasDb.clear();
      }
    }
    if (_cursosDb.isEmpty) {
      await _sembrarDesdeJson();
      await _persist();
    }
    _cursoIdCounter =
        _cursosDb.fold<int>(0, (m, c) => (c.id ?? 0) > m ? c.id! : m) + 1;
    _tareaIdCounter =
        _tareasDb.fold<int>(0, (m, t) => (t.id ?? 0) > m ? t.id! : m) + 1;
    _initialized = true;
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _kCursos, jsonEncode(_cursosDb.map((c) => c.toMap()).toList()));
    await prefs.setString(
        _kTareas, jsonEncode(_tareasDb.map((t) => t.toMap()).toList()));
  }

  /// Carga datos iniciales desde assets/data/datos_academico.json
  Future<void> _sembrarDesdeJson() async {
    final ahora = DateTime.now();
    DateTime en(int dias, [int hora = 23]) =>
        DateTime(ahora.year, ahora.month, ahora.day, hora, 59)
            .add(Duration(days: dias));

    try {
      final raw = await rootBundle.loadString('assets/data/datos_academico.json');
      final data = jsonDecode(raw) as Map<String, dynamic>;
      final cursosRaw = data['cursos'] as List?;
      if (cursosRaw != null) {
        for (final item in cursosRaw) {
          final m = Map<String, dynamic>.from(item as Map);
          final h = m['horario'] as String? ?? '';
          final a = m['aula'] as String? ?? '';
          final horarioCompleto = (h.isNotEmpty && a.isNotEmpty)
              ? '$h · $a'
              : (h.isNotEmpty ? h : a);
          _cursosDb.add(Curso(
            id: m['id'] as int?,
            nombre: m['nombre'] as String? ?? '',
            docente: m['docente'] as String? ?? '',
            creditos: m['creditos'] as int? ?? 3,
            ciclo: m['ciclo'] as String? ?? 'X Ciclo',
            colorHex: m['colorHex'] as String? ?? '#7A1B28',
            horario: horarioCompleto,
          ));
        }
      }

      final tareasRaw = data['tareas'] as List?;
      if (tareasRaw != null) {
        for (final item in tareasRaw) {
          final m = Map<String, dynamic>.from(item as Map);
          final diasRel = m['diasRelativos'] as int? ?? 1;
          final hora = m['hora'] as int? ?? 23;
          _tareasDb.add(Tarea(
            id: m['id'] as int?,
            cursoId: m['cursoId'] as int? ?? 1,
            titulo: m['titulo'] as String? ?? '',
            descripcion: m['descripcion'] as String? ?? '',
            fechaEntrega: en(diasRel, hora),
            prioridad: m['prioridad'] as String? ?? 'Media',
            completada: m['completada'] as bool? ?? false,
            horasEstimadas: m['horasEstimadas'] as int? ?? 2,
          ));
        }
      }
    } catch (_) {
      _sembrarFallback();
    }
  }

  void _sembrarFallback() {
    final ahora = DateTime.now();
    DateTime en(int dias, [int hora = 23]) =>
        DateTime(ahora.year, ahora.month, ahora.day, hora, 59)
            .add(Duration(days: dias));

    _cursosDb.addAll(const [
      Curso(
        id: 1,
        nombre: 'DESARROLLO DE SOFTWARE II',
        docente: 'Mtro. Ing. Yover Collantes Valer',
        creditos: 4,
        ciclo: 'X Ciclo',
        colorHex: '#7A1B28',
        horario: 'Lun y Mié 16:00 - 18:00 · IN304',
      ),
      Curso(
        id: 2,
        nombre: 'GESTIÓN DE PROYECTOS DE TI',
        docente: 'Mg. Carlos Mendoza',
        creditos: 3,
        ciclo: 'X Ciclo',
        colorHex: '#9A7410',
        horario: 'Mar-Jue 09:00-11:00',
      ),
    ]);

    _tareasDb.addAll([
      Tarea(
        id: 1,
        cursoId: 1,
        titulo: 'Entregable E1: Arquitectura y Modelado de Datos',
        descripcion: 'Informe técnico y prototipo funcional con persistencia local.',
        fechaEntrega: en(2),
        prioridad: 'Alta',
        horasEstimadas: 8,
      ),
    ]);
  }

  Future<void> reiniciarDesdeJson() async {
    _cursosDb.clear();
    _tareasDb.clear();
    await _sembrarDesdeJson();
    await _persist();
    _cursoIdCounter =
        _cursosDb.fold<int>(0, (m, c) => (c.id ?? 0) > m ? c.id! : m) + 1;
    _tareaIdCounter =
        _tareasDb.fold<int>(0, (m, t) => (t.id ?? 0) > m ? t.id! : m) + 1;
  }

  Future<String> exportarJson() async {
    await initDatabase();
    final map = {
      'cursos': _cursosDb.map((c) => c.toMap()).toList(),
      'tareas': _tareasDb.map((t) => t.toMap()).toList(),
    };
    return const JsonEncoder.withIndent('  ').convert(map);
  }

  // --- Cursos ---
  Future<List<Curso>> getCursos() async {
    await initDatabase();
    return List.unmodifiable(_cursosDb);
  }

  Future<Curso> insertCurso(Curso curso) async {
    await initDatabase();
    final nuevo = curso.copyWith(id: _cursoIdCounter++);
    _cursosDb.add(nuevo);
    await _persist();
    return nuevo;
  }

  Future<void> updateCurso(Curso curso) async {
    await initDatabase();
    final idx = _cursosDb.indexWhere((c) => c.id == curso.id);
    if (idx != -1) {
      _cursosDb[idx] = curso;
      await _persist();
    }
  }

  Future<void> deleteCurso(int id) async {
    await initDatabase();
    _cursosDb.removeWhere((c) => c.id == id);
    _tareasDb.removeWhere((t) => t.cursoId == id); // cascada
    await _persist();
  }

  // --- Tareas ---
  Future<List<Tarea>> getTareas() async {
    await initDatabase();
    final copia = List<Tarea>.from(_tareasDb)
      ..sort((a, b) => a.fechaEntrega.compareTo(b.fechaEntrega));
    return List.unmodifiable(copia);
  }

  Future<List<Tarea>> getTareasByCurso(int cursoId) async {
    await initDatabase();
    return _tareasDb.where((t) => t.cursoId == cursoId).toList();
  }

  Future<Tarea> insertTarea(Tarea tarea) async {
    await initDatabase();
    final nueva = tarea.copyWith(id: _tareaIdCounter++);
    _tareasDb.add(nueva);
    await _persist();
    return nueva;
  }

  Future<void> toggleTareaCompletada(int id) async {
    await initDatabase();
    final idx = _tareasDb.indexWhere((t) => t.id == id);
    if (idx != -1) {
      final actual = _tareasDb[idx];
      _tareasDb[idx] = actual.copyWith(completada: !actual.completada);
      await _persist();
    }
  }

  Future<void> deleteTarea(int id) async {
    await initDatabase();
    _tareasDb.removeWhere((t) => t.id == id);
    await _persist();
  }

  Future<void> restaurarDatosDemo() async {
    await initDatabase();
    _cursosDb.clear();
    _tareasDb.clear();
    await _sembrarDesdeJson();
    _cursoIdCounter =
        _cursosDb.fold<int>(0, (m, c) => (c.id ?? 0) > m ? c.id! : m) + 1;
    _tareaIdCounter =
        _tareasDb.fold<int>(0, (m, t) => (t.id ?? 0) > m ? t.id! : m) + 1;
    await _persist();
  }

  // --- Métricas derivadas (se calculan, no se almacenan) ---
  Future<Map<String, dynamic>> getKpis() async {
    await initDatabase();
    final ahora = DateTime.now();
    final hoy = DateTime(ahora.year, ahora.month, ahora.day);
    final finSemana = hoy.add(const Duration(days: 7));
    final pendientes = _tareasDb.where((t) => !t.completada).toList();
    final completadas = _tareasDb.length - pendientes.length;
    final estaSemana = pendientes
        .where((t) => !t.fechaEntrega.isBefore(hoy) && t.fechaEntrega.isBefore(finSemana))
        .length;
    final horasPendientes = pendientes.fold<int>(0, (s, t) => s + t.horasEstimadas);
    final evidencias = _tareasDb.where((t) => t.evidenciaPath != null).length;

    return {
      'cursosActivos': _cursosDb.length,
      'totalCreditos': _cursosDb.fold<int>(0, (s, c) => s + c.creditos),
      'totalTareas': _tareasDb.length,
      'tareasPendientes': pendientes.length,
      'tareasCompletadas': completadas,
      'entregasEstaSemana': estaSemana,
      'horasPendientes': horasPendientes,
      'evidenciasDigitales': evidencias,
      'porcentajeCompletado':
          _tareasDb.isEmpty ? 0.0 : completadas / _tareasDb.length * 100,
    };
  }

  /// Avance por curso = tareas completadas / tareas del curso (0..1).
  Future<double> progresoCurso(int cursoId) async {
    await initDatabase();
    final t = _tareasDb.where((x) => x.cursoId == cursoId).toList();
    if (t.isEmpty) return 0;
    return t.where((x) => x.completada).length / t.length;
  }

  bool get isReady => _initialized;
}
