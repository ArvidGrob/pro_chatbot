import 'package:flutter/material.dart';
import 'package:pro_chatbot/admindashboard/admin_dashboard.dart';
import 'package:pro_chatbot/admindashboard/teacher_overview.dart';
import 'package:pro_chatbot/api/api_services.dart';
import 'package:provider/provider.dart';
import '/theme_manager.dart';
import '/wave_background_layout.dart';
import '../models/user.dart';
import '../api/user_provider.dart';
import '/api/auth_guard.dart';


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
          child: AddTeacherPage(),
        ),
      ),
    ),
  );
}

class AddTeacherPage extends StatefulWidget {
  const AddTeacherPage({super.key});

  @override
  State<AddTeacherPage> createState() => _AddTeacherPageState();
}

class _AddTeacherPageState extends State<AddTeacherPage> {
  static const primaryBlue = Color(0xFF1A2B8F);
  static const accentPurple = Color(0xFF6F73FF);

  final TextEditingController _firstNameCtrl = TextEditingController();
  final TextEditingController _middleNameCtrl = TextEditingController();
  final TextEditingController _lastNameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _pwCtrl = TextEditingController();
  final TextEditingController _pwRepeatCtrl = TextEditingController();

  bool _submitting = false;

  // Default role is Teacher
  String _selectedRole = 'teacher';

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _middleNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _pwCtrl.dispose();
    _pwRepeatCtrl.dispose();
    super.dispose();
  }

  bool _isValidEmail(String value) {
    final regex = RegExp(r"^[\w\.\-]+@[a-zA-Z0-9]+\.[a-zA-Z]+$");
    return regex.hasMatch(value);
  }

  void _toast(String msg, {bool success = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: success ? Colors.green : Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _save() async {
    if (_submitting) return;

    final firstName = _firstNameCtrl.text.trim();
    final middleName = _middleNameCtrl.text.trim();
    final lastName = _lastNameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final pw = _pwCtrl.text.trim();
    final repw = _pwRepeatCtrl.text.trim();

    if (firstName.isEmpty)
      return _toast('Vul een voornaam in.', success: false);
    if (lastName.isEmpty)
      return _toast('Vul een achternaam in.', success: false);
    if (!_isValidEmail(email))
      return _toast('Vul een geldig e-mailadres in.', success: false);
    if (pw.isEmpty || repw.isEmpty)
      return _toast('Vul beide wachtwoorden in.', success: false);
    if (pw != repw)
      return _toast('Wachtwoorden komen niet overeen.', success: false);

    setState(() => _submitting = true);

    try {
      final api = ApiService();

      // Get current admin's school ID
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if (userProvider.currentUser?.school == null) {
        _toast('Admin heeft geen school ingesteld.', success: false);
        setState(() => _submitting = false);
        return;
      }
      final schoolId = userProvider.currentUser!.school!.id;

      await api.createTeacherOrAdmin(
        firstname: firstName,
        middlename: middleName.isEmpty ? null : middleName,
        lastname: lastName,
        email: email,
        password: pw,
        role: _selectedRole,
        schoolId: schoolId,
      );

      String fullName = firstName;
      if (middleName.isNotEmpty) {
        fullName += ' $middleName';
      }
      fullName += ' $lastName';

      _toast("Gebruiker $fullName succesvol aangemaakt!", success: true);

      _firstNameCtrl.clear();
      _middleNameCtrl.clear();
      _lastNameCtrl.clear();
      _emailCtrl.clear();
      _pwCtrl.clear();
      _pwRepeatCtrl.clear();
      setState(() => _selectedRole = 'teacher'); // reset role
    } catch (e) {
      if (e.toString().contains('E-mail bestaat al')) {
        _toast('Er bestaat al een gebruiker met dit e-mailadres.',
            success: false);
      } else {
        _toast('Het is niet gelukt om de gebruiker aan te maken.',
            success: false);
      }
    } finally {
      setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);

    return WaveBackgroundLayout(
      backgroundColor: themeManager.backgroundColor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Teacher Management',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: primaryBlue,
              ),
            ),
            const SizedBox(height: 24),

            // Row: First name + Middle name
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('Voornaam:'),
                      _inputField(
                          controller: _firstNameCtrl,
                          hint: 'Voornaam invoeren'),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('Tussenvoegsel:'),
                      _inputField(
                          controller: _middleNameCtrl,
                          hint: 'Tussenvoegsel (optioneel)'),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Row: Last name + Role
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('Achternaam:'),
                      _inputField(
                          controller: _lastNameCtrl,
                          hint: 'Achternaam invoeren'),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('Rol:'),
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.25),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: DropdownButton<String>(
                          value: _selectedRole,
                          isExpanded: true,
                          underline: const SizedBox(),
                          onChanged: (value) {
                            if (value != null)
                              setState(() => _selectedRole = value);
                          },
                          items: const [
                            DropdownMenuItem(
                                value: 'teacher', child: Text('Teacher')),
                            DropdownMenuItem(
                                value: 'admin', child: Text('Admin')),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            _label('Email:'),
            _inputField(
                controller: _emailCtrl,
                hint: 'Geldig email invoeren',
                keyboardType: TextInputType.emailAddress),

            const SizedBox(height: 16),

            _label('Wachtwoord:'),
            _inputField(
                controller: _pwCtrl,
                hint: 'Wachtwoord invoeren',
                obscure: true),

            const SizedBox(height: 16),

            _label('Wachtwoord herhalen:'),
            _inputField(
                controller: _pwRepeatCtrl,
                hint: 'Wachtwoord herhalen',
                obscure: true),

            const SizedBox(height: 28),

            Center(
              child: SizedBox(
                width: 180,
                height: 52,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentPurple,
                    foregroundColor: Colors.white,
                    elevation: 10,
                    shadowColor: Colors.black.withOpacity(.4),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  child: _submitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2.5, color: Colors.white),
                        )
                      : const Text('Create'),
                ),
              ),
            ),

            const SizedBox(height: 32),

            Center(
              child: _buildReturnButton(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TeacherOverviewPage(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text, {Color color = const Color(0xFF100c08)}) {
    return Text(text,
        style:
            TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w700));
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    bool obscure = false,
    TextInputType? keyboardType,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(.25),
              blurRadius: 8,
              offset: const Offset(0, 4))
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          hintText: hint,
          hintStyle: const TextStyle(
              color: Colors.black54, fontSize: 15, fontWeight: FontWeight.w500),
        ),
        style: const TextStyle(
            color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildReturnButton({required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 70,
        height: 70,
        child: Image.asset('assets/images/return.png',
            width: 70, height: 70, fit: BoxFit.contain),
      ),
    );
  }
}
