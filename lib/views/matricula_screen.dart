import 'package:flutter/material.dart';
import '../services/panel_data.dart';
import '../services/preferences_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_shell.dart';
import '../widgets/common.dart';

class MatriculaScreen extends StatelessWidget {
  const MatriculaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = PreferencesService.instance;
    final e = prefs.estudianteActivo;

    return AppShell(
      route: '/matricula',
      title: 'Ficha de Matrícula · Semestre 2026-II',
      child: FutureBuilder<PanelData>(
        future: PanelData.cargar(),
        builder: (context, snapshot) {
          final cursos = snapshot.data?.cursos ?? [];
          final totalCreditos = cursos.fold<int>(0, (sum, c) => sum + c.creditos);

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 960),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionTitle(
                      icon: Icons.badge_outlined,
                      text: 'Ficha Oficial de Matrícula',
                    ),
                    const SizedBox(height: 16),
                    Panel(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
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
                                  'ESTUDIANTE: ${e['nombre']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14.5,
                                    color: AppColors.primaryDark,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'CÓDIGO: ${e['codigo']}  ·  PLAN: 2017  ·  SEMESTRE: 2026-II  ·  CONDICIÓN: REGULAR',
                                  style: const TextStyle(fontSize: 12, color: AppColors.muted),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            color: AppColors.success.withValues(alpha: 0.15),
                            child: const Text(
                              'MATRICULADO',
                              style: TextStyle(
                                color: AppColors.success,
                                fontWeight: FontWeight.w900,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'ASIGNATURAS INSCRITAS',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        color: AppColors.ink,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Panel(
                      padding: EdgeInsets.zero,
                      child: Table(
                        border: TableBorder.symmetric(
                          inside: BorderSide(color: AppColors.border, width: 1),
                        ),
                        columnWidths: const {
                          0: FlexColumnWidth(4),
                          1: FlexColumnWidth(3),
                          2: FlexColumnWidth(1.5),
                          3: FlexColumnWidth(1.5),
                        },
                        children: [
                          TableRow(
                            decoration: const BoxDecoration(color: Color(0xFFF1F3F5)),
                            children: const [
                              Padding(
                                padding: EdgeInsets.all(12),
                                child: Text('ASIGNATURA',
                                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(12),
                                child: Text('DOCENTE',
                                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(12),
                                child: Text('CRÉDITOS',
                                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(12),
                                child: Text('ESTADO',
                                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
                              ),
                            ],
                          ),
                          for (final c in cursos)
                            TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(c.nombre,
                                      style: const TextStyle(fontWeight: FontWeight.w700)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(c.docente, style: const TextStyle(fontSize: 12)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text('${c.creditos} créd.',
                                      style: const TextStyle(fontWeight: FontWeight.w800)),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Text('Inscrito',
                                      style: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Total de Créditos Matriculados: $totalCreditos créditos',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
