import 'package:flutter/material.dart';
import 'package:pro_chatbot/admindashboard/admin_dashboard.dart';
import 'package:pro_chatbot/api/api_services.dart';
import 'student_store.dart';
import 'student_delete.dart';
import 'addstudent.dart';
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
          child: StudentOverviewPage(),
        ),
      ),
    ),
  );
}

class StudentOverviewPage extends StatefulWidget {
  const StudentOverviewPage({super.key});

  @override
  State<StudentOverviewPage> createState() => _StudentOverviewPageState();
}

class _StudentOverviewPageState extends State<StudentOverviewPage> {
  static const primary = Color(0xFF6464FF);
  final TextEditingController _searchCtrl = TextEditingController();
  late Future<List<User>> _studentsFuture;

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  void _fetchStudents() {
    final api = ApiService();
    _studentsFuture = api.fetchStudents().then((students) {
      students.sort((a, b) {
        return a.firstname.toLowerCase().compareTo(b.firstname.toLowerCase());
      });
      return students;
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  // TOAST MESSAGE
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
    final query = _searchCtrl.text.trim().toLowerCase();

    return WaveBackgroundLayout(
      backgroundColor: themeManager.backgroundColor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  // Header
                  Center(
                    child: const Text(
                      'Studentenoverzicht',
                      style: TextStyle(
                        color: primary,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Buttons row
                  Row(
                    children: [
                      Expanded(
                        child: _pressableTile(
                          tileId: 'add_student',
                          label: 'Student toevoegen',
                          icon: Icons.person_add_alt_1_rounded,
                          color: primary,
                          onTap: () {
                            Navigator.of(context)
                                .push(
                                  MaterialPageRoute(
                                    builder: (_) => const AddStudentPage(),
                                  ),
                                )
                                .then((_) => setState(_fetchStudents));
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _pressableTile(
                          tileId: 'delete_student',
                          label: 'Student verwijderen',
                          icon: Icons.delete_forever_rounded,
                          color: Colors.red,
                          onTap: () {
                            Navigator.of(context)
                                .push(
                                  MaterialPageRoute(
                                    builder: (_) => const StudentDeletePage(),
                                  ),
                                )
                                .then((_) => setState(_fetchStudents));
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Container with search + list
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Studenten',
                            style: TextStyle(
                              color: primary,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: TextField(
                            controller: _searchCtrl,
                            onChanged: (_) => setState(() {}),
                            decoration: InputDecoration(
                              hintText: 'Zoek student',
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
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Divider(height: 0),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.55,
                          child: FutureBuilder<List<User>>(
                            future: _studentsFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Text(
                                    'Fout bij het ophalen van studenten: ${snapshot.error}',
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              }

                              final list = snapshot.data ?? [];
                              final filtered = query.isEmpty
                                  ? list
                                  : list.where((s) {
                                      final fullName =
                                          '${s.firstname} ${s.middlename ?? ''} ${s.lastname}';
                                      return fullName
                                          .toLowerCase()
                                          .contains(query);
                                    }).toList();

                              if (filtered.isEmpty) {
                                return const Center(
                                  child: Text('Geen studenten gevonden'),
                                );
                              }

                              return ListView.separated(
                                itemCount: filtered.length,
                                separatorBuilder: (_, __) =>
                                    const Divider(height: 0, thickness: .4),
                                itemBuilder: (context, i) {
                                  final s = filtered[i];
                                  final fullName =
                                      '${s.firstname} ${s.middlename ?? ''} ${s.lastname}'
                                          .trim();

                                  return ListTile(
                                    title: Text(
                                      fullName,
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    subtitle: Text(
                                      s.role == Role.admin
                                          ? 'Admin'
                                          : s.role == Role.teacher
                                              ? 'Teacher'
                                              : 'Student',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.more_vert),
                                      onPressed: () => _openStudentActions(s),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminDashboard(),
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
      ),
    );
  }

  Widget _pressableTile({
    required String tileId,
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.15),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Spacer(),
            Icon(icon, color: Colors.white, size: 30),
          ],
        ),
      ),
    );
  }

  void _openStudentActions(User s) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Student wijzigen'),
              onTap: () {
                Navigator.pop(context);
                _showEditStudentDialog(s);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text('Verwijderen',
                  style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _confirmDeleteStudent(s);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteStudent(User student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Weet je het zeker?'),
        content: Text(
            'Weet je zeker dat je ${student.firstname} ${student.lastname} wilt verwijderen?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuleren'),
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red),
            ),
            onPressed: () async {
              Navigator.of(context).pop(); // sluit de dialoog
              try {
                await ApiService().deleteStudent(
                    student.id!); // Voeg deleteStudent toe aan ApiService
                _toast(
                    'Student ${student.firstname} ${student.lastname} succesvol verwijderd');
                setState(_fetchStudents);
              } catch (e) {
                _toast('Kon student niet verwijderen: $e', success: false);
              }
            },
            child: const Text(
              'Verwijderen',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditStudentDialog(User student) {
    final firstnameCtrl = TextEditingController(text: student.firstname);
    final middlenameCtrl =
        TextEditingController(text: student.middlename ?? '');
    final lastnameCtrl = TextEditingController(text: student.lastname);
    final emailCtrl = TextEditingController(text: student.email);
    final oldPasswordCtrl = TextEditingController();
    final newPasswordCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: const Text('Wijzig student'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _dialogField('Voornaam', firstnameCtrl),
                _dialogField('Tussenvoegsel', middlenameCtrl),
                _dialogField('Achternaam', lastnameCtrl),
                _dialogField('E-mail', emailCtrl),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 10),
                const Text('Wachtwoord wijzigen',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                _dialogField('Oud wachtwoord', oldPasswordCtrl,
                    obscureText: true),
                _dialogField('Nieuw wachtwoord', newPasswordCtrl,
                    obscureText: true),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(const Color(0xFFFF4D4D)),
              ),
              child: const Text('Annuleren',
                  style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith((states) =>
                    states.contains(MaterialState.pressed)
                        ? const Color(0xFF018F6F)
                        : const Color(0xFF01BA8F)),
              ),
              onPressed: () async {
                try {
                  final updatedStudent = User(
                    id: student.id,
                    firstname: firstnameCtrl.text.trim(),
                    middlename: middlenameCtrl.text.trim(),
                    lastname: lastnameCtrl.text.trim(),
                    email: emailCtrl.text.trim(),
                    role: student.role,
                  );

                  await ApiService().updateStudent(
                    student: updatedStudent,
                    oldPassword: oldPasswordCtrl.text.isEmpty
                        ? null
                        : oldPasswordCtrl.text,
                    newPassword: newPasswordCtrl.text.isEmpty
                        ? null
                        : newPasswordCtrl.text,
                  );

                  setState(() => _fetchStudents());
                  Navigator.of(context).pop();

                  // ----- TOAST AFTER POPUP -----
                  String fullName =
                      '${updatedStudent.firstname} ${updatedStudent.middlename ?? ''} ${updatedStudent.lastname}'
                          .trim();
                  if (newPasswordCtrl.text.isNotEmpty) {
                    _toast(
                        'wachtwoord van $fullName succesvol gewijzigd!'); // 'Wachtwoord van Alberto Geritsen succesvol gewijzigd'
                  } else if (emailCtrl.text.trim() != student.email) {
                    _toast(
                        'E-mail van $fullName gewijzigd naar ${emailCtrl.text.trim()}!'); // 'E-mail van Alberto Geritsen gewijzigd naar Alberto@gmail.com'
                  } else {
                    _toast(
                        'Student succesvol gewijzigd naar $fullName'); // ('Student succsesvol gewijzigd naar Alberto Geritsen')
                  }
                } catch (e) {
                  _toast('Kon student niet bijwerken: $e', success: false);
                }
              },
              child:
                  const Text('Opslaan', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dialogField(String label, TextEditingController controller,
      {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
