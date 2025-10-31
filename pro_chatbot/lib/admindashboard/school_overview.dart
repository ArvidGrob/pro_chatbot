import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'School',
      home: const SchoolOverviewPage(),
    );
  }
}

class SchoolOverviewPage extends StatefulWidget {
  const SchoolOverviewPage({super.key});

  @override
  State<SchoolOverviewPage> createState() => _SchoolOverviewPageState();
}

class _SchoolOverviewPageState extends State<SchoolOverviewPage> {
  static const Color primary = Color(0xFF4A4AFF);

  final TextEditingController _schoolNameCtrl =
  TextEditingController(text: "Mijn School");

  @override
  void dispose() {
    _schoolNameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Hintergrundbild
          SizedBox.expand(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Überschrift
                  const Text(
                    'School Overview',
                    style: TextStyle(
                      color: Color(0xFF3D4ED8),
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 2),
                          blurRadius: 3,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Eingabefeld für Schulname
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'School name:',
                      style: TextStyle(
                        color: primary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.1),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _schoolNameCtrl,
                      decoration: const InputDecoration(
                        hintText: 'Enter school name',
                        border: InputBorder.none,
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Speichern-Button
                  SizedBox(
                    width: 180,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () {
                        final name = _schoolNameCtrl.text.trim();
                        if (name.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter a school name'),
                            ),
                          );
                          return;
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('School name updated: $name'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 8,
                        shadowColor: Colors.black.withOpacity(.2),
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Platzhalter für zukünftige Statistiken
                  const Text(
                    'School statistics will appear here later...',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),

                  const Spacer(),

                  // Return-Button unten
                  GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.15),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/images/return.png',
                          width: 38,
                          height: 38,
                          fit: BoxFit.contain,
                        ),
                      ),
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
}
