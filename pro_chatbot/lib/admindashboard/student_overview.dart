import 'package:flutter/material.dart';
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Studenten',
      home: const StudentOverviewPage(),
    );
  }
}

class StudentOverviewPage extends StatefulWidget {
  const StudentOverviewPage({super.key});

  @override
  State<StudentOverviewPage> createState() => _StudentOverviewPageState();
}

class _StudentOverviewPageState extends State<StudentOverviewPage> {
  static const primary = Color(0xFF6464FF);
  final TextEditingController _searchCtrl = TextEditingController();

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
        child: Stack(
          children: [
            Column(
              children: [
                // Searchbar
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
                  child: TextField(
                    controller: _searchCtrl,
                    textInputAction: TextInputAction.search,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Een chat zoeken',
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
                      // Add student button
                      Expanded(
                        child: SizedBox(
                          height: 44,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const AddStudentPage(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6F73FF),
                              foregroundColor: Colors.white,
                              elevation: 6,
                              shadowColor: Colors.black.withOpacity(.2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              textStyle: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.person_add_alt_1_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    'Student toevoegen',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 5),

                      // Delete student button
                      Expanded(
                        child: SizedBox(
                          height: 44,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const StudentDeletePage(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF4D4D),
                              foregroundColor: Colors.white,
                              elevation: 6,
                              shadowColor: Colors.black.withOpacity(.2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              textStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.delete_forever_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    'Student verwijderen',
                                    overflow: TextOverflow.ellipsis,
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

                const SizedBox(height: 5),

                // Student list
                Expanded(
                  child: ValueListenableBuilder<List<Student>>(
                    valueListenable: StudentStore.instance.students,
                    builder: (context, list, _) {
                      final q = _searchCtrl.text.trim().toLowerCase();
                      final filtered = q.isEmpty
                          ? list
                          : list
                              .where(
                                (s) => s.name.toLowerCase().contains(q),
                              )
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

                          return MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 4,
                              ),
                              title: Text(
                                s.name,
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
                              onLongPress: () => _openStudentActions(s),
                              onTap: () {
                                final newStatus = !s.online;
                                StudentStore.instance
                                    .setStatus(s.name, newStatus);
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: _buildReturnButton(
                  buttonId: 'return',
                  iconPath: 'assets/images/return.png',
                  onTap: () => Navigator.of(context).maybePop(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openStudentActions(Student s) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Naam wijzigen'),
                onTap: () {
                  Navigator.pop(context);
                  _showRenameDialog(s);
                },
              ),
              ListTile(
                leading: const Icon(Icons.visibility),
                title: const Text('Wachtwoord tonen'),
                onTap: () {
                  Navigator.pop(context);
                  _showPasswordDialog(s);
                },
              ),
              ListTile(
                leading: const Icon(Icons.lock_reset),
                title: const Text('Wachtwoord wijzigen'),
                onTap: () {
                  Navigator.pop(context);
                  _showChangePasswordDialog(s);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.delete_forever,
                  color: Colors.red,
                ),
                title: const Text(
                  'Verwijderen',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  StudentStore.instance.removeByName(s.name);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Verwijderd: ${s.name}'),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // show name
  void _showRenameDialog(Student s) {
    final ctrl = TextEditingController(text: s.name);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Naam wijzigen'),
          content: TextField(
            controller: ctrl,
            decoration: const InputDecoration(
              hintText: 'Nieuwe naam',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuleer'),
            ),
            TextButton(
              onPressed: () {
                final newName = ctrl.text.trim();
                if (newName.isNotEmpty) {
                  StudentStore.instance.renameStudent(s.name, newName);
                }
                Navigator.pop(context);
              },
              child: const Text('Opslaan'),
            ),
          ],
        );
      },
    );
  }

  //show password
  void _showPasswordDialog(Student s) {
    final pw = s.password ?? 'Geen wachtwoord opgeslagen';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Wachtwoord'),
          content: Text(pw),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // change password
  void _showChangePasswordDialog(Student s) {
    final pwCtrl = TextEditingController();
    final pwAgainCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nieuw wachtwoord'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: pwCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Wachtwoord',
                ),
              ),
              TextField(
                controller: pwAgainCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Herhaal wachtwoord',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuleer'),
            ),
            TextButton(
              onPressed: () {
                final p1 = pwCtrl.text.trim();
                final p2 = pwAgainCtrl.text.trim();
                if (p1.isEmpty || p1 != p2) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Wachtwoorden komen niet overeen'),
                    ),
                  );
                  return;
                }
                StudentStore.instance.setPassword(s.name, p1);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Wachtwoord aangepast'),
                  ),
                );
              },
              child: const Text('Opslaan'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildReturnButton({
    required String buttonId,
    required String iconPath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        iconPath,
        width: 70,
        height: 70,
        fit: BoxFit.contain,
      ),
    );
  }
}
