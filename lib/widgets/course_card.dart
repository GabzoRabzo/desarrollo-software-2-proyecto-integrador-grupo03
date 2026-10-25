import 'package:flutter/material.dart';
import '../models/curso.dart';
import '../theme/app_theme.dart';
import 'common.dart';

/// Tarjeta de curso con portada, avance y acciones (estilo plataforma virtual).
class CourseCard extends StatelessWidget {
  final Curso curso;
  final double progreso; // 0..1
  final int pendientes;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CourseCard({
    super.key,
    required this.curso,
    required this.progreso,
    required this.pendientes,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final color = colorDesdeHex(curso.colorHex);
    final pct = (progreso * 100).round();

    return Panel(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 94,
              width: double.infinity,
              color: color,
              child: Stack(
                children: [
                  Positioned(
                    right: 12,
                    bottom: -8,
                    child: Icon(
                      _iconoParaCurso(curso.nombre),
                      size: 76,
                      color: Colors.white.withValues(alpha: 0.16),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.zero,
                        border: Border.all(color: AppColors.ink.withValues(alpha: 0.15)),
                      ),
                      child: Text(
                        '$pct%',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                          color: color,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 12,
                    bottom: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.zero,
                      ),
                      child: Text(
                        '${curso.creditos} créditos · ${curso.ciclo}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 6, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    curso.nombre.toUpperCase(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: color,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.person_outline, size: 14, color: AppColors.muted),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(curso.docente,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(Icons.schedule, size: 14, color: AppColors.muted),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(curso.horario,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.zero,
                          child: LinearProgressIndicator(
                            value: progreso,
                            minHeight: 7,
                            backgroundColor: AppColors.border,
                            valueColor: AlwaysStoppedAnimation<Color>(color),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        pendientes == 0 ? 'Al día' : '$pendientes pend.',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: pendientes == 0 ? AppColors.success : AppColors.primary,
                        ),
                      ),
                      if (onEdit != null || onDelete != null)
                        PopupMenuButton<String>(
                          tooltip: 'Opciones del curso',
                          icon: const Icon(Icons.more_vert, size: 20, color: AppColors.muted),
                          onSelected: (v) {
                            if (v == 'editar') onEdit?.call();
                            if (v == 'eliminar') onDelete?.call();
                          },
                          itemBuilder: (_) => [
                            if (onEdit != null)
                              const PopupMenuItem(value: 'editar', child: Text('Editar curso')),
                            if (onDelete != null)
                              const PopupMenuItem(
                                  value: 'eliminar', child: Text('Eliminar curso')),
                          ],
                        )
                      else
                        const SizedBox(width: 8),
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

  IconData _iconoParaCurso(String nombre) {
    final n = nombre.toUpperCase();
    if (n.contains('SOFTWARE') || n.contains('DESARROLLO')) return Icons.code_rounded;
    if (n.contains('SEMINARIO') || n.contains('INVESTIGACIÓN') || n.contains('INVESTIGACION')) {
      return Icons.menu_book_rounded;
    }
    if (n.contains('PROYECTO') || n.contains('PROYECTOS')) return Icons.assignment_outlined;
    if (n.contains('APRENDIZAJE') || n.contains('INTELIGENCIA') || n.contains('DATOS')) {
      return Icons.psychology_outlined;
    }
    if (n.contains('SEGURIDAD') || n.contains('AUDITORÍA') || n.contains('AUDITORIA')) {
      return Icons.security_outlined;
    }
    if (n.contains('DISTRIBUIDOS') || n.contains('CLOUD')) return Icons.cloud_queue_rounded;
    if (n.contains('PLANEAMIENTO') || n.contains('ESTRATÉGICA') || n.contains('ESTRATEGICA')) {
      return Icons.trending_up_rounded;
    }
    return Icons.school_outlined;
  }
}

/// Distribuye tarjetas en columnas según el ancho disponible.
class CourseGrid extends StatelessWidget {
  final List<Widget> children;
  final double minCardWidth;
  const CourseGrid({super.key, required this.children, this.minCardWidth = 250});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      const gap = 16.0;
      final cols = (c.maxWidth / (minCardWidth + gap)).floor().clamp(1, 4);
      final w = (c.maxWidth - gap * (cols - 1)) / cols;
      return Wrap(
        spacing: gap,
        runSpacing: gap,
        children: [for (final ch in children) SizedBox(width: w, child: ch)],
      );
    });
  }
}
