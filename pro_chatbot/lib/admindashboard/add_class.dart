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
  final TextEditingController _searchCtrl = TextEditingController();

  List<User> _allStudents = [];
  List<User> _filteredStudents = [];
  List<User> _selectedStudents = [];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    setState(() => _isLoading = true);

    try {
      // Fetch only students without a class from backend
      _allStudents = await ApiService().fetchUnassignedStudents();

      // Sort alphabetically by full name
      _allStudents.sort((a, b) => a.fullName.compareTo(b.fullName));

      // Initially show all students
      _filteredStudents = List.from(_allStudents);
    } catch (e) {
      _toast('Fout bij ophalen studenten: $e', success: false);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _toggleStudent(User student) {
    setState(() {
      if (_selectedStudents.contains(student)) {
        _selectedStudents.remove(student);
      } else {
        _selectedStudents.add(student);
      }
      _filterStudents(_searchCtrl.text);
    });
  }

  void _filterStudents(String query) {
    setState(() {
      _filteredStudents = _allStudents
          .where((student) =>
              student.fullName.toLowerCase().contains(query.toLowerCase()) &&
              !_selectedStudents.contains(student))
          .toList();
    });
  }

  @override
  void dispose() {
    _classNameCtrl.dispose();
    _searchCtrl.dispose();
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
      final studentObjects =
          _selectedStudents.map((u) => {'id': u.id}).toList();

      final classCreated = await api.createClass(
        name,
        studentObjects,
      );

      _toast('Klas ${classCreated.name} succesvol aangemaakt');

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
                      _buildStudentSearch(),
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

  Widget _buildStudentSearch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
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
                'Voeg studenten toe:',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF4A4AFF),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _searchCtrl,
                decoration: const InputDecoration(
                  hintText: 'Zoek student...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: _filterStudents,
              ),
              const SizedBox(height: 6),
              Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _filteredStudents.isEmpty
                    ? const Center(child: Text('Geen studenten gevonden'))
                    : ListView.separated(
                        itemCount: _filteredStudents.length,
                        itemBuilder: (context, index) {
                          final student = _filteredStudents[index];
                          return ListTile(
                            title: Text(student.fullName),
                            trailing: Icon(
                              _selectedStudents.contains(student)
                                  ? Icons.check_circle
                                  : Icons.circle_outlined,
                              color: _selectedStudents.contains(student)
                                  ? Colors.green
                                  : null,
                            ),
                            onTap: () => _toggleStudent(student),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1),
                      ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (_selectedStudents.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
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
                    color: Color(0xFF3D4ED8),
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: _selectedStudents.map((student) {
                    return Chip(
                      label: Text(student.fullName),
                      deleteIcon: const Icon(Icons.close),
                      onDeleted: () => _toggleStudent(student),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
      ],
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
}

// User fullName extension
extension UserFullName on User {
  String get fullName => '${firstname} ${middlename ?? ''} ${lastname}'.trim();
}
