import 'package:flutter/material.dart';
import 'student_store.dart';

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({super.key});

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  static const primaryBlue = Color(0xFF1A2B8F);
  static const accentPurple = Color(0xFF6F73FF);

  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _idCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _pwCtrl = TextEditingController();
  final TextEditingController _pwRepeatCtrl = TextEditingController();

  bool _submitting = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _idCtrl.dispose();
    _emailCtrl.dispose();
    _pwCtrl.dispose();
    _pwRepeatCtrl.dispose();
    super.dispose();
  }

  bool _isValidEmail(String value) {
    return value.contains('@') && value.contains('.');
  }

  void _save() {
    if (_submitting) return;

    final name = _nameCtrl.text.trim();
    final id = _idCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final pw = _pwCtrl.text.trim();
    final repw = _pwRepeatCtrl.text.trim();

    if (name.isEmpty) {
      _toast('Vul een naam in.');
      return;
    }

    if (email.isEmpty || !_isValidEmail(email)) {
      _toast('Voer een geldig e-mailadres in.');
      return;
    }

    if (pw.isEmpty || repw.isEmpty) {
      _toast('Vul beide wachtwoordvelden in.');
      return;
    }

    if (pw != repw) {
      _toast('Wachtwoorden komen niet overeen.');
      return;
    }

    setState(() => _submitting = true);

    final store = StudentStore.instance;

    if (!store.containsName(name)) {
      store.addByName(name);
    }

    store.setStatus(name, false);

    _toast('Toegevoegd: $name');
    Navigator.of(context).maybePop();
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Student beheer',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: primaryBlue,
                      shadows: [
                        Shadow(
                          offset: const Offset(0, 3),
                          blurRadius: 6,
                          color: Colors.black.withOpacity(0.25),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // naam
                  _label('Naam:'),
                  _inputField(
                    controller: _nameCtrl,
                    hint: 'Voornaam en Achternaam',
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(height: 16),

                  // id
                  _label('Student ID:'),
                  _inputField(
                    controller: _idCtrl,
                    hint: 'Voer een Student ID in',
                  ),
                  const SizedBox(height: 16),

                  // email
                  _label('Email:'),
                  _inputField(
                    controller: _emailCtrl,
                    hint: 'Voer een Email in',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),

                  // pw
                  _label('Wachtwoord:', color: Colors.white),
                  _inputField(
                    controller: _pwCtrl,
                    hint: 'Voer een Wachtwoord in',
                    obscure: true,
                  ),
                  const SizedBox(height: 16),

                  // repeat pw
                  _label('Herhaal wachtwoord:', color: Colors.white),
                  _inputField(
                    controller: _pwRepeatCtrl,
                    hint: 'Herhaal Wachtwoord',
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

                  Center(
                    child: _buildReturnButton(
                      onTap: () => Navigator.of(context).maybePop(),
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
