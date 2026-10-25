import 'package:flutter/material.dart';
import 'models/curso.dart';
import 'services/preferences_service.dart';
import 'theme/app_theme.dart';
import 'views/calendario_screen.dart';
import 'views/configuracion_screen.dart';
import 'views/curso_form_screen.dart';
import 'views/cursos_screen.dart';
import 'views/dashboard_screen.dart';
import 'views/idiomas_screen.dart';
import 'views/login_screen.dart';
import 'views/matricula_screen.dart';
import 'views/tarea_form_screen.dart';
import 'views/tareas_screen.dart';
import 'views/tramites_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferencesService.instance.cargar();
  runApp(const PanelAcademicoApp());
}

/// Rutas nombradas del portal académico UNSAAC.
class Rutas {
  static const login = '/login';
  static const inicio = '/';
  static const cursos = '/cursos';
  static const cursoNuevo = '/cursos/nuevo';
  static const matricula = '/matricula';
  static const tareas = '/tareas';
  static const tareaNueva = '/tareas/nueva';
  static const calendario = '/calendario';
  static const idiomas = '/idiomas';
  static const tramites = '/tramites';
  static const configuracion = '/configuracion';
}

class PanelAcademicoApp extends StatelessWidget {
  final String rutaInicial;
  const PanelAcademicoApp({super.key, this.rutaInicial = Rutas.login});

  Widget _pantalla(RouteSettings s) {
    switch (s.name) {
      case Rutas.login:
        return const LoginScreen();
      case Rutas.cursos:
        return const CursosScreen();
      case Rutas.cursoNuevo:
        return CursoFormScreen(cursoParaEditar: s.arguments as Curso?);
      case Rutas.matricula:
        return const MatriculaScreen();
      case Rutas.tareas:
        return const TareasScreen();
      case Rutas.tareaNueva:
        return const TareaFormScreen();
      case Rutas.calendario:
        return const CalendarioScreen();
      case Rutas.idiomas:
        return const IdiomasScreen();
      case Rutas.tramites:
        return const TramitesScreen();
      case Rutas.configuracion:
        return const ConfiguracionScreen();
      case Rutas.inicio:
        return const DashboardScreen();
      default:
        return const DashboardScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Panel Académico · UNSAAC',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      initialRoute: rutaInicial,
      onGenerateRoute: (settings) {
        final pantalla = _pantalla(settings);
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, _, _) => pantalla,
          transitionDuration: const Duration(milliseconds: 180),
          reverseTransitionDuration: const Duration(milliseconds: 180),
          transitionsBuilder: (_, animation, _, child) =>
              FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }
}
