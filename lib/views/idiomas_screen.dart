import 'package:flutter/material.dart';
import '../services/preferences_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_shell.dart';
import '../widgets/common.dart';

class IdiomasScreen extends StatefulWidget {
  const IdiomasScreen({super.key});

  @override
  State<IdiomasScreen> createState() => _IdiomasScreenState();
}

class _IdiomasScreenState extends State<IdiomasScreen> {
  int _idiomaSeleccionado = 0; // 0: Inglés, 1: Quechua
  String _filtroNivelIngles = 'TODOS'; // TODOS, BASICO, INTERMEDIO

  final List<Map<String, dynamic>> _historialIngles = [
    {
      'ciclo': 'Intermedio 10',
      'nivel': 'Intermedio',
      'periodo': '2026-II',
      'docente': 'Lic. Edwin Ccama Torres',
      'horario': 'Lun-Vie 20:00-22:00 · Virtual CID-03',
      'horas': 24,
      'nota': null,
      'estado': 'Cursando',
    },
    {
      'ciclo': 'Intermedio 09',
      'nivel': 'Intermedio',
      'periodo': '2026-II',
      'docente': 'Lic. Edwin Ccama Torres',
      'horario': 'Lun-Vie 20:00-22:00 · Virtual CID-03',
      'horas': 24,
      'nota': 19,
      'estado': 'Aprobado',
    },
    {
      'ciclo': 'Intermedio 08',
      'nivel': 'Intermedio',
      'periodo': '2026-I',
      'docente': 'Lic. Patricia Valenzuela R.',
      'horario': 'Sáb-Dom 08:00-13:00 · Aula CID-104',
      'horas': 24,
      'nota': 18,
      'estado': 'Aprobado',
    },
    {
      'ciclo': 'Intermedio 07',
      'nivel': 'Intermedio',
      'periodo': '2026-I',
      'docente': 'Lic. Patricia Valenzuela R.',
      'horario': 'Sáb-Dom 08:00-13:00 · Aula CID-104',
      'horas': 24,
      'nota': 17,
      'estado': 'Aprobado',
    },
    {
      'ciclo': 'Intermedio 06',
      'nivel': 'Intermedio',
      'periodo': '2026-I',
      'docente': 'Mg. Marco Antonio Quispe P.',
      'horario': 'Lun-Vie 19:00-21:00 · Virtual CID-02',
      'horas': 24,
      'nota': 18,
      'estado': 'Aprobado',
    },
    {
      'ciclo': 'Intermedio 05',
      'nivel': 'Intermedio',
      'periodo': '2026-I',
      'docente': 'Mg. Marco Antonio Quispe P.',
      'horario': 'Lun-Vie 19:00-21:00 · Virtual CID-02',
      'horas': 24,
      'nota': 17,
      'estado': 'Aprobado',
    },
    {
      'ciclo': 'Intermedio 04',
      'nivel': 'Intermedio',
      'periodo': '2025-II',
      'docente': 'Lic. Carmen Luz Hurtado M.',
      'horario': 'Lun-Vie 19:00-21:00 · Virtual CID-01',
      'horas': 24,
      'nota': 19,
      'estado': 'Aprobado',
    },
    {
      'ciclo': 'Intermedio 03',
      'nivel': 'Intermedio',
      'periodo': '2025-II',
      'docente': 'Lic. Carmen Luz Hurtado M.',
      'horario': 'Lun-Vie 19:00-21:00 · Virtual CID-01',
      'horas': 24,
      'nota': 18,
      'estado': 'Aprobado',
    },
    {
      'ciclo': 'Intermedio 02',
      'nivel': 'Intermedio',
      'periodo': '2025-II',
      'docente': 'Dr. Walter Miranda Flórez',
      'horario': 'Lun-Vie 18:00-20:00 · Aula CID-302',
      'horas': 24,
      'nota': 18,
      'estado': 'Aprobado',
    },
    {
      'ciclo': 'Intermedio 01',
      'nivel': 'Intermedio',
      'periodo': '2025-II',
      'docente': 'Dr. Walter Miranda Flórez',
      'horario': 'Lun-Vie 18:00-20:00 · Aula CID-302',
      'horas': 24,
      'nota': 17,
      'estado': 'Aprobado',
    },
    {
      'ciclo': 'Básico 12',
      'nivel': 'Básico',
      'periodo': '2025-I',
      'docente': 'Lic. Sonia Olarte Mendoza',
      'horario': 'Sáb-Dom 08:00-13:00 · Virtual CID-04',
      'horas': 24,
      'nota': 19,
      'estado': 'Aprobado',
    },
    {
      'ciclo': 'Básico 11',
      'nivel': 'Básico',
      'periodo': '2025-I',
      'docente': 'Lic. Sonia Olarte Mendoza',
      'horario': 'Sáb-Dom 08:00-13:00 · Virtual CID-04',
      'horas': 24,
      'nota': 17,
      'estado': 'Aprobado',
    },
    {
      'ciclo': 'Básico 10',
      'nivel': 'Básico',
      'periodo': '2025-I',
      'docente': 'Mg. Javier Benavente C.',
      'horario': 'Lun-Vie 19:00-21:00 · Aula CID-201',
      'horas': 24,
      'nota': 18,
      'estado': 'Aprobado',
    },
    {
      'ciclo': 'Básico 09',
      'nivel': 'Básico',
      'periodo': '2025-I',
      'docente': 'Mg. Javier Benavente C.',
      'horario': 'Lun-Vie 19:00-21:00 · Aula CID-201',
      'horas': 24,
      'nota': 18,
      'estado': 'Aprobado',
    },
    {
      'ciclo': 'Básico 08',
      'nivel': 'Básico',
      'periodo': '2024-II',
      'docente': 'Lic. Edwin Ccama Torres',
      'horario': 'Lun-Vie 20:00-22:00 · Virtual CID-03',
      'horas': 24,
      'nota': 19,
      'estado': 'Aprobado',
    },
    {
      'ciclo': 'Básico 07',
      'nivel': 'Básico',
      'periodo': '2024-II',
      'docente': 'Lic. Edwin Ccama Torres',
      'horario': 'Lun-Vie 20:00-22:00 · Virtual CID-03',
      'horas': 24,
      'nota': 17,
      'estado': 'Aprobado',
    },
    {
      'ciclo': 'Básico 06',
      'nivel': 'Básico',
      'periodo': '2024-II',
      'docente': 'Lic. Patricia Valenzuela R.',
      'horario': 'Sáb-Dom 08:00-13:00 · Aula CID-104',
      'horas': 24,
      'nota': 18,
      'estado': 'Aprobado',
    },
    {
      'ciclo': 'Básico 05',
      'nivel': 'Básico',
      'periodo': '2024-II',
      'docente': 'Lic. Patricia Valenzuela R.',
      'horario': 'Sáb-Dom 08:00-13:00 · Aula CID-104',
      'horas': 24,
      'nota': 16,
      'estado': 'Aprobado',
    },
    {
      'ciclo': 'Básico 04',
      'nivel': 'Básico',
      'periodo': '2024-I',
      'docente': 'Mg. Marco Antonio Quispe P.',
      'horario': 'Lun-Vie 19:00-21:00 · Virtual CID-02',
      'horas': 24,
      'nota': 18,
      'estado': 'Aprobado',
    },
    {
      'ciclo': 'Básico 03',
      'nivel': 'Básico',
      'periodo': '2024-I',
      'docente': 'Mg. Marco Antonio Quispe P.',
      'horario': 'Lun-Vie 19:00-21:00 · Virtual CID-02',
      'horas': 24,
      'nota': 19,
      'estado': 'Aprobado',
    },
    {
      'ciclo': 'Básico 02',
      'nivel': 'Básico',
      'periodo': '2024-I',
      'docente': 'Lic. Carmen Luz Hurtado M.',
      'horario': 'Lun-Vie 19:00-21:00 · Virtual CID-01',
      'horas': 24,
      'nota': 17,
      'estado': 'Aprobado',
    },
    {
      'ciclo': 'Básico 01',
      'nivel': 'Básico',
      'periodo': '2024-I',
      'docente': 'Lic. Carmen Luz Hurtado M.',
      'horario': 'Lun-Vie 19:00-21:00 · Virtual CID-01',
      'horas': 24,
      'nota': 18,
      'estado': 'Aprobado',
    },
  ];

  final List<Map<String, dynamic>> _historialQuechua = [
    {
      'ciclo': 'Quechua Básico 04',
      'nivel': 'Básico (A2)',
      'periodo': '2025-II',
      'docente': 'Lic. Nélida Ccorimanya Ttito',
      'horario': 'Sáb-Dom 08:00-12:00 · Virtual CID-05',
      'horas': 24,
      'nota': 20,
      'estado': 'Aprobado',
    },
    {
      'ciclo': 'Quechua Básico 03',
      'nivel': 'Básico (A2)',
      'periodo': '2025-I',
      'docente': 'Lic. Nélida Ccorimanya Ttito',
      'horario': 'Sáb-Dom 08:00-12:00 · Virtual CID-05',
      'horas': 24,
      'nota': 18,
      'estado': 'Aprobado',
    },
    {
      'ciclo': 'Quechua Básico 02',
      'nivel': 'Básico (A1)',
      'periodo': '2024-II',
      'docente': 'Mg. Washington Rozas Quispe',
      'horario': 'Lun-Vie 18:00-20:00 · Aula CID-102',
      'horas': 24,
      'nota': 19,
      'estado': 'Aprobado',
    },
    {
      'ciclo': 'Quechua Básico 01',
      'nivel': 'Básico (A1)',
      'periodo': '2024-I',
      'docente': 'Mg. Washington Rozas Quispe',
      'horario': 'Lun-Vie 18:00-20:00 · Aula CID-102',
      'horas': 24,
      'nota': 18,
      'estado': 'Aprobado',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final prefs = PreferencesService.instance;
    final e = prefs.estudianteActivo;

    return AppShell(
      route: '/idiomas',
      title: 'Centro de Idiomas CID · UNSAAC',
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1040),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle(
                  icon: Icons.translate_rounded,
                  text: 'Acreditación de Idiomas (Requisito de Grado Académico)',
                ),
                const SizedBox(height: 16),

                // Ficha del Estudiante
                Panel(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        color: AppColors.primary,
                        alignment: Alignment.center,
                        child: const Icon(Icons.school, color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ALUMNO: ${e['nombre'] ?? 'ESTUDIANTE EPIIS'}',
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Código: ${e['codigo'] ?? '221451'} · Carrera: ${e['carrera'] ?? 'INGENIERÍA INFORMÁTICA Y DE SISTEMAS'}',
                              style: const TextStyle(fontSize: 12.5, color: AppColors.muted),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Requisito: Ley Universitaria N° 30220 (Acreditación de Lengua Extranjera o Nativa para Bachillerato)',
                              style: TextStyle(fontSize: 11.5, color: AppColors.primaryDark, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Resumen general de los 2 idiomas
                Row(
                  children: [
                    Expanded(
                      child: _tarjetaResumenIdioma(
                        idioma: 'INGLÉS',
                        nivel: 'Intermedio B2',
                        institucion: 'Centro de Idiomas CID - UNSAAC',
                        estado: 'En curso (Módulo 10 de 12)',
                        aprobado: false,
                        color: AppColors.info,
                        icono: Icons.language,
                        esSeleccionado: _idiomaSeleccionado == 0,
                        onTap: () => setState(() => _idiomaSeleccionado = 0),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _tarjetaResumenIdioma(
                        idioma: 'QUECHUA',
                        nivel: 'Básico A2',
                        institucion: 'Academia Mayor de la Lengua / CID UNSAAC',
                        estado: 'Acreditado y Validado',
                        aprobado: true,
                        color: AppColors.success,
                        icono: Icons.verified_outlined,
                        esSeleccionado: _idiomaSeleccionado == 1,
                        onTap: () => setState(() => _idiomaSeleccionado = 1),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Sección del Historial de Notas por Ciclo
                Panel(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _idiomaSeleccionado == 0 ? Icons.history_edu : Icons.auto_stories,
                                color: AppColors.primary,
                                size: 24,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                _idiomaSeleccionado == 0
                                    ? 'Historial de Notas por Ciclo · Inglés Regular'
                                    : 'Historial de Notas por Ciclo · Quechua Básico',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.ink,
                                ),
                              ),
                            ],
                          ),
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.primary, width: 1.2),
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            ),
                            icon: const Icon(Icons.picture_as_pdf_outlined, size: 17, color: AppColors.primary),
                            label: const Text('Constancia de Notas CID', style: TextStyle(color: AppColors.primary, fontSize: 12)),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Generando Ficha Oficial de Calificaciones del Centro de Idiomas...'),
                                  backgroundColor: AppColors.primary,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // KPIs de rendimiento académico en el idioma
                      _construirKpisIdioma(),
                      const SizedBox(height: 18),

                      // Filtro de niveles para Inglés
                      if (_idiomaSeleccionado == 0) ...[
                        Row(
                          children: [
                            const Text('Filtrar nivel: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5)),
                            const SizedBox(width: 8),
                            _filtroChip('TODOS', 'Todos los ciclos (22)'),
                            const SizedBox(width: 6),
                            _filtroChip('INTERMEDIO', 'Intermedio (1-10)'),
                            const SizedBox(width: 6),
                            _filtroChip('BASICO', 'Básico (1-12)'),
                          ],
                        ),
                        const SizedBox(height: 14),
                      ],

                      // Tabla de Calificaciones por Ciclo
                      _construirTablaNotas(),
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

  Widget _tarjetaResumenIdioma({
    required String idioma,
    required String nivel,
    required String institucion,
    required String estado,
    required bool aprobado,
    required Color color,
    required IconData icono,
    required bool esSeleccionado,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.zero,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: esSeleccionado ? color.withValues(alpha: 0.04) : Colors.white,
          border: Border.all(
            color: esSeleccionado ? color : AppColors.border,
            width: esSeleccionado ? 2.0 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              color: color.withValues(alpha: 0.14),
              child: Icon(icono, color: color, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '$idioma · $nivel',
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14.5),
                      ),
                      if (esSeleccionado) ...[
                        const SizedBox(width: 6),
                        Icon(Icons.check_circle, size: 16, color: color),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(institucion, style: const TextStyle(fontSize: 11.5, color: AppColors.muted)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                        color: color.withValues(alpha: 0.12),
                        child: Text(
                          aprobado ? 'APROBADO Y REGISTRADO' : 'EN CURSO',
                          style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 10),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        estado,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: aprobado ? AppColors.success : AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _construirKpisIdioma() {
    final bool esIngles = _idiomaSeleccionado == 0;
    final int totalCiclos = esIngles ? 21 : 4; // aprobados
    final int horas = esIngles ? 504 : 96;
    final String promedio = esIngles ? '17.8' : '18.8';
    final String requisito = esIngles ? 'Nivel B2 (83% completado)' : 'Nivel A2 (100% acreditado)';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: AppColors.background,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _itemKpi('Promedio Ponderado', promedio, Icons.grade_outlined, AppColors.ink),
          _divisorVertical(),
          _itemKpi('Ciclos Aprobados', '$totalCiclos módulos', Icons.task_alt_outlined, AppColors.success),
          _divisorVertical(),
          _itemKpi('Horas Académicas', '$horas hrs lectivas', Icons.schedule_outlined, AppColors.info),
          _divisorVertical(),
          _itemKpi('Requisito de Grado', requisito, Icons.workspace_premium_outlined, AppColors.primary),
        ],
      ),
    );
  }

  Widget _itemKpi(String label, String valor, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(valor, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: color)),
            Text(label, style: const TextStyle(fontSize: 10.5, color: AppColors.muted)),
          ],
        ),
      ],
    );
  }

  Widget _divisorVertical() {
    return Container(width: 1, height: 28, color: AppColors.border);
  }

  Widget _filtroChip(String clave, String texto) {
    final bool activo = _filtroNivelIngles == clave;
    return InkWell(
      onTap: () => setState(() => _filtroNivelIngles = clave),
      borderRadius: BorderRadius.zero,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: activo ? AppColors.primary : Colors.white,
          border: Border.all(color: activo ? AppColors.primary : AppColors.border),
        ),
        child: Text(
          texto,
          style: TextStyle(
            fontSize: 11,
            fontWeight: activo ? FontWeight.w800 : FontWeight.w500,
            color: activo ? Colors.white : AppColors.ink,
          ),
        ),
      ),
    );
  }

  Widget _construirTablaNotas() {
    List<Map<String, dynamic>> items;
    if (_idiomaSeleccionado == 0) {
      if (_filtroNivelIngles == 'INTERMEDIO') {
        items = _historialIngles.where((x) => x['nivel'] == 'Intermedio').toList();
      } else if (_filtroNivelIngles == 'BASICO') {
        items = _historialIngles.where((x) => x['nivel'] == 'Básico').toList();
      } else {
        items = _historialIngles;
      }
    } else {
      items = _historialQuechua;
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Encabezado de la tabla
          Container(
            color: AppColors.ink,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: const Row(
              children: [
                SizedBox(width: 130, child: Text('MÓDULO / CICLO', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11))),
                SizedBox(width: 80, child: Text('PERIODO', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11))),
                Expanded(child: Text('DOCENTE A CARGO Y HORARIO', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11))),
                SizedBox(width: 60, child: Text('HORAS', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11))),
                SizedBox(width: 80, child: Text('NOTA FINAL', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11))),
                SizedBox(width: 90, child: Text('CONDICIÓN', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11))),
              ],
            ),
          ),

          // Filas de la tabla
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => const Divider(height: 1, color: AppColors.border),
            itemBuilder: (context, idx) {
              final row = items[idx];
              final bool enCurso = row['estado'] == 'Cursando';
              final int? nota = row['nota'] as int?;
              final bool esPar = idx % 2 == 0;

              return Container(
                color: esPar ? Colors.white : const Color(0xFFFBFBFC),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(
                  children: [
                    SizedBox(
                      width: 130,
                      child: Row(
                        children: [
                          Icon(
                            enCurso ? Icons.timelapse : Icons.check_circle_outline,
                            size: 15,
                            color: enCurso ? AppColors.info : AppColors.success,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              row['ciclo'] as String,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      child: Text(
                        row['periodo'] as String,
                        style: const TextStyle(fontSize: 11.5, color: AppColors.muted),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            row['docente'] as String,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.ink),
                          ),
                          Text(
                            row['horario'] as String,
                            style: const TextStyle(fontSize: 11, color: AppColors.muted),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      child: Text(
                        '${row['horas']} hrs',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 11.5, color: AppColors.muted),
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: enCurso
                                ? AppColors.info.withValues(alpha: 0.12)
                                : ((nota ?? 0) >= 14 ? AppColors.success.withValues(alpha: 0.12) : AppColors.danger.withValues(alpha: 0.12)),
                            border: Border.all(
                              color: enCurso
                                  ? AppColors.info
                                  : ((nota ?? 0) >= 14 ? AppColors.success : AppColors.danger),
                              width: 0.8,
                            ),
                          ),
                          child: Text(
                            enCurso ? '--' : '$nota / 20',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 11.5,
                              color: enCurso
                                  ? AppColors.info
                                  : ((nota ?? 0) >= 14 ? AppColors.success : AppColors.danger),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 90,
                      child: Center(
                        child: Text(
                          (row['estado'] as String).toUpperCase(),
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w900,
                            color: enCurso ? AppColors.info : AppColors.success,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
