import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/theme_manager.dart';
import '/wave_background_layout.dart';
import '../models/user.dart';
import '../api/user_provider.dart';
import '/api/auth_guard.dart';
import '../api/api_services.dart';

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
          child: StudentDeletePage(),
        ),
      ),
    ),
  );
}

class StudentDeletePage extends StatefulWidget {
  const StudentDeletePage({super.key});

  @override
  State<StudentDeletePage> createState() => _StudentDeletePageState();
}

class _StudentDeletePageState extends State<StudentDeletePage> {
  static const primary = Color(0xFF6464FF);

  final TextEditingController _searchCtrl = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  List<User> _allStudents = [];
  List<User> _filteredStudents = [];
  final Set<User> _selectedStudents = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(_onSearchChanged);
    _loadStudents();
  }

  @override
  void dispose() {
    _searchCtrl.removeListener(_onSearchChanged);
    _searchCtrl.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _onSearchChanged() => _filterStudents(_searchCtrl.text);

  Future<void> _loadStudents() async {
    setState(() => _isLoading = true);
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final schoolId = userProvider.currentUser?.school?.id;
      if (schoolId == null) return;

      _allStudents = await ApiService().fetchStudents(schoolId);
      _allStudents.sort((a, b) => a.fullName.compareTo(b.fullName));
      _filteredStudents = List.from(_allStudents);
    } catch (e) {
      _toast('Fout bij ophalen studenten: $e', success: false);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _filterStudents(String query) {
    setState(() {
      _filteredStudents = _allStudents
          .where((s) => s.fullName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _toggleSelect(User student) {
    setState(() {
      if (_selectedStudents.contains(student)) {
        _selectedStudents.remove(student);
      } else {
        _selectedStudents.add(student);
      }
    });
  }

  Future<void> _deleteSelected() async {
    if (_selectedStudents.isEmpty) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Bevestiging'),
        content: Text(
            'Weet je zeker dat je ${_selectedStudents.length} geselecteerde studenten wilt verwijderen?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuleren'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Verwijderen'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);
    try {
      final api = ApiService();
      for (var student in List<User>.from(_selectedStudents)) {
        await api.deleteStudent(student.id);
        _allStudents.remove(student);
      }
      _selectedStudents.clear();
      _filterStudents(_searchCtrl.text);
      _toast('Geselecteerde studenten succesvol verwijderd');
    } catch (e) {
      _toast('Fout bij verwijderen: $e', success: false);
    } finally {
      setState(() => _isLoading = false);
    }
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
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 16),
                      const Text(
                        'Studenten verwijderen',
                        style: TextStyle(
                          color: primary,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _searchCtrl,
                        focusNode: _searchFocus,
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          hintText: 'Een student zoeken',
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: const Color(0xFFEFEFEF),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        height: 400,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: _filteredStudents.isEmpty
                            ? const Center(
                                child: Text('Geen studenten gevonden'))
                            : ListView.separated(
                                itemCount: _filteredStudents.length,
                                separatorBuilder: (_, __) =>
                                    const Divider(height: 1),
                                itemBuilder: (context, index) {
                                  final student = _filteredStudents[index];
                                  final selected =
                                      _selectedStudents.contains(student);
                                  return ListTile(
                                    leading: Checkbox(
                                      value: selected,
                                      onChanged: (_) => _toggleSelect(student),
                                      activeColor: Colors.redAccent,
                                    ),
                                    title: Text(
                                      student.fullName,
                                      style: TextStyle(
                                        color: selected
                                            ? Colors.redAccent
                                            : Colors.blue,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),

                      const SizedBox(height: 20),
                      // ---------------- DELETE BUTTON ----------------
                      if (_selectedStudents.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: FloatingActionButton.extended(
                            onPressed: _deleteSelected,
                            backgroundColor: Colors.red,
                            label: Text(
                                'Verwijder ${_selectedStudents.length} student(en)'),
                            icon: const Icon(Icons.delete),
                          ),
                        ),

                      // ---------------- RETURN BUTTON ----------------
                      Center(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
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
      ),
    );
  }
}

// ---------------- USER FULLNAME EXTENSION ----------------
extension UserFullName on User {
  String get fullName {
    return [
      firstname,
      if (middlename != null && middlename!.trim().isNotEmpty) middlename,
      lastname
    ].join(' ');
  }
}
