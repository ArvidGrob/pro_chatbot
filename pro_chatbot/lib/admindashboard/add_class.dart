import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/theme_manager.dart';
import '/wave_background_layout.dart';
import '../models/user.dart';
import '../api/user_provider.dart';
import '/api/auth_guard.dart';
import '../api/api_services.dart'; // NEU: für Schüler-API

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
          child: AddClassPage(),
        ),
      ),
    ),
  );
}

class AddClassPage extends StatefulWidget {
  const AddClassPage({super.key});

  @override
  State<AddClassPage> createState() => _AddClassPageState();
}

class _AddClassPageState extends State<AddClassPage> {
  static const Color primary = Color(0xFF4A4AFF);

  final TextEditingController _classNameCtrl = TextEditingController();

  final ApiService _api = ApiService();


  List<User> _allStudents = [];
  final List<User> _selectedStudents = [];
  User? _selectedStudent;

  bool _isLoadingStudents = true;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    setState(() {
      _isLoadingStudents = true;
      _loadError = null;
    });

    try {

      final users = await _api.getUsers();

      setState(() {
        _allStudents =
            users.where((u) => u.role == Role.student).toList();
        _isLoadingStudents = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingStudents = false;
        _loadError = 'Kon studenten niet laden: $e';
      });
    }
  }

  @override
  void dispose() {
    _classNameCtrl.dispose();
    super.dispose();
  }

  String _fullName(User u) {
    if (u.middlename != null && u.middlename!.trim().isNotEmpty) {
      return '${u.firstname} ${u.middlename} ${u.lastname}';
    }
    return '${u.firstname} ${u.lastname}';
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
              Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Klas toevoegen',
                            style: TextStyle(
                              color: Color(0xFF3D4ED8),
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Klasnaam
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

                          // studenten
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
                            child: _buildStudentDropdown(),
                          ),

                          const SizedBox(height: 16),

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
                                    children:
                                    _selectedStudents.map((student) {
                                      return Chip(
                                        label: Text(_fullName(student)),
                                        deleteIcon: const Icon(Icons.close),
                                        onDeleted: () {
                                          setState(() {
                                            _selectedStudents.removeWhere(
                                                    (u) => u.id == student.id);
                                          });
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),

                          const SizedBox(height: 36),

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

                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Retour-knop
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

  Widget _buildStudentDropdown() {
    if (_isLoadingStudents) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_loadError != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(_loadError!)),
            TextButton(
              onPressed: _loadStudents,
              child: const Text('Opnieuw'),
            ),
          ],
        ),
      );
    }

    if (_allStudents.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Text('Geen studenten gevonden'),
      );
    }

    final availableStudents = _allStudents
        .where((s) => !_selectedStudents.any((sel) => sel.id == s.id))
        .toList();

    return DropdownButton<User>(
      value: _selectedStudent,
      isExpanded: true,
      underline: const SizedBox(),
      hint: const Text('Selecteer een student'),
      items: availableStudents
          .map(
            (student) => DropdownMenuItem<User>(
          value: student,
          child: Text(_fullName(student)),
        ),
      )
          .toList(),
      onChanged: (value) {
        if (value != null &&
            !_selectedStudents.any((u) => u.id == value.id)) {
          setState(() {
            _selectedStudents.add(value);
            _selectedStudent = null;
          });
        }
      },
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


    Navigator.pop<String>(context, name);
  }
}
