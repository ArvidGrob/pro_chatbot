import 'package:flutter/material.dart';

class AddClassPage extends StatefulWidget {
  const AddClassPage({super.key});

  @override
  State<AddClassPage> createState() => _AddClassPageState();
}

class _AddClassPageState extends State<AddClassPage> {
  static const Color primary = Color(0xFF4A4AFF);

  final TextEditingController _classNameCtrl = TextEditingController();
  final List<String> _allStudents = [
    'Emma de Vries',
    'Liam Bakker',
    'Sofie Jansen',
    'Noah Visser',
    'Mila de Boer',
    'Daan Willems',
  ];

  final List<String> _selectedStudents = [];
  String? _selectedStudent;

  @override
  void dispose() {
    _classNameCtrl.dispose();
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Titel
                    const Text(
                      'Klas toevoegen',
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

                    const SizedBox(height: 32),

                    // Klassenname
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Klasnaam:',
                        style: TextStyle(
                          color: primary,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    _buildInputField(
                      controller: _classNameCtrl,
                      hint: 'Voer een klasnaam in',
                    ),

                    const SizedBox(height: 24),

                    // Schüler hinzufügen
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Voeg studenten toe:',
                        style: TextStyle(
                          color: primary,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
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
                      child: DropdownButton<String>(
                        value: _selectedStudent,
                        isExpanded: true,
                        underline: const SizedBox(),
                        hint: const Text('Selecteer een student'),
                        items: _allStudents
                            .where(
                              (s) => !_selectedStudents.contains(s),
                        )
                            .map((student) => DropdownMenuItem(
                          value: student,
                          child: Text(student),
                        ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null && !_selectedStudents.contains(value)) {
                            setState(() {
                              _selectedStudents.add(value);
                              _selectedStudent = null;
                            });
                          }
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Anzeige hinzugefügter Schüler
                    if (_selectedStudents.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.1),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Toegevoegde studenten:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 8,
                              runSpacing: 6,
                              children: _selectedStudents.map((student) {
                                return Chip(
                                  label: Text(student),
                                  deleteIcon: const Icon(Icons.close),
                                  onDeleted: () {
                                    setState(() {
                                      _selectedStudents.remove(student);
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 36),

                    // Create button
                    SizedBox(
                      width: 180,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _onCreateClass,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6F73FF),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 8,
                          shadowColor: Colors.black.withOpacity(.25),
                        ),
                        child: const Text(
                          'Create class',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Return button
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
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
  }) {
    return Container(
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
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        ),
      ),
    );
  }

  void _onCreateClass() {
    final name = _classNameCtrl.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Voer een klasnaam in')),
      );
      return;
    }

    if (_selectedStudents.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Voeg ten minste één student toe')),
      );
      return;
    }

    // TODO: hier später an ClassStore übergeben
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Klas "$name" aangemaakt met ${_selectedStudents.length} studenten'),
      ),
    );

    Navigator.pop(context);
  }
}
