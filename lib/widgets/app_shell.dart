import 'package:flutter/material.dart';
import '../services/preferences_service.dart';
import '../theme/app_theme.dart';

class NavItem {
  final String label;
  final IconData icon;
  final String route;
  const NavItem(this.label, this.icon, this.route);
}

const List<NavItem> kNavItems = [
  NavItem('Dashboard', Icons.dashboard_outlined, '/'),
  NavItem('Mis cursos', Icons.menu_book_outlined, '/cursos'),
  NavItem('Matricula', Icons.badge_outlined, '/matricula'),
  NavItem('Tareas', Icons.checklist_rounded, '/tareas'),
  NavItem('Calendario', Icons.calendar_month_outlined, '/calendario'),
  NavItem('Idiomas', Icons.translate_rounded, '/idiomas'),
  NavItem('Tramites', Icons.description_outlined, '/tramites'),
  NavItem('Configuracion', Icons.settings_outlined, '/configuracion'),
];

const double kBreakpointWide = 1000;

/// Marco común de todas las pantallas principales:
/// - Escritorio: cabecera limpia sin rectángulos ni solapes + barra lateral de 8 módulos + pie simple UNSAAC.
/// - Móvil: AppBar + Drawer + barra inferior.
class AppShell extends StatelessWidget {
  final String route;
  final String title;
  final Widget child;
  final Widget? floatingActionButton;

  const AppShell({
    super.key,
    required this.route,
    required this.title,
    required this.child,
    this.floatingActionButton,
  });

  static void navegar(BuildContext context, String destino, String actual) {
    if (destino == actual) return;
    Navigator.of(context).pushReplacementNamed(destino);
  }

  @override
  Widget build(BuildContext context) {
    final ancho = MediaQuery.of(context).size.width;
    final wide = ancho >= kBreakpointWide;

    if (wide) {
      return Scaffold(
        floatingActionButton: floatingActionButton == null
            ? null
            : Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: floatingActionButton,
              ),
        body: Column(
          children: [
            const _InstitutionalHeader(),
            Expanded(
              child: Row(
                children: [
                  SizedBox(width: 254, child: _Sidebar(route: route)),
                  Expanded(child: child),
                ],
              ),
            ),
            const _Footer(),
          ],
        ),
      );
    }

    final scaffoldKey = GlobalKey<ScaffoldState>();
    final indiceInferior = switch (route) {
      '/' => 0,
      '/cursos' => 1,
      '/matricula' => 2,
      '/tareas' => 3,
      _ => 4,
    };

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        titleSpacing: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Image.asset('assets/images/logounsaac_hd.png'),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('UNSAAC · Panel Académico',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
            Text(title,
                style: const TextStyle(fontSize: 11.5, color: Color(0xFFF2D98B))),
          ],
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.transparent,
        child: _Sidebar(route: route, enDrawer: true),
      ),
      floatingActionButton: floatingActionButton,
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: indiceInferior,
        backgroundColor: Colors.white,
        indicatorColor: AppColors.goldSoft,
        height: 66,
        onDestinationSelected: (i) {
          const rutas = ['/', '/cursos', '/matricula', '/tareas'];
          if (i == 4) {
            scaffoldKey.currentState?.openDrawer();
          } else {
            navegar(context, rutas[i], route);
          }
        },
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard, color: AppColors.primary),
              label: 'Inicio'),
          NavigationDestination(
              icon: Icon(Icons.menu_book_outlined),
              selectedIcon: Icon(Icons.menu_book, color: AppColors.primary),
              label: 'Cursos'),
          NavigationDestination(
              icon: Icon(Icons.badge_outlined),
              selectedIcon: Icon(Icons.badge, color: AppColors.primary),
              label: 'Matrícula'),
          NavigationDestination(
              icon: Icon(Icons.checklist_rounded),
              selectedIcon: Icon(Icons.checklist_rounded, color: AppColors.primary),
              label: 'Tareas'),
          NavigationDestination(
              icon: Icon(Icons.menu_rounded),
              selectedIcon: Icon(Icons.menu_rounded, color: AppColors.primary),
              label: 'Más'),
        ],
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  final String route;
  final bool enDrawer;
  const _Sidebar({required this.route, this.enDrawer = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.sidebarGradient),
      child: Stack(
        children: [
          // Imagen vertical del campus UNSAAC como textura en el sidebar
          Positioned.fill(
            child: Opacity(
              opacity: 0.14,
              child: Image.asset(
                'assets/images/sibedar.png',
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (enDrawer)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 6),
                    child: Row(
                      children: [
                        Image.asset('assets/images/logounsaac_hd.png', width: 38),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            'Panel Académico\nUNSAAC',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                height: 1.2),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      for (final item in kNavItems)
                        _SidebarTile(
                          item: item,
                          activo: item.route == route,
                          onTap: () {
                            if (enDrawer) Navigator.of(context).pop();
                            AppShell.navegar(context, item.route, route);
                          },
                        ),
                    ],
                  ),
                ),
                // Perfil del estudiante en el sidebar
                const _SidebarProfileTile(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarProfileTile extends StatefulWidget {
  const _SidebarProfileTile();

  @override
  State<_SidebarProfileTile> createState() => _SidebarProfileTileState();
}

class _SidebarProfileTileState extends State<_SidebarProfileTile> {
  @override
  Widget build(BuildContext context) {
    final prefs = PreferencesService.instance;
    final e = prefs.estudianteActivo;
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 12),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.35),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.7), width: 1.2),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primaryDark,
              border: Border.all(color: AppColors.gold, width: 1.5),
            ),
            child: Text(
              e['iniciales'] ?? 'JR',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  e['nombre'] ?? 'Estudiante UNSAAC',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 11.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Código ${e['codigo'] ?? '221451'} · EPIIS',
                  style: const TextStyle(color: Colors.white70, fontSize: 10),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: const BoxDecoration(
                    color: Color(0x33FFFFFF),
                  ),
                  child: Text(
                    'Semestre 2026-II',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Cerrar sesión',
            iconSize: 20,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            icon: const Icon(Icons.logout_rounded, color: Colors.white70),
            onPressed: () async {
              await prefs.cerrarSesion();
              if (!context.mounted) return;
              Navigator.pushNamedAndRemoveUntil(context, '/login', (r) => false);
            },
          ),
        ],
      ),
    );
  }
}

class _SidebarTile extends StatelessWidget {
  final NavItem item;
  final bool activo;
  final VoidCallback onTap;
  const _SidebarTile({required this.item, required this.activo, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.zero,
          onTap: onTap,
          hoverColor: Colors.white.withValues(alpha: 0.08),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              gradient: activo
                  ? const LinearGradient(
                      colors: [Color(0xFFD6B13A), Color(0xFFA9831C)])
                  : null,
              borderRadius: BorderRadius.zero,
              border: activo
                  ? const Border(left: BorderSide(color: Colors.white, width: 4))
                  : null,
            ),
            child: Row(
              children: [
                Icon(item.icon,
                    size: 20, color: activo ? AppColors.primaryDark : Colors.white70),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: activo ? FontWeight.w800 : FontWeight.w500,
                      color: activo ? AppColors.primaryDark : Colors.white,
                    ),
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

class _InstitutionalHeader extends StatelessWidget {
  const _InstitutionalHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          bottom: BorderSide(color: AppColors.border, width: 1.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Row(
          children: [
            // Imagotipo EPIIS limpio y directo sin rectángulo contenedor ni solapes
            Image.asset(
              'assets/images/imagotipo_fondo_claro.png',
              height: 54,
              fit: BoxFit.contain,
            ),
            const Spacer(),
            // Insignia UNSAAC HD + Título limpio oficial
            Image.asset('assets/images/logounsaac_hd.png', height: 72),
            const SizedBox(width: 16),
            const Text(
              'UNIVERSIDAD NACIONAL DE\nSAN ANTONIO ABAD DEL CUSCO',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
                height: 1.15,
                letterSpacing: 0.4,
              ),
            ),
            const Spacer(),
            IconButton(
              tooltip: 'Cerrar sesión',
              icon: const Icon(Icons.logout_rounded, color: AppColors.primary),
              onPressed: () async {
                await PreferencesService.instance.cerrarSesion();
                if (!context.mounted) return;
                Navigator.pushNamedAndRemoveUntil(context, '/login', (r) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      color: const Color(0xFF5A0E1A), // Granate institucional profundo
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: const Text(
        '© 2025 UNIVERSIDAD NACIONAL DE SAN ANTONIO ABAD DEL CUSCO – Todos los derechos reservados',
        style: TextStyle(
          color: Colors.white,
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
