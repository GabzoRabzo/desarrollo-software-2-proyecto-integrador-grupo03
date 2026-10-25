import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../services/preferences_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_shell.dart';
import '../widgets/common.dart';

class ConfiguracionScreen extends StatefulWidget {
  const ConfiguracionScreen({super.key});

  @override
  State<ConfiguracionScreen> createState() => _ConfiguracionScreenState();
}

class _ConfiguracionScreenState extends State<ConfiguracionScreen> {
  final PreferencesService _prefs = PreferencesService.instance;
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _codigoCtrl;
  late TextEditingController _nombreCtrl;
  late TextEditingController _carreraCtrl;
  late TextEditingController _direccionCtrl;
  late TextEditingController _telefonoCtrl;
  late TextEditingController _emailCtrl;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  void _cargarDatos() {
    final e = _prefs.estudianteActivo;
    final esJairo = e['codigo'] == '221451';

    _codigoCtrl = TextEditingController(text: e['codigo'] ?? '221451');
    _nombreCtrl = TextEditingController(
      text: esJairo
          ? 'RODRÍGUEZ-CCOYTO-JAIRO JASER'
          : 'QUISPE-CHECYA-JOAN GONZALO',
    );
    _carreraCtrl = TextEditingController(
        text: 'INGENIERÍA INFORMÁTICA Y DE SISTEMAS');
    _direccionCtrl = TextEditingController(
        text: esJairo ? '3 DE MAYO 202' : 'AV. TÚPAC AMARU S/N');
    _telefonoCtrl = TextEditingController(
        text: esJairo ? '949050422' : '984123456');
    _emailCtrl = TextEditingController(
      text: esJairo
          ? 'JAIROJASERODRIGUEZ@GMAIL.COM'
          : 'JOAN.QUISPE@UNSAAC.EDU.PE',
    );
  }

  @override
  void dispose() {
    _codigoCtrl.dispose();
    _nombreCtrl.dispose();
    _carreraCtrl.dispose();
    _direccionCtrl.dispose();
    _telefonoCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardarCambios() async {
    if (!_formKey.currentState!.validate()) return;

    await _prefs.actualizarEstudianteActivo(
      direccion: _direccionCtrl.text.trim(),
      telefono: _telefonoCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✓ Datos personales actualizados correctamente en el sistema'),
        backgroundColor: AppColors.primary,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _cancelar() {
    setState(() {
      _cargarDatos();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edición cancelada, valores restaurados'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      route: '/configuracion',
      title: 'Configuración · Datos Personales',
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 26),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 980),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 8),
                const Text(
                  'ACTUALIZACIÓN DE DATOS PERSONALES',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Si usted desea modificar los datos mostrados en esta ficha, por favor complete los campos a continuación.',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: AppColors.muted,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Panel(
                  padding: const EdgeInsets.all(26),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Fila 1: Alumno, Nombre, Carrera
                        LayoutBuilder(builder: (context, c) {
                          final wide = c.maxWidth > 700;
                          final colAlumno = TextFormField(
                            controller: _codigoCtrl,
                            readOnly: true,
                            decoration: const InputDecoration(
                              labelText: 'Alumno',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Color(0xFFF1F3F5),
                            ),
                          );
                          final colNombre = TextFormField(
                            controller: _nombreCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Nombre',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Color(0xFFF1F3F5),
                            ),
                            validator: (v) =>
                                (v == null || v.isEmpty) ? 'Requerido' : null,
                          );
                          final colCarrera = TextFormField(
                            controller: _carreraCtrl,
                            readOnly: true,
                            decoration: const InputDecoration(
                              labelText: 'Carrera',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Color(0xFFF1F3F5),
                            ),
                          );

                          if (wide) {
                            return Row(
                              children: [
                                SizedBox(width: 140, child: colAlumno),
                                const SizedBox(width: 14),
                                Expanded(flex: 5, child: colNombre),
                                const SizedBox(width: 14),
                                Expanded(flex: 5, child: colCarrera),
                              ],
                            );
                          } else {
                            return Column(
                              children: [
                                colAlumno,
                                const SizedBox(height: 12),
                                colNombre,
                                const SizedBox(height: 12),
                                colCarrera,
                              ],
                            );
                          }
                        }),
                        const SizedBox(height: 16),
                        // Fila 2: Dirección, Teléfono, Email
                        LayoutBuilder(builder: (context, c) {
                          final wide = c.maxWidth > 700;
                          final colDir = TextFormField(
                            controller: _direccionCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Dirección',
                              border: OutlineInputBorder(),
                            ),
                          );
                          final colTel = TextFormField(
                            controller: _telefonoCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Teléfono',
                              border: OutlineInputBorder(),
                            ),
                          );
                          final colEmail = TextFormField(
                            controller: _emailCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                          );

                          if (wide) {
                            return Row(
                              children: [
                                Expanded(flex: 4, child: colDir),
                                const SizedBox(width: 14),
                                SizedBox(width: 170, child: colTel),
                                const SizedBox(width: 14),
                                Expanded(flex: 5, child: colEmail),
                              ],
                            );
                          } else {
                            return Column(
                              children: [
                                colDir,
                                const SizedBox(height: 12),
                                colTel,
                                const SizedBox(height: 12),
                                colEmail,
                              ],
                            );
                          }
                        }),
                        const SizedBox(height: 28),
                        // Botones de acción centrados: Actualizar / Cancelar
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: _guardarCambios,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF39C12), // Naranja/Dorado
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 28, vertical: 14),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
                              child: const Text(
                                'Actualizar',
                                style: TextStyle(
                                    fontWeight: FontWeight.w800, fontSize: 14),
                              ),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: _cancelar,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 28, vertical: 14),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
                              child: const Text(
                                'Cancelar',
                                style: TextStyle(
                                    fontWeight: FontWeight.w800, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Tarjeta de Gestión de Datos JSON
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.zero,
                    border: Border.all(color: AppColors.border, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.data_object, color: AppColors.primary, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'ORIGEN Y PERSISTENCIA DE DATOS (JSON)',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Los datos se cargan desde assets/data/datos_academico.json y se sincronizan en almacenamiento local persistente. Puede inspeccionar el JSON actual o restaurar los valores iniciales:',
                        style: TextStyle(fontSize: 12, color: AppColors.muted, height: 1.35),
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        children: [
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.primary),
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                            icon: const Icon(Icons.code, size: 18, color: AppColors.primary),
                            label: const Text('Ver / Exportar JSON actual', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
                            onPressed: () async {
                              final jsonStr = await DatabaseService.instance.exportarJson();
                              if (!context.mounted) return;
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                                  title: const Text('JSON de Cursos y Tareas', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                                  content: SizedBox(
                                    width: 600,
                                    height: 400,
                                    child: SingleChildScrollView(
                                      child: SelectableText(
                                        jsonStr,
                                        style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
                                      ),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx),
                                      child: const Text('Cerrar'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.muted),
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                            icon: const Icon(Icons.refresh, size: 18, color: AppColors.muted),
                            label: const Text('Restablecer a JSON inicial', style: TextStyle(color: AppColors.ink)),
                            onPressed: () async {
                              await DatabaseService.instance.reiniciarDesdeJson();
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('✓ Base de datos restablecida desde datos_academico.json'),
                                  backgroundColor: AppColors.primary,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
