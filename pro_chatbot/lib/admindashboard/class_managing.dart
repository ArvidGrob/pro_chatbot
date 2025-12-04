import 'package:flutter/material.dart';
import 'package:pro_chatbot/admindashboard/class_overview.dart';
import 'package:provider/provider.dart';
import '../api/api_services.dart';
import '../api/user_provider.dart';
import '../models/user.dart';
import '/theme_manager.dart';
import '/api/auth_guard.dart';
import '/wave_background_layout.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeManager()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthGuard(
          allowedRoles: [Role.admin, Role.teacher],
          child: ClassOverviewPage(),
        ),
      ),
    ),
  );
}

class ManageClassStudentsPage extends StatefulWidget {
  final SchoolClass schoolClass;

  const ManageClassStudentsPage({super.key, required this.schoolClass});

  @override
  State<ManageClassStudentsPage> createState() =>
      _ManageClassStudentsPageState();
}

class _ManageClassStudentsPageState extends State<ManageClassStudentsPage> {
  final ApiService _api = ApiService();
  final TextEditingController _searchCtrl = TextEditingController();

  List<User> _classStudents = [];
  List<User> _availableStudents = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    setState(() => _loading = true);

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final schoolId = userProvider.currentUser?.school?.id;
      if (schoolId == null) throw Exception("School niet gevonden");

      final students = await _api.fetchStudents(schoolId);
      final unassigned = await _api.fetchUnassignedStudents(schoolId);

      setState(() {
        _classStudents =
            students.where((s) => s.classId == widget.schoolClass.id).toList();
        _availableStudents = unassigned;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      _toast('Kon studenten niet ophalen: $e', success: false);
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
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final query = _searchCtrl.text.trim().toLowerCase();

    /// ---------------- USE fullName FOR SEARCH ----------------
    final filteredClassStudents = query.isEmpty
        ? _classStudents
        : _classStudents
            .where((s) => s.fullName.toLowerCase().contains(query))
            .toList();

    final filteredAvailableStudents = query.isEmpty
        ? _availableStudents
        : _availableStudents
            .where((s) => s.fullName.toLowerCase().contains(query))
            .toList();

    return WaveBackgroundLayout(
      backgroundColor: themeManager.backgroundColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Studenten beheren klas: ${widget.schoolClass.name}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A4AFF),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // ----------------- SEARCH BAR -----------------
              TextField(
                controller: _searchCtrl,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Zoek student...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: (_searchCtrl.text.isEmpty)
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchCtrl.clear();
                            FocusScope.of(context).unfocus();
                            setState(() {});
                          },
                        ),
                  filled: true,
                  fillColor: const Color(0xFFEFEFEF),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              _loading
                  ? const Expanded(
                      child: Center(child: CircularProgressIndicator()))
                  : Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ----------------- STUDENTS IN CLASS -----------------
                              const Text(
                                'Studenten in deze klas',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),

                              if (filteredClassStudents.isEmpty)
                                const Text('Geen studenten in deze klas'),

                              ...filteredClassStudents.map(
                                (s) => ListTile(
                                  title: Text(s.fullName),

                                  /// ← FULL NAME
                                  trailing: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.red[400],
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text('Verwijder uit klas'),
                                    onPressed: () async {
                                      try {
                                        await _api.updateClasses(
                                          classId: widget.schoolClass.id,
                                          studentId: s.id,
                                          assign: false,
                                        );

                                        _toast(
                                            '${s.fullName} verwijderd uit klas');
                                        _loadStudents();
                                      } catch (e) {
                                        _toast(
                                            'Kon student niet verwijderen: $e',
                                            success: false);
                                      }
                                    },
                                  ),
                                ),
                              ),

                              const Divider(height: 24),

                              // ----------------- AVAILABLE STUDENTS -----------------
                              const Text(
                                'Beschikbare studenten',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),

                              if (filteredAvailableStudents.isEmpty)
                                const Text(
                                    'Geen beschikbare studenten om toe te voegen'),

                              ...filteredAvailableStudents.map(
                                (s) => ListTile(
                                  title: Text(s.fullName),

                                  /// ← FULL NAME
                                  trailing: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: const Color(0xFF01BA8F),
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text('Voeg toe'),
                                    onPressed: () async {
                                      try {
                                        await _api.updateClasses(
                                          classId: widget.schoolClass.id,
                                          studentId: s.id,
                                          assign: true,
                                        );

                                        _toast(
                                            '${s.fullName} toegevoegd aan klas');
                                        _loadStudents();
                                      } catch (e) {
                                        _toast('Kon student niet toevoegen: $e',
                                            success: false);
                                      }
                                    },
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
        ),
      ),
    );
  }
}

/// ---------------- USER FULLNAME EXTENSION ----------------
extension UserFullName on User {
  String get fullName {
    return [
      firstname,
      if (middlename != null && middlename!.trim().isNotEmpty) middlename,
      lastname
    ].join(' ');
  }
}
