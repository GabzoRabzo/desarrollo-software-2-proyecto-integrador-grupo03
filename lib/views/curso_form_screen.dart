import 'package:flutter/material.dart';
import '../models/curso.dart';
import '../services/database_service.dart';
import '../theme/app_theme.dart';

class CursoFormScreen extends StatefulWidget {
  final Curso? cursoParaEditar;

  const CursoFormScreen({super.key, this.cursoParaEditar});

  @override
  State<CursoFormScreen> createState() => _CursoFormScreenState();
}

class _CursoFormScreenState extends State<CursoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreCtrl;
  late final TextEditingController _docenteCtrl;
  late final TextEditingController _horarioCtrl;
  int _creditos = 4;
  String _ciclo = 'X Ciclo';
  String _colorHex = '#7A1B28';
  bool _isSubmitting = false;

  final List<String> _ciclosDisponibles = [
    'I Ciclo',
    'II Ciclo',
    'III Ciclo',
    'IV Ciclo',
    'V Ciclo',
    'VI Ciclo',
    'VII Ciclo',
    'VIII Ciclo',
    'IX Ciclo',
    'X Ciclo',
    'X Ciclo (Especialidad)',
    'Electivo',
  ];

  final List<int> _creditosDisponibles = [1, 2, 3, 4, 5, 6];

  final List<String> _coloresDisponibles = [
    '#7A1B28', // Granate UNSAAC
    '#9A7410', // Dorado UNSAAC
    '#1F2A44', // Azul Marino
    '#1E6F5C', // Verde Petróleo
    '#C5192D', // Rojo Carmín
    '#5C1220', // Vino
    '#2B5C8A', // Azul Acero
    '#6A1B9A', // Púrpura
    '#E65100', // Naranja
  ];

  @override
  void initState() {
    super.initState();
    final c = widget.cursoParaEditar;
    _nombreCtrl = TextEditingController(text: c?.nombre ?? '');
    _docenteCtrl = TextEditingController(text: c?.docente ?? '');
    _horarioCtrl = TextEditingController(text: c?.horario ?? '');
    if (c != null) {
      _creditos = c.creditos;
      _ciclo = c.ciclo;
      _colorHex = c.colorHex;
      if (!_ciclosDisponibles.contains(_ciclo)) {
        _ciclosDisponibles.add(_ciclo);
      }
      if (!_creditosDisponibles.contains(_creditos)) {
        _creditosDisponibles.add(_creditos);
        _creditosDisponibles.sort();
      }
      if (!_coloresDisponibles.contains(_colorHex)) {
        _coloresDisponibles.add(_colorHex);
      }
    }
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _docenteCtrl.dispose();
    _horarioCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardarCurso() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final curso = Curso(
        id: widget.cursoParaEditar?.id,
        nombre: _nombreCtrl.text.trim(),
        docente: _docenteCtrl.text.trim(),
        creditos: _creditos,
        ciclo: _ciclo,
        colorHex: _colorHex,
        horario: _horarioCtrl.text.trim(),
      );

      if (widget.cursoParaEditar == null) {
        await DatabaseService.instance.insertCurso(curso);
      } else {
        await DatabaseService.instance.updateCurso(curso);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.cursoParaEditar == null
                ? '✓ Asignatura registrada correctamente'
                : '✓ Asignatura actualizada con éxito'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context, true);
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final esEdicion = widget.cursoParaEditar != null;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Text(esEdicion ? 'Editar Asignatura' : 'Registrar Nueva Asignatura'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Card(
              elevation: 3,
              shadowColor: AppColors.primary.withValues(alpha: 0.12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
                side: BorderSide(color: AppColors.border.withValues(alpha: 0.8)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.goldSoft,
                              borderRadius: BorderRadius.zero,
                            ),
                            child: const Icon(Icons.menu_book_rounded,
                                color: AppColors.primary, size: 24),
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                esEdicion ? 'Actualizar Información' : 'Datos Académicos',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                              const Text(
                                'Formulario oficial de curso para el semestre 2026-II',
                                style: TextStyle(fontSize: 12, color: AppColors.muted),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _nombreCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Nombre de la Asignatura *',
                          hintText: 'Ej. Desarrollo de Software II',
                          prefixIcon: Icon(Icons.school_outlined),
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'El nombre de la asignatura es obligatorio.';
                          }
                          if (val.trim().length < 4) {
                            return 'El nombre debe contener al menos 4 caracteres.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _docenteCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Docente a Cargo *',
                          hintText: 'Ej. Mtro. Ing. Yover Collantes Valer',
                          prefixIcon: Icon(Icons.person_outline),
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Ingrese el nombre del docente.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              initialValue: _creditosDisponibles.contains(_creditos) ? _creditos : 4,
                              decoration: const InputDecoration(
                                labelText: 'Créditos *',
                                prefixIcon: Icon(Icons.military_tech_outlined),
                                border: OutlineInputBorder(),
                              ),
                              items: _creditosDisponibles.map((c) {
                                return DropdownMenuItem(value: c, child: Text('$c créditos'));
                              }).toList(),
                              onChanged: (val) => setState(() => _creditos = val ?? 4),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: _ciclosDisponibles.contains(_ciclo) ? _ciclo : 'X Ciclo',
                              decoration: const InputDecoration(
                                labelText: 'Ciclo *',
                                border: OutlineInputBorder(),
                              ),
                              items: _ciclosDisponibles.map((c) {
                                return DropdownMenuItem(value: c, child: Text(c));
                              }).toList(),
                              onChanged: (val) => setState(() => _ciclo = val ?? 'X Ciclo'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _horarioCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Horario y Aula / Laboratorio *',
                          hintText: 'Ej. Lun y Mié 16:00 - 18:00 · IN304',
                          prefixIcon: Icon(Icons.schedule_outlined),
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Especifique el horario y aula de clases.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Color Identificador en Tarjeta',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 13.5, color: AppColors.ink),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: _coloresDisponibles.map((hex) {
                          final color = colorDesdeHex(hex);
                          final seleccionado = _colorHex == hex;
                          return InkWell(
                            borderRadius: BorderRadius.zero,
                            onTap: () => setState(() => _colorHex = hex),
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.zero,
                                border: Border.all(
                                  color: seleccionado ? AppColors.gold : Colors.transparent,
                                  width: 3.5,
                                ),
                                boxShadow: [
                                  if (seleccionado)
                                    BoxShadow(
                                      color: color.withValues(alpha: 0.45),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                ],
                              ),
                              child: seleccionado
                                  ? const Icon(Icons.check, color: Colors.white, size: 22)
                                  : null,
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton.icon(
                        onPressed: _isSubmitting ? null : _guardarCurso,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        icon: _isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2),
                              )
                            : const Icon(Icons.save_rounded),
                        label: Text(
                          _isSubmitting
                              ? 'Guardando...'
                              : (esEdicion ? 'Actualizar Asignatura' : 'Guardar Asignatura'),
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
