import 'package:flutter/material.dart';

/// Identidad visual UNSAAC: granate del escudo, dorado heráldico y crema.
class AppColors {
  static const Color primary = Color(0xFF7A1B28); // Granate UNSAAC
  static const Color primaryDark = Color(0xFF4F0F19);
  static const Color primaryLight = Color(0xFFA32A3A);
  static const Color gold = Color(0xFFC9A227); // Dorado heráldico
  static const Color goldSoft = Color(0xFFF7EDCB);
  static const Color background = Color(0xFFF6F3EE);
  static const Color bg = background;
  static const Color surface = Colors.white;
  static const Color cardBg = surface;
  static const Color ink = Color(0xFF2B2623);
  static const Color muted = Color(0xFF7A736D);
  static const Color border = Color(0xFFE7E1D8);
  static const Color success = Color(0xFF2E7D32);
  static const Color info = Color(0xFF2B5C8A);
  static const Color danger = Color(0xFFB3261E);
  static const Color accentRed = Color(0xFFC5192D);
  static const Color odsRed = accentRed; // compatibilidad interna

  static const LinearGradient sidebarGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF8A2030), Color(0xFF5C1220), Color(0xFF3E0B15)],
  );

  static const LinearGradient profileGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF8A2030), Color(0xFF4F0F19)],
  );
}

const List<String> kMeses = [
  'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
  'Julio', 'Agosto', 'Setiembre', 'Octubre', 'Noviembre', 'Diciembre',
];
const List<String> kMesesCortos = [
  'ene', 'feb', 'mar', 'abr', 'may', 'jun', 'jul', 'ago', 'set', 'oct', 'nov', 'dic',
];
const List<String> kDiasCortos = ['LUN', 'MAR', 'MIÉ', 'JUE', 'VIE', 'SÁB', 'DOM'];

/// Imagen de portada asignada a cada curso (rotativa por identificador).
String bannerParaCurso(String nombre) {
  final n = nombre.toLowerCase();
  if (n.contains('ingenier')) return 'assets/images/banner_ingenieria.jpg';
  if (n.contains('miner') || n.contains('datos')) return 'assets/images/banner_mineria.jpg';
  if (n.contains('software')) return 'assets/images/banner_software.jpg';
  const todos = [
    'assets/images/banner_software.jpg',
    'assets/images/banner_ingenieria.jpg',
    'assets/images/banner_mineria.jpg',
  ];
  return todos[nombre.length % todos.length];
}

Color colorDesdeHex(String hex) {
  final limpio = hex.replaceAll('#', '');
  return Color(int.parse('0xFF$limpio'));
}

String fechaCorta(DateTime d) => '${d.day} ${kMesesCortos[d.month - 1]}';

String venceEn(DateTime fecha) {
  final hoy = DateTime.now();
  final a = DateTime(hoy.year, hoy.month, hoy.day);
  final b = DateTime(fecha.year, fecha.month, fecha.day);
  final dias = b.difference(a).inDays;
  if (dias < 0) return 'Venció hace ${-dias} d';
  if (dias == 0) return 'Vence hoy';
  if (dias == 1) return 'Vence mañana';
  return 'Vence en $dias d';
}

ThemeData buildAppTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    primary: AppColors.primary,
    secondary: AppColors.gold,
    surface: AppColors.surface,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.background,
    cardTheme: const CardThemeData(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.zero),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: AppColors.border, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        elevation: 0,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary, width: 1.2),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      elevation: 2,
    ),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.fixed,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    ),
  );
}
