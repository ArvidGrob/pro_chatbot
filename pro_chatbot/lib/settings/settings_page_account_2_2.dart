import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pro_chatbot/settings/settings_page_account.dart';
import 'package:pro_chatbot/api/user_provider.dart';

import '/theme_manager.dart';
import '/wave_background_layout.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;


void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const SettingsPageAccount22(),
  ));
}

class SettingsPageAccount22 extends StatefulWidget {
  const SettingsPageAccount22({super.key});

  @override
  State<SettingsPageAccount22> createState() => _SettingsPageAccount22State();
}

class _SettingsPageAccount22State extends State<SettingsPageAccount22> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String _pressedButton = '';

  Future<void> changePassword() async {
    final oldPw = _oldPasswordController.text.trim();
    final newPw = _newPasswordController.text.trim();
    final confPw = _confirmPasswordController.text.trim();

    // 1. New passwords dont align
    if (newPw != confPw) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Nieuw wachtwoord en bevestiging zijn niet hetzelfde."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // 2. get UserProvider
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Geen gebruiker ingelogd."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final email = user.email;

    // 3. send Request
    final response = await http.post(
      Uri.parse('http://145.44.202.195:80/api/change-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'old_password': oldPw,
        'new_password': newPw,
      }),
    );

    final data = jsonDecode(response.body);

    // 4. error
    if (data['success'] != true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(data['error'] ?? "Het oude wachtwoord is onjuist."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // 5. sucessful
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Wachtwoord succesvol gewijzigd!"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    // Optional: go back after 2sec delay
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }


  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);

    return WaveBackgroundLayout(
      backgroundColor: themeManager.backgroundColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Title with icon
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Account',
                    style: TextStyle(
                      color: Color(0xFF6464FF),
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Image.asset(
                    'assets/images/account_2.png',
                    width: 60,
                    height: 60,
                    fit: BoxFit.contain,
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Wachtwoord wijzigen title
              Text(
                'Wachtwoord wijzigen',
                style: TextStyle(
                  color: themeManager.subtitleTextColor,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 25),

              // Oud wachtwoord field
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Oud wachtwoord:',
                  style: TextStyle(
                    color: themeManager.subtitleTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _oldPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFD9D9D9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 18.0,
                    horizontal: 20.0,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 40),

              // Nieuw wachtwoord field
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Nieuw wachtwoord:',
                  style: TextStyle(
                    color: themeManager.subtitleTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFD9D9D9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 18.0,
                    horizontal: 20.0,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 30),

              // Nieuw wachtwoord bevestigen field
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Nieuw wachtwoord bevestigen:',
                  style: TextStyle(
                    color: themeManager.subtitleTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFD9D9D9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 18.0,
                    horizontal: 20.0,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 30),

              // wijzigen button - aligned to right
              Align(
                alignment: Alignment.centerRight,
                child: _buildRegisterButton(
                  buttonId: 'wijzigen',
                  label: 'wijzigen',
                  onTap: changePassword,
                ),
              ),

              const Spacer(),

              // Return button (to SettingsPage)
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsPageAccount(),
                      ),
                    );
                  },
                  child: Image.asset(
                    'assets/images/return.png',
                    width: 70,
                    height: 70,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterButton({
    required String buttonId,
    required String label,
    required VoidCallback onTap,
  }) {
    bool isPressed = _pressedButton == buttonId;
    Color buttonColor =
        isPressed ? const Color(0xFF018F6F) : const Color(0xFF01BA8F);

    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _pressedButton = buttonId;
        });
      },
      onTapUp: (_) {
        setState(() {
          _pressedButton = '';
        });
        onTap();
      },
      onTapCancel: () {
        setState(() {
          _pressedButton = '';
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 25.0),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
