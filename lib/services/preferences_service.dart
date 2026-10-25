import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthResultado {
  exito,
  codigoNoExiste,
  passwordIncorrecto,
}

/// Preferencias del usuario y gestión de sesión cargadas desde JSON.
class PreferencesService {
  static final PreferencesService instance = PreferencesService._internal();
  PreferencesService._internal();

  static const _kActivo = 'pref_estudiante_activo';
  static const _kSesion = 'pref_sesion_activa';
  static const _kEstudiantesModificados = 'pref_estudiantes_custom_v1';

  List<Map<String, String>> _estudiantes = [
    {
      'codigo': '221451',
      'nombre': 'RODRÍGUEZ-CCOYTO-JAIRO JASER',
      'corto': 'Jairo',
      'iniciales': 'JR',
      'carrera': 'INGENIERÍA INFORMÁTICA Y DE SISTEMAS',
      'ciclo': 'Semestre académico 2026-II',
      'direccion': '3 DE MAYO 202',
      'telefono': '949050422',
      'email': 'JAIROJASERODRIGUEZ@GMAIL.COM',
      'password': '123',
    },
    {
      'codigo': '220552',
      'nombre': 'QUISPE-CHECYA-JOAN GONZALO',
      'corto': 'Joan',
      'iniciales': 'JQ',
      'carrera': 'INGENIERÍA INFORMÁTICA Y DE SISTEMAS',
      'ciclo': 'Semestre académico 2026-II',
      'direccion': 'AV. TÚPAC AMARU S/N',
      'telefono': '984123456',
      'email': 'JOAN.QUISPE@UNSAAC.EDU.PE',
      'password': '123',
    },
  ];
  int _activo = 0;
  bool _cargado = false;
  bool _sesionIniciada = false;

  List<Map<String, String>> get integrantes => _estudiantes;
  int get estudianteActivoIndex => _activo;
  Map<String, String> get estudianteActivo =>
      _estudiantes.isNotEmpty ? _estudiantes[_activo] : <String, String>{};

  bool get sesionIniciada => _sesionIniciada;
  String get ciclo => 'Semestre académico 2026-II';
  String get carrera => 'Ingeniería Informática y de Sistemas';
  String get facultad => 'Facultad de Ingeniería Eléctrica, Electrónica, Informática y Mecánica';

  Future<void> cargar() async {
    if (_cargado) return;
    final prefs = await SharedPreferences.getInstance();

    // 1. Intentar cargar desde cache local o desde assets JSON
    final customJson = prefs.getString(_kEstudiantesModificados);
    if (customJson != null) {
      try {
        final list = (jsonDecode(customJson) as List)
            .map((e) => Map<String, String>.from(e as Map))
            .toList();
        if (list.isNotEmpty) {
          _estudiantes = list;
        }
      } catch (_) {}
    }

    if (_estudiantes.isEmpty) {
      try {
        final raw = await rootBundle.loadString('assets/data/datos_academico.json');
        final data = jsonDecode(raw) as Map<String, dynamic>;
        final list = (data['estudiantes'] as List)
            .map((e) => (e as Map<String, dynamic>).map((k, v) => MapEntry(k, v.toString())))
            .toList();
        _estudiantes = list;
      } catch (_) {
        _estudiantes = [
          {
            'codigo': '221451',
            'nombre': 'RODRÍGUEZ-CCOYTO-JAIRO JASER',
            'corto': 'Jairo',
            'iniciales': 'JR',
            'carrera': 'INGENIERÍA INFORMÁTICA Y DE SISTEMAS',
            'ciclo': 'Semestre académico 2026-II',
            'direccion': '3 DE MAYO 202',
            'telefono': '949050422',
            'email': 'JAIROJASERODRIGUEZ@GMAIL.COM',
            'password': '123',
          },
          {
            'codigo': '220552',
            'nombre': 'QUISPE-CHECYA-JOAN GONZALO',
            'corto': 'Joan',
            'iniciales': 'JQ',
            'carrera': 'INGENIERÍA INFORMÁTICA Y DE SISTEMAS',
            'ciclo': 'Semestre académico 2026-II',
            'direccion': 'AV. TÚPAC AMARU S/N',
            'telefono': '984123456',
            'email': 'JOAN.QUISPE@UNSAAC.EDU.PE',
            'password': '123',
          },
        ];
      }
    }

    final idx = prefs.getInt(_kActivo) ?? 0;
    _activo = (idx >= 0 && idx < _estudiantes.length) ? idx : 0;
    _sesionIniciada = prefs.getBool(_kSesion) ?? false;
    _cargado = true;
  }

  Future<void> setEstudianteActivoIndex(int index) async {
    if (index < 0 || index >= _estudiantes.length) return;
    _activo = index;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kActivo, index);
  }

  Future<void> alternarEstudianteActivo() =>
      setEstudianteActivoIndex((_activo + 1) % _estudiantes.length);

  Future<AuthResultado> autenticarEstudiante(String codigo, String password) async {
    await cargar();
    final c = codigo.trim().toLowerCase();
    final p = password.trim();

    final idx = _estudiantes.indexWhere(
        (e) => (e['codigo'] ?? '').trim().toLowerCase() == c);
    if (idx == -1) {
      return AuthResultado.codigoNoExiste;
    }

    final passRegistrada = (_estudiantes[idx]['password'] ?? '123').trim();
    if (p != passRegistrada) {
      return AuthResultado.passwordIncorrecto;
    }

    await setEstudianteActivoIndex(idx);
    _sesionIniciada = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kSesion, true);
    return AuthResultado.exito;
  }

  Future<bool> autenticar(String codigo, String password) async {
    final r = await autenticarEstudiante(codigo, password);
    return r == AuthResultado.exito;
  }

  Future<void> cerrarSesion() async {
    _sesionIniciada = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kSesion, false);
  }

  Future<void> actualizarEstudianteActivo({
    required String direccion,
    required String telefono,
    required String email,
  }) async {
    if (_estudiantes.isEmpty) return;
    final act = Map<String, String>.from(_estudiantes[_activo]);
    act['direccion'] = direccion;
    act['telefono'] = telefono;
    act['email'] = email;
    _estudiantes[_activo] = act;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kEstudiantesModificados, jsonEncode(_estudiantes));
  }
}
