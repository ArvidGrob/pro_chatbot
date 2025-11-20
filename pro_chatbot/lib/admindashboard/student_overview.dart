import 'package:flutter/material.dart';
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
    _studentsFuture = api.fetchStudents(); // GET /api/users from backend
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Studentenoverzicht',
          style: TextStyle(
            color: primary,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: WaveBackgroundLayout(
        backgroundColor: themeManager.backgroundColor,
        child: Column(
          children: [
            // Searchbar
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
              child: TextField(
                controller: _searchCtrl,
                textInputAction: TextInputAction.search,
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

            const SizedBox(height: 16),

            // Buttons "Add student" + "Delete student"
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context)
                            .push(
                              MaterialPageRoute(
                                builder: (_) => const AddStudentPage(),
                              ),
                            )
                            .then((_) =>
                                setState(_fetchStudents)); // Refresh list
                      },
                      icon: const Icon(Icons.person_add_alt_1_rounded),
                      label: const Text('Student toevoegen'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6F73FF),
                        foregroundColor: Colors.white,
                        elevation: 6,
                        shadowColor: Colors.black.withOpacity(.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context)
                            .push(
                              MaterialPageRoute(
                                builder: (_) => const StudentDeletePage(),
                              ),
                            )
                            .then((_) =>
                                setState(_fetchStudents)); // Refresh list
                      },
                      icon: const Icon(Icons.delete_forever_rounded),
                      label: const Text('Student verwijderen'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF4D4D),
                        foregroundColor: Colors.white,
                        elevation: 6,
                        shadowColor: Colors.black.withOpacity(.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 5),

            // Student list
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    12, 0, 12, 100), // adjust bottom padding if needed
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
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
                        final q = _searchCtrl.text.trim().toLowerCase();
                        final filtered = q.isEmpty
                            ? list
                            : list
                                .where((s) =>
                                    ('${s.firstname} ${s.middlename ?? ''} ${s.lastname}')
                                        .toLowerCase()
                                        .contains(q))
                                .toList();

                        if (filtered.isEmpty) {
                          return const Center(
                            child: Text('Geen studenten gevonden'),
                          );
                        }

                        return ListView.separated(
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) => const Divider(height: 0),
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
                                s.online ? 'Online' : 'Offline',
                                style: TextStyle(
                                  color: s.online ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.more_vert),
                                onPressed: () => _openStudentActions(s),
                              ),
                              onTap: () {
                                // Toggle online status locally
                                setState(() => s.online = !s.online);
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
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
              title: const Text('Naam wijzigen'),
              onTap: () {
                Navigator.pop(context);
                // TODO: implement rename API
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text('Verwijderen',
                  style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                // TODO: implement delete API
              },
            ),
          ],
        ),
      ),
    );
  }
}
