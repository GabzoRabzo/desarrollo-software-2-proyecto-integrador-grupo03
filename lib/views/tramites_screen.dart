import 'package:flutter/material.dart';
import '../services/preferences_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_shell.dart';
import '../widgets/common.dart';

class TramitesScreen extends StatelessWidget {
  const TramitesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = PreferencesService.instance;
    final e = prefs.estudianteActivo;

    return AppShell(
      route: '/tramites',
      title: 'Trámite Documentario Digital · UNSAAC',
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 960),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle(
                  icon: Icons.description_outlined,
                  text: 'Sistema de Gestión Documentaria (SGD UNSAAC)',
                ),
                const SizedBox(height: 16),
                Panel(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        color: AppColors.primary,
                        alignment: Alignment.center,
                        child: const Icon(Icons.folder_shared_outlined, color: Colors.white, size: 26),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'EXPEDIENTES ACTIVOS: ${e['nombre']}',
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                            ),
                            const Text(
                              'Seguimiento digital de solicitudes y certificaciones académicas',
                              style: TextStyle(fontSize: 12, color: AppColors.muted),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Mesa de partes virtual SGD activa')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                        ),
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Nuevo Trámite'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                _tramiteTile(
                  expediente: 'EXP-2026-0842',
                  asunto: 'Constancia de Matrícula Semestre 2026-II',
                  fecha: '20 oct 2026',
                  area: 'Dirección de Registro y Servicios Académicos (DIRSA)',
                  estado: 'Atendido (Descargar PDF)',
                  color: AppColors.success,
                ),
                const SizedBox(height: 12),
                _tramiteTile(
                  expediente: 'EXP-2026-0915',
                  asunto: 'Carta de Presentación para Prácticas Pre-profesionales',
                  fecha: '22 oct 2026',
                  area: 'Decanatura de Ingeniería de Procesos / EPIIS',
                  estado: 'En evaluación',
                  color: const Color(0xFFF39C12),
                ),
                const SizedBox(height: 12),
                _tramiteTile(
                  expediente: 'EXP-2026-0970',
                  asunto: 'Actualización de Datos en Ficha de Matrícula',
                  fecha: '24 oct 2026',
                  area: 'Centro de Cómputo e Informática (CCI)',
                  estado: 'Recibido',
                  color: AppColors.info,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _tramiteTile({
    required String expediente,
    required String asunto,
    required String fecha,
    required String area,
    required String estado,
    required Color color,
  }) {
    return Panel(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 48,
            color: color,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      expediente,
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: AppColors.primary),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      fecha,
                      style: const TextStyle(fontSize: 11.5, color: AppColors.muted),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  asunto,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(area, style: const TextStyle(fontSize: 11.5, color: AppColors.muted)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            color: color.withValues(alpha: 0.12),
            child: Text(
              estado,
              style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}
