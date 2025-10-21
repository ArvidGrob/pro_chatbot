import 'package:flutter/material.dart';

void main() {
  runApp(const LuminaraApp());
}

class LuminaraApp extends StatelessWidget {
  const LuminaraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Luminara AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.f7f7f7,
        fontFamily: 'DM Sans',
        useMaterial3: true,
      ),
      routes: {
        '/': (_) => const LoginPage(),
        '/navigation': (_) => const NavigationPage(),
      },
      initialRoute: '/',
    );
  }
}

class AppColors {
  static const c464646 = Color(0xFF464646);
  static const ffffff = Color(0xFFFFFFFF);
  static const c4242bd = Color(0xFF4242BD);
  static const c000000 = Color(0xFF000000);
  static const d9d9d9 = Color(0xFFD9D9D9);
  static const c2323ad = Color(0xFF2323AD);
  static const c2f2f2f = Color(0xFF2F2F2F);
  static const c363636 = Color(0xFF363636);
  static const c5454ff = Color(0xFF5454FF);
  static const c5c5c5 = Color(0xFF5C5C5C);
  static const c6464ff = Color(0xFF6464FF);
  static const c999999 = Color(0xFF999999);
  static const f7f7f7 = Color(0xFFF7F7F7);
}

/// LOGIN PAGE
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _idController = TextEditingController();
  final _pwController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscure = true;

  @override
  void dispose() {
    _idController.dispose();
    _pwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isSmall = size.width < 380;
    final maxW = size.width.clamp(320.0, 500.0); // responsive max width
    final pad = size.width > 600 ? 32.0 : 20.0;
    final titleSize = size.width > 400 ? 36.0 : 30.0;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(pad),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxW),
              child: Stack(
                children: [
                  // background colors
                  Positioned.fill(
                    child: Column(
                      children: [
                        const SizedBox(height: 80),
                        _Arc(color1: AppColors.c4242bd, color2: AppColors.c6464ff, height: 220, spread: 24),
                        const SizedBox(height: 8),
                        _Arc(color1: AppColors.c2323ad, color2: AppColors.c5454ff, height: 160, spread: 0),
                      ],
                    ),
                  ),

                  // content
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        'Inloggen',
                        style: TextStyle(
                          fontSize: titleSize,
                          fontWeight: FontWeight.w800,
                          color: AppColors.c2323ad,
                        ),
                      ),
                      const SizedBox(height: 16),

                    // Logo-Container mit Bild
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: AppColors.ffffff,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.c000000.withValues(0),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: Image.asset(
                          'assets/images/LuminaraAIBook.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                      const SizedBox(height: 16),
                      // "Luminara AI"
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.ffffff.withValues(0),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.c000000.withValues(0),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Text(
                          'Luminara AI',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: AppColors.c2f2f2f,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Formular
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _LabeledField(
                              label: 'Student ID',
                              controller: _idController,
                              hint: 'Student ID',
                              keyboardType: TextInputType.text,
                            ),
                            const SizedBox(height: 14),
                            _LabeledField(
                              label: 'Wachtwoord',
                              controller: _pwController,
                              hint: 'Wachtwoord',
                              obscure: _obscure,
                              suffix: IconButton(
                                icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                                onPressed: () => setState(() => _obscure = !_obscure),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              height: isSmall ? 52 : 58,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.c5454ff,
                                  foregroundColor: AppColors.ffffff,
                                  elevation: 6,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                                onPressed: () {
                                  // UI-Simulation: Validierung optional
                                  FocusScope.of(context).unfocus();
                                  Navigator.of(context).pushNamed('/navigation');
                                },
                                child: const Text(
                                  'Inloggen',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Input field widget
class _LabeledField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool obscure;
  final Widget? suffix;

  const _LabeledField({
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType,
    this.obscure = false,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.ffffff,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.c000000.withValues(0),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscure,
        style: const TextStyle(color: AppColors.c2f2f2f, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.c999999, fontWeight: FontWeight.w700),
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(16),
          ),
          suffixIcon: suffix,
        ),
      ),
    );
  }
}

/// simple background
class _Arc extends StatelessWidget {
  final Color color1;
  final Color color2;
  final double height;
  final double spread;

  const _Arc({
    required this.color1,
    required this.color2,
    required this.height,
    required this.spread,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: spread),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color1, color2],
        ),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(200),
          bottom: Radius.circular(40),
        ),
      ),
    );
  }
}

/// to navigation page
class NavigationPage extends StatelessWidget {
  const NavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.f7f7f7,
      appBar: AppBar(
        title: const Text('Navigation'),
        backgroundColor: AppColors.c4242bd,
        foregroundColor: AppColors.ffffff,
      ),
      body: const Center(
        child: Text(
          'Hier kommt eure Bottom Navigation / Tabs etc.',
          style: TextStyle(fontSize: 18, color: AppColors.c464646),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
