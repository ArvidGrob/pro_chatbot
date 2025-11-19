import 'package:flutter/material.dart';
import 'package:pro_chatbot/settings/settings_page_account.dart';
import 'package:provider/provider.dart';
import '/theme_manager.dart';
import '/wave_background_layout.dart';
import 'package:pro_chatbot/api/user_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const SettingsPageAccount21(),
  ));
}

class SettingsPageAccount21 extends StatefulWidget {
  const SettingsPageAccount21({super.key});

  @override
  State<SettingsPageAccount21> createState() => _SettingsPageAccount21State();
}

class _SettingsPageAccount21State extends State<SettingsPageAccount21> {
  final TextEditingController _voornaamController = TextEditingController();
  final TextEditingController _naamController = TextEditingController();
  String _pressedButton = '';
  Future<void> changeName() async {
    final newFirstname = _voornaamController.text.trim();
    final newLastname = _naamController.text.trim();

    if (newFirstname.isEmpty || newLastname.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vul beide naamvelden in.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Geen gebruiker ingelogd.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final email = user.email;

    try {
      final response = await http.post(
        Uri.parse('https://chatbot.duonra.nl/api/change-name'),
        headers: const {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'firstname': newFirstname,
          'lastname': newLastname,
        }),
      );

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      if (response.statusCode != 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fout: Server gaf status ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (response.body.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Server stuurde een lege response."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        final updatedUser = user.copyWith(
          firstname: newFirstname,
          lastname: newLastname,
        );

        userProvider.updateUser(updatedUser);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Naam succesvol gewijzigd.'),
            backgroundColor: Colors.green,
          ),
        );

        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const SettingsPageAccount()),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? 'Er is een fout opgetreden.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fout: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }



  @override
  void dispose() {
    _voornaamController.dispose();
    _naamController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.currentUser;

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

              const SizedBox(height: 40),

              // Persoonlijke gegevens title
              Text(
                'Voornaam: ${user?.firstname ?? ''}\nAchternaam: ${user?.lastname ?? ''}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),


              const SizedBox(height: 30),

              // Nieuwe voornaam
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Nieuwe voornaam:',
                  style: TextStyle(
                    color: themeManager.subtitleTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextField(
                  controller: _voornaamController,
                  style: const TextStyle(fontSize: 18),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '',
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // Nieuwe naam
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Nieuwe naam:',
                  style: TextStyle(
                    color: themeManager.subtitleTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextField(
                  controller: _naamController,
                  style: const TextStyle(fontSize: 18),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '',
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // naam wijzigen button
              Align(
                alignment: Alignment.centerRight,
                child: _buildRegisterButton(
                  buttonId: 'registreren',
                  label: 'Naam wijzigen',
                  onTap: changeName,
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
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
