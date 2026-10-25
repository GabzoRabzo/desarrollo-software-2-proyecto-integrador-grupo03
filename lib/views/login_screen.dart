import 'package:flutter/material.dart';
import '../services/preferences_service.dart';
import '../theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codigoCtrl = TextEditingController(text: '221451');
  final _passCtrl = TextEditingController(text: '123');
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _codigoCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _iniciarSesion([String? codigoDirecto]) async {
    final codigo = codigoDirecto ?? _codigoCtrl.text.trim();
    final pass = _passCtrl.text.trim();

    if (codigo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, ingrese su código de estudiante.'),
          backgroundColor: AppColors.danger,
        ),
      );
      return;
    }

    if (pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, ingrese su contraseña institucional.'),
          backgroundColor: AppColors.danger,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 300));

    final resultado = await PreferencesService.instance.autenticarEstudiante(codigo, pass);

    if (!mounted) return;
    setState(() => _isLoading = false);

    switch (resultado) {
      case AuthResultado.exito:
        Navigator.pushReplacementNamed(context, '/');
        break;
      case AuthResultado.codigoNoExiste:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('El código de estudiante no se encuentra registrado en el padrón.'),
            backgroundColor: AppColors.danger,
          ),
        );
        break;
      case AuthResultado.passwordIncorrecto:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Contraseña incorrecta. Verifique sus credenciales institucionales.'),
            backgroundColor: AppColors.danger,
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      body: SafeArea(
        child: Column(
          children: [
            // Barra superior institucional
            _buildTopBar(),

            // Contenido central de Login
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: _buildLoginCard(),
                  ),
                ),
              ),
            ),

            // Pie de página simple
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/images/logounsaac_hd.png',
            height: 48,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.account_balance,
              size: 44,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'UNIVERSIDAD NACIONAL DE SAN ANTONIO ABAD DEL CUSCO',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryDark,
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Portal Académico · Sistema de Gestión Estudiantil',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.zero,
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Franja granate superior
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
            color: AppColors.primary,
            child: const Row(
              children: [
                Icon(Icons.lock_person_outlined, color: Colors.white, size: 22),
                SizedBox(width: 10),
                Text(
                  'ACCESO AL SISTEMA ACADÉMICO',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(26),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Ingrese sus credenciales universitarias para acceder al panel:',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: AppColors.ink,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Campo Código
                  const Text(
                    'Código Universitario',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _codigoCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Ej: 221451',
                      prefixIcon: Icon(Icons.badge_outlined, size: 20, color: AppColors.primary),
                      contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),

                  // Campo Contraseña
                  const Text(
                    'Contraseña Institucional',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _passCtrl,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: '••••••••',
                      prefixIcon: const Icon(Icons.lock_outline, size: 20, color: AppColors.primary),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          size: 20,
                          color: AppColors.muted,
                        ),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
                    ),
                    onFieldSubmitted: (_) => _iniciarSesion(),
                  ),
                  const SizedBox(height: 22),

                  // Botón Iniciar Sesión (Windows 10 plano)
                  SizedBox(
                    height: 44,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                      ),
                      onPressed: _isLoading ? null : () => _iniciarSesion(),
                      icon: _isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Icon(Icons.login, size: 18),
                      label: Text(
                        _isLoading ? 'Verificando...' : 'INGRESAR AL PANEL',
                        style: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Nota informativa
                  Container(
                    padding: const EdgeInsets.all(10),
                    color: const Color(0xFFF9F8F6),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline, size: 16, color: AppColors.gold),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Para soporte o reinicio de credenciales, comuníquese con el Centro de Cómputo de la EPIIS.',
                            style: TextStyle(fontSize: 10.5, color: AppColors.muted, height: 1.3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: AppColors.primary,
      child: const Text(
        '© 2025 UNIVERSIDAD NACIONAL DE SAN ANTONIO ABAD DEL CUSCO – Todos los derechos reservados',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 11,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
