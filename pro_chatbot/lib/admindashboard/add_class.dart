import 'package:flutter/material.dart';
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

  List<User> _allStudents = [];
  List<User> _selectedStudents = [];
  int? _selectedStudentId; // <-- Use int? for IDs

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    setState(() {
      _isLoading = true;
    });

    final provider = Provider.of<UserProvider>(context, listen: false);
    try {
      await provider.fetchStudents(); // fetch students via provider
      setState(() {
        _allStudents =
            provider.students.where((u) => u.role == Role.student).toList();

        // Sort alphabetically by full name (firstname + middlename + lastname)
        _allStudents.sort((a, b) {
          final aFullName =
              '${a.firstname} ${a.middlename ?? ''} ${a.lastname}'.trim();
          final bFullName =
              '${b.firstname} ${b.middlename ?? ''} ${b.lastname}'.trim();
          return aFullName.compareTo(bFullName);
        });
      });
    } catch (e) {
      _toast('Fout bij ophalen studenten: $e', success: false);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _classNameCtrl.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);

    return WaveBackgroundLayout(
      backgroundColor: themeManager.backgroundColor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
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
                      _buildInputField(
                        controller: _classNameCtrl,
                        hint: 'Voer een klasnaam in',
                      ),
                      const SizedBox(height: 24),
                      _buildStudentDropdown(),
                      const SizedBox(height: 16),
                      _buildSelectedStudentsChips(),
                      const SizedBox(height: 36),
                      _buildCreateClassButton(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 16),
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

  Widget _buildStudentDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Voeg studenten toe:',
          style: TextStyle(
            color: primary,
            fontSize: 15,
            fontWeight: FontWeight.w700,
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
          child: DropdownButton<int>(
            value: _selectedStudentId,
            isExpanded: true,
            underline: const SizedBox(),
            hint: const Text('Selecteer een student'),
            items: _allStudents
                .where((u) => !_selectedStudents.contains(u))
                .map(
                  (user) => DropdownMenuItem<int>(
                    value: user.id, // int ID
                    child: Text(
                        "${user.firstname} ${user.middlename ?? ''} ${user.lastname}"),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                final selected = _allStudents.firstWhere((u) => u.id == value);
                setState(() {
                  _selectedStudents.add(selected);
                  _selectedStudentId = null;
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedStudentsChips() {
    if (_selectedStudents.isEmpty) return const SizedBox();
    return Container(
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
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: _selectedStudents.map((student) {
              return Chip(
                label: Text(
                    "${student.firstname} ${student.middlename ?? ''} ${student.lastname}"),
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
    );
  }

  Widget _buildCreateClassButton() {
    return SizedBox(
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
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  void _onCreateClass() async {
    final name = _classNameCtrl.text.trim();

    if (name.isEmpty) {
      _toast('Voer een klasnaam in', success: false);
      return;
    }

    if (_selectedStudents.isEmpty) {
      _toast('Voeg ten minste één student toe', success: false);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final api = ApiService();

      // Convert students to list of maps
      final studentObjects =
          _selectedStudents.map((u) => {'id': u.id}).toList();

      // Create the class via API
      final classCreated = await api.createClass(
        name,
        studentObjects,
      );

      _toast('Klas ${classCreated.name} succesvol aangemaakt');

      // Return a Map, not the SchoolClass object
      Navigator.pop(context, {
        'id': classCreated.id,
        'className': classCreated.name,
        'students': studentObjects,
      });
    } catch (e) {
      _toast('Fout bij aanmaken klas: $e', success: false);
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
