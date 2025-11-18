import 'package:flutter/material.dart';
import 'student_store.dart';
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
          allowedRoles: [Role.admin, Role.teacher],
          child: AddStudentPage(),
        ),
      ),
    ),
  );
}

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({super.key});

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  // Colors for the UI
  static const primaryBlue = Color(0xFF1A2B8F);
  static const accentPurple = Color(0xFF6F73FF);

  // Controllers for the input fields
  final TextEditingController _firstNameCtrl = TextEditingController();
  final TextEditingController _middleNameCtrl =
      TextEditingController(); // optional middle name
  final TextEditingController _lastNameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _pwCtrl = TextEditingController();
  final TextEditingController _pwRepeatCtrl = TextEditingController();

  bool _submitting = false; // flag to prevent multiple submissions

  @override
  void dispose() {
    // Dispose all controllers when the page is closed
    _firstNameCtrl.dispose();
    _middleNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _pwCtrl.dispose();
    _pwRepeatCtrl.dispose();
    super.dispose();
  }

  // Simple email validation
  bool _isValidEmail(String value) {
    return value.contains('@') && value.contains('.');
  }

  // Save the student
  void _save() {
    if (_submitting) return;

    final firstName = _firstNameCtrl.text.trim();
    final middleName = _middleNameCtrl.text.trim(); // optional
    final lastName = _lastNameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final pw = _pwCtrl.text.trim();
    final repw = _pwRepeatCtrl.text.trim();

    // Validate first name
    if (firstName.isEmpty) {
      _toast('Please enter a first name.');
      return;
    }

    // Validate last name
    if (lastName.isEmpty) {
      _toast('Please enter a last name.');
      return;
    }

    // Validate email
    if (email.isEmpty || !_isValidEmail(email)) {
      _toast('Please enter a valid email.');
      return;
    }

    // Validate password fields
    if (pw.isEmpty || repw.isEmpty) {
      _toast('Please fill in both password fields.');
      return;
    }

    // Validate password match
    if (pw != repw) {
      _toast('Passwords do not match.');
      return;
    }

    setState(() => _submitting = true);

    final store = StudentStore.instance;

    // Combine full name with optional middle name
    final fullName = middleName.isEmpty
        ? '$firstName $lastName'
        : '$firstName $middleName $lastName';

    // Add student to the store if not already present
    if (!store.containsName(fullName)) {
      store.addByName(fullName);
    }

    store.setStatus(fullName, false);

    _toast('Added: $fullName');
    Navigator.of(context).maybePop();
  }

  // Display a toast message
  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
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
            // Page title
            Text(
              'Student Management',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: primaryBlue,
              ),
            ),
            const SizedBox(height: 24),

            // First name + Middle name in the same row
            Row(
              children: [
                // First Name
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('Voornaam:'), // First Name:
                      _inputField(
                        controller: _firstNameCtrl,
                        hint: 'Voornaam invoeren',
                        keyboardType: TextInputType.name,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12), // space between fields
                // Middle Name (optional)
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('Tussenvoegsel:'), // Middle Name:
                      _inputField(
                        controller: _middleNameCtrl,
                        hint: 'Tussenvoegsel',
                        keyboardType: TextInputType.name,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Last Name input
            _label('Achternaam:'), // Last Name:'
            _inputField(
              controller: _lastNameCtrl,
              hint: 'Achternaam invoeren',
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 16),

            // Email input
            _label('Email:'),
            _inputField(
              controller: _emailCtrl,
              hint: 'Geldig email invoeren',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

            // Password input
            _label('Wachtwoord:', color: Colors.white),
            _inputField(
              controller: _pwCtrl,
              hint: 'Wachtwoord invoeren',
              obscure: true,
            ),
            const SizedBox(height: 16),

            // Repeat Password input
            _label('Wachtwoord herhalen:', color: Colors.white),
            _inputField(
              controller: _pwRepeatCtrl,
              hint: 'Wachtwoord herhalen',
              obscure: true,
            ),
            const SizedBox(height: 28),

            // Create Button
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
                      borderRadius: BorderRadius.circular(14),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: _submitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Create'),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Return button
            Center(
              child: _buildReturnButton(
                onTap: () => Navigator.of(context).maybePop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Label widget
  Widget _label(String text, {Color color = const Color(0xFF1A2B8F)}) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  // Input field widget
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
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        textInputAction: TextInputAction.next,
        enableSuggestions: !obscure,
        autocorrect: !obscure,
        autofillHints: keyboardType == TextInputType.emailAddress
            ? const [AutofillHints.email]
            : null,
        smartDashesType: SmartDashesType.enabled,
        smartQuotesType: SmartQuotesType.disabled,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
          hintText: hint,
          hintStyle: const TextStyle(
            color: Colors.black54,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: const TextStyle(
          color: Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Return button widget
  Widget _buildReturnButton({required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        height: 70,
        child: Center(
          child: Image.asset(
            'assets/images/return.png',
            width: 70,
            height: 70,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
