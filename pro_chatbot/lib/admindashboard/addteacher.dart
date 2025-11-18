import 'package:flutter/material.dart';
import 'package:pro_chatbot/admindashboard/teacher_overview.dart';
import 'package:provider/provider.dart';
import '/theme_manager.dart';
import '/wave_background_layout.dart';
import '../models/user.dart';
import '../api/user_provider.dart';
import '/api/auth_guard.dart';
// import 'login/login_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeManager()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthGuard(
          allowedRoles: [Role.admin],
          child: TeacherOverviewPage(),
        ),
      ),
    ),
  );
}

class AddTeacherPage extends StatefulWidget {
  const AddTeacherPage({super.key});

  @override
  State<AddTeacherPage> createState() => _TeacherPageState();
}

class _TeacherPageState extends State<AddTeacherPage> {
  static const primary = Color(0xFF6464FF);

  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _pwCtrl = TextEditingController();
  final _pw2Ctrl = TextEditingController();

  bool _obscure1 = true;
  bool _obscure2 = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _pwCtrl.dispose();
    _pw2Ctrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    // TODO: add registration logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Docent geregistreerd (Demo).')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);

    return WaveBackgroundLayout(
      backgroundColor: themeManager.backgroundColor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Stack(
            children: [
              // Content
              LayoutBuilder(
                builder: (context, c) => SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: c.maxHeight - 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 6),
                        const Text(
                          'Docent toevoegen',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: primary,
                            letterSpacing: .5,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const _FieldLabel('Naam:'),
                              _InputCard(
                                child: TextFormField(
                                  controller: _nameCtrl,
                                  textInputAction: TextInputAction.next,
                                  validator: (v) =>
                                      (v == null || v.trim().isEmpty)
                                          ? 'Voer een naam in'
                                          : null,
                                  decoration: const InputDecoration(
                                    hintText: 'Voornaam en Achternaam',
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),

                              const _FieldLabel('Email'),
                              _InputCard(
                                child: TextFormField(
                                  controller: _emailCtrl,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) {
                                      return 'Voer een email in';
                                    }
                                    final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                        .hasMatch(v.trim());
                                    return ok ? null : 'Ongeldig emailadres';
                                  },
                                  decoration: const InputDecoration(
                                    hintText: 'Voer een Email in',
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              const _FieldLabel('Wachtwoord'),
                              _InputCard(
                                child: TextFormField(
                                  controller: _pwCtrl,
                                  obscureText: _obscure1,
                                  obscuringCharacter: '•',
                                  textInputAction: TextInputAction.next,
                                  validator: (v) => (v == null || v.length < 6)
                                      ? 'Min. 6 tekens'
                                      : null,
                                  decoration: InputDecoration(
                                    hintText: 'Voer een Wachtwoord in',
                                    suffixIcon: IconButton(
                                      onPressed: () => setState(
                                          () => _obscure1 = !_obscure1),
                                      icon: Icon(
                                        _obscure1
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),

                              const _FieldLabel('Herhaal wachtwoord:'),
                              _InputCard(
                                child: TextFormField(
                                  controller: _pw2Ctrl,
                                  obscureText: _obscure2,
                                  obscuringCharacter: '•',
                                  textInputAction: TextInputAction.done,
                                  validator: (v) => (v == _pwCtrl.text)
                                      ? null
                                      : 'Wachtwoorden komen niet overeen',
                                  decoration: InputDecoration(
                                    hintText: 'Herhaal Wachtwoord',
                                    suffixIcon: IconButton(
                                      onPressed: () => setState(
                                          () => _obscure2 = !_obscure2),
                                      icon: Icon(
                                        _obscure2
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Register-Button
                              Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  width: 220,
                                  height: 56,
                                  child: ElevatedButton(
                                    onPressed: _submit,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF8F8FFF),
                                      foregroundColor: Colors.white,
                                      elevation: 6,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      textStyle: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    child: const Text('Registreren'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                            height: 100), // Espace pour le bouton return
                      ],
                    ),
                  ),
                ),
              ),

              // Bouton retour en bas centré
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: Image.asset(
                      'assets/images/return.png',
                      width: 70,
                      height: 70,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Label on top of a field
class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 4),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF6464FF),
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _InputCard extends StatelessWidget {
  const _InputCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          inputDecorationTheme: const InputDecorationTheme(
            hintStyle:
                TextStyle(color: Colors.black38, fontWeight: FontWeight.w600),
            border: InputBorder.none,
          ),
        ),
        child: child,
      ),
    );
  }
}
