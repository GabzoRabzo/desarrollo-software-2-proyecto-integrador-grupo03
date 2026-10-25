import 'package:flutter/material.dart';
import '../models/curso.dart';
import '../models/tarea.dart';
import '../services/database_service.dart';
import '../theme/app_theme.dart';

class TareaFormScreen extends StatefulWidget {
  final List<Curso> cursosDisponibles;
  final int? cursoPreseleccionadoId;

  const TareaFormScreen({
    super.key,
    this.cursosDisponibles = const [],
    this.cursoPreseleccionadoId,
  });

  @override
  State<TareaFormScreen> createState() => _TareaFormScreenState();
}

class _TareaFormScreenState extends State<TareaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _tituloCtrl;
  late final TextEditingController _descripcionCtrl;
  int? _cursoIdSeleccionado;
  DateTime _fechaEntrega = DateTime.now().add(const Duration(days: 3));
  String _prioridad = 'Alta';
  final int _horasEstimadas = 3;
  bool _isSubmitting = false;

  late List<Curso> _cursosLocales;

  @override
  void initState() {
    super.initState();
    _tituloCtrl = TextEditingController();
    _descripcionCtrl = TextEditingController();
    _cursosLocales = List.from(widget.cursosDisponibles);
    if (_cursosLocales.isEmpty) {
      DatabaseService.instance.getCursos().then((cList) {
        if (mounted) {
          setState(() {
            _cursosLocales = cList;
            if (_cursosLocales.isNotEmpty && _cursoIdSeleccionado == null) {
              _cursoIdSeleccionado = _cursosLocales.first.id;
            }
          });
        }
      });
    } else {
      if (widget.cursoPreseleccionadoId != null) {
        _cursoIdSeleccionado = widget.cursoPreseleccionadoId;
      } else if (_cursosLocales.isNotEmpty) {
        _cursoIdSeleccionado = _cursosLocales.first.id;
      }
    }
  }

  @override
  void dispose() {
    _tituloCtrl.dispose();
    _descripcionCtrl.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFecha() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fechaEntrega,
      firstDate: DateTime.now().subtract(const Duration(days: 7)),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.ink,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _fechaEntrega = picked);
    }
  }



  Future<void> _guardarTarea() async {
    if (!_formKey.currentState!.validate()) return;
    if (_cursoIdSeleccionado == null) return;

    setState(() => _isSubmitting = true);

    try {
      final tarea = Tarea(
        cursoId: _cursoIdSeleccionado!,
        titulo: _tituloCtrl.text.trim(),
        descripcion: _descripcionCtrl.text.trim(),
        fechaEntrega: _fechaEntrega,
        prioridad: _prioridad,
        completada: false,
        horasEstimadas: _horasEstimadas,
      );

      await DatabaseService.instance.insertTarea(tarea);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✓ Tarea académica registrada con éxito'),
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
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Registrar Nueva Tarea'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
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
                            child: const Icon(Icons.add_task_rounded,
                                color: AppColors.primary, size: 24),
                          ),
                          const SizedBox(width: 14),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nuevo Entregable Académico',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                              Text(
                                'Planifica tus entregas y fechas de evaluación académica',
                                style: TextStyle(fontSize: 12, color: AppColors.muted),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      DropdownButtonFormField<int>(
                        initialValue: (_cursoIdSeleccionado != null &&
                                _cursosLocales.any((c) => c.id == _cursoIdSeleccionado))
                            ? _cursoIdSeleccionado
                            : (_cursosLocales.isNotEmpty ? _cursosLocales.first.id : null),
                        decoration: const InputDecoration(
                          labelText: 'Asignatura Vinculada *',
                          prefixIcon: Icon(Icons.school_outlined),
                          border: OutlineInputBorder(),
                        ),
                        items: _cursosLocales.map((c) {
                          return DropdownMenuItem(
                            value: c.id,
                            child: Text(c.nombre, overflow: TextOverflow.ellipsis),
                          );
                        }).toList(),
                        onChanged: (val) => setState(() => _cursoIdSeleccionado = val),
                        validator: (val) =>
                            val == null ? 'Seleccione una asignatura' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _tituloCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Título de la Tarea / Entregable *',
                          hintText: 'Ej. Informe de Laboratorio Sesión 07',
                          prefixIcon: Icon(Icons.task_alt_outlined),
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'El título es obligatorio.';
                          }
                          if (val.trim().length < 5) {
                            return 'Especifique un título descriptivo (mín. 5 caracteres).';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descripcionCtrl,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Descripción y Criterios de Evaluación *',
                          hintText: 'Detalle de consignas, rúbrica, enlaces de repositorio...',
                          prefixIcon: Icon(Icons.description_outlined),
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Agregue una breve descripción de la tarea.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              borderRadius: BorderRadius.zero,
                              onTap: _seleccionarFecha,
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'Fecha de Entrega *',
                                  prefixIcon: Icon(Icons.calendar_today_outlined),
                                  border: OutlineInputBorder(),
                                ),
                                child: Text(
                                  fechaCorta(_fechaEntrega),
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: ['Alta', 'Media', 'Baja'].contains(_prioridad) ? _prioridad : 'Media',
                              decoration: const InputDecoration(
                                labelText: 'Nivel Prioridad *',
                                border: OutlineInputBorder(),
                              ),
                              items: ['Alta', 'Media', 'Baja'].map((p) {
                                return DropdownMenuItem(value: p, child: Text(p));
                              }).toList(),
                              onChanged: (val) =>
                                  setState(() => _prioridad = val ?? 'Media'),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),
                      ElevatedButton.icon(
                        onPressed: _isSubmitting ? null : _guardarTarea,
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
                            : const Icon(Icons.assignment_turned_in_rounded),
                        label: Text(
                          _isSubmitting ? 'Guardando Tarea...' : 'Guardar Tarea Académica',
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
