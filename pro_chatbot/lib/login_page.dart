import 'package:flutter/material.dart';
import 'navigation.dart';

void main() {
  runApp(const _DebugLoginApp());
}

class _DebugLoginApp extends StatelessWidget {
  const _DebugLoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Luminara (Debug Login)',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6464FF)),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _idCtrl = TextEditingController();
  final _pwCtrl = TextEditingController();
  bool _obscure = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _idCtrl.dispose();
    _pwCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // TODO: add the real authentification later
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;
    // successfull -> Navigation Page
    //Navigator.of(context).pushReplacement(
      //MaterialPageRoute(
        //builder: (_) => const navigation(title: 'Dashboard'),
      //),
    //);
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF6464FF);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Hintergrund mit drei Bögen
            Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: Size(MediaQuery.of(context).size.width, 500),
              painter: WaveBackgroundPainter(),
            ),
          ),

        LayoutBuilder(
          builder: (context, c) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: c.maxHeight - 32),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    const Text(
                      'Inloggen',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: primary,
                        letterSpacing: .5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // Logo
                    SizedBox(
                      height: 240,
                      child: Image.asset(
                        'assets/images/luminara_logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Student naam
                            _RoundedField(
                              label: 'Studentnaam',
                              controller: _idCtrl,
                              textInputAction: TextInputAction.next,
                              validator: (v) => (v == null || v.isEmpty)
                                  ? 'Voer uw studentnaam in'
                                  : null,
                            ),
                            const SizedBox(height: 16),

                            // Password
                            _RoundedField(
                              label: 'Wachtwoord',
                              controller: _pwCtrl,
                              obscureText: _obscure,
                              validator: (v) => (v == null || v.isEmpty)
                                  ? 'Voer uw wachtwoord in'
                                  : null,
                              suffix: IconButton(
                                onPressed: () =>
                                    setState(() => _obscure = !_obscure),
                                icon: Icon(
                                  _obscure
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Login Button
                            SizedBox(
                              width: double.infinity,
                              height: 70,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _handleLogin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF8F8FFF),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  textStyle: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.6,
                                    color: Colors.white,
                                  ),
                                )
                                    : const Text('Inloggen'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    )
    )
    );
  }
}

/// text field
class _RoundedField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final String? Function(String?)? validator;
  final Widget? suffix;
  final TextInputAction? textInputAction;

  const _RoundedField({
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.validator,
    this.suffix,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      obscuringCharacter: '*',
      enableSuggestions: false,
      autocorrect: false,
      validator: validator,
      textInputAction: textInputAction,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: Color(0xFF2D2D2D),
      ),
      decoration: InputDecoration(
        hintText: label,
        hintStyle: TextStyle(color:
          Color(0xFF2D2D2D),
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        suffixIcon: suffix,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class WaveBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = const Color(0xFF2323AD)
      ..style = PaintingStyle.fill;

    final paint2 = Paint()
      ..color = const Color(0xFF4242BD)
      ..style = PaintingStyle.fill;

    final paint3 = Paint()
      ..color = const Color(0xFF5454FF)
      ..style = PaintingStyle.fill;

    // first wave, background, darkest
    final path1 = Path();
    path1.moveTo(0, size.height);
    path1.lineTo(0, size.height * 0.25);
    path1.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.05,
      size.width,
      size.height * 0.25,
    );
    path1.lineTo(size.width, size.height);
    path1.close();
    canvas.drawPath(path1, paint1);

    // second wave
    final path2 = Path();
    path2.moveTo(0, size.height);
    path2.lineTo(0, size.height * 0.35);
    path2.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.15,
      size.width,
      size.height * 0.35,
    );
    path2.lineTo(size.width, size.height);
    path2.close();
    canvas.drawPath(path2, paint2);

    // third wave
    final path3 = Path();
    path3.moveTo(0, size.height);
    path3.lineTo(0, size.height * 0.45);
    path3.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.25,
      size.width,
      size.height * 0.45,
    );
    path3.lineTo(size.width, size.height);
    path3.close();
    canvas.drawPath(path3, paint3);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
