import 'package:flutter/material.dart';
import '../navigation/navigation_page.dart';

void main() {
  runApp(const _DebugLoginApp());
}

class _DebugLoginApp extends StatelessWidget {
  const _DebugLoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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

    // Successful -> Navigation Page
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const NavigationPage(),
      ),
    );

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF6464FF);

    return Scaffold(
        body: Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
          child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                      onPressed: () => setState(() => _obscure = !_obscure),
                      icon: Icon(
                        _obscure ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

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
      )),
    ));
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
        hintStyle: TextStyle(
          color: Color(0xFF2D2D2D),
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
