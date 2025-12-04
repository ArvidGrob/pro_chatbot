import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/theme_manager.dart';
import '/wave_background_layout.dart';
import '../models/user.dart';
import '../api/user_provider.dart';
import '/api/auth_guard.dart';
import '../api/api_services.dart'; // <-- API with deleteStudent

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
  bool _showPopup = false;

  List<User> _allStudents = [];
  List<User> _filteredStudents = [];
  final Set<User> _selectedStudents = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(_onSearchChanged);
    _searchFocus.addListener(() {
      setState(() =>
          _showPopup = _searchFocus.hasFocus && _searchCtrl.text.isNotEmpty);
    });
    _loadStudents();
  }

  @override
  void dispose() {
    _searchCtrl.removeListener(_onSearchChanged);
    _searchCtrl.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterStudents(_searchCtrl.text);
    setState(() {
      _showPopup = _searchFocus.hasFocus && _searchCtrl.text.trim().isNotEmpty;
    });
  }

  Future<void> _loadStudents() async {
    setState(() => _isLoading = true);
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final schoolId = userProvider.currentUser?.school?.id;
      if (schoolId == null) return;

      // Fetch all students, not just unassigned
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
          .where((s) =>
              s.fullName.toLowerCase().contains(query.toLowerCase()) &&
              !_selectedStudents.contains(s))
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
      _filterStudents(_searchCtrl.text);
    });
  }

  Future<void> _deleteStudent(User student) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Weet je het zeker?'),
        content: Text('Wil je ${student.fullName} verwijderen?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuleren'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Verwijderen'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);
    try {
      await ApiService().deleteStudent(student.id!);
      _allStudents.remove(student);
      _selectedStudents.remove(student);
      _filterStudents(_searchCtrl.text);
      _toast('Student ${student.fullName} verwijderd');
    } catch (e) {
      _toast('Fout bij verwijderen: $e', success: false);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _deleteSelected() async {
    if (_selectedStudents.isEmpty) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
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
        await api.deleteStudent(student.id!);
        _allStudents.remove(student);
        _selectedStudents.remove(student);
      }
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
                        'Studentenbeheer',
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
                        height: 300,
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
                                    title: Text(
                                      student.fullName,
                                      style: TextStyle(
                                        color: selected
                                            ? Colors.white
                                            : Colors.blue,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    tileColor:
                                        selected ? Colors.redAccent : null,
                                    onTap: () => _toggleSelect(student),
                                    onLongPress: () => _deleteStudent(student),
                                  );
                                },
                              ),
                      ),
                      const SizedBox(height: 16),
                      if (_selectedStudents.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(12),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Geselecteerde studenten',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: _selectedStudents
                                    .map(
                                      (s) => Chip(
                                        label: Text(s.fullName),
                                        backgroundColor: Colors.redAccent,
                                        labelStyle: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                        deleteIconColor: Colors.white,
                                        onDeleted: () => _toggleSelect(s),
                                      ),
                                    )
                                    .toList(),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: _deleteSelected,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text('Verwijder geselecteerde'),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 16),
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
