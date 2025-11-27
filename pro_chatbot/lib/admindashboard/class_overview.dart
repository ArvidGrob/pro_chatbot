import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_class.dart';
import '/theme_manager.dart';
import '/wave_background_layout.dart';
import '../models/user.dart';
import '../api/user_provider.dart';
import '/api/auth_guard.dart';

import '../api/api_services.dart';
import '../models/school_class.dart';

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
          child: ClassOverviewPage(),
        ),
      ),
    ),
  );
}

class ClassOverviewPage extends StatefulWidget {
  const ClassOverviewPage({super.key});

  @override
  State<ClassOverviewPage> createState() => _ClassOverviewPageState();
}

class _ClassOverviewPageState extends State<ClassOverviewPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  final ApiService _api = ApiService();

  List<SchoolClass> _classes = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  Future<void> _loadClasses() async {
    try {
      final classes = await _api.getClasses();
      setState(() {
        _classes = classes;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Laden der klassen: $e')),
      );
    }
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
    final filtered = query.isEmpty
        ? _classes
        : _classes
        .where((c) => c.name.toLowerCase().contains(query))
        .toList();

    return WaveBackgroundLayout(
      backgroundColor: themeManager.backgroundColor,
      child: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Center(
                    child: Text(
                      'Klas overzicht',
                      style: TextStyle(
                        color: Color(0xFF3D4ED8),
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // searchfield
                  TextField(
                    controller: _searchCtrl,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Zoek klasse...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: const Color(0xFFEFEFEF),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // add classes
                  SizedBox(
                    width: double.infinity,
                    height: 42,
                    child: ElevatedButton.icon(
                      onPressed: _onAddClass,
                      icon: const Icon(Icons.add),
                      label: const Text('Klasse toevoegen'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6F73FF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // List of classes
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 100),
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
                        child: _loading
                            ? const Center(child: CircularProgressIndicator())
                            : filtered.isEmpty
                            ? const Center(
                          child: Text('Geen klassen gevonden'),
                        )
                            : ListView.separated(
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) =>
                          const Divider(height: 0),
                          itemBuilder: (context, i) {
                            final cls = filtered[i];
                            return ListTile(
                              onTap: () => _showClassStudents(cls),
                              title: Text(
                                cls.name,
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.more_vert),
                                    onPressed: () => _openClassActions(cls),
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor:
                                      const Color(0xFFFF4D4D),
                                      foregroundColor: Colors.white,
                                      padding:
                                      const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: () =>
                                        _confirmDelete(cls),
                                    child: const Text(
                                      'verwijderen',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Return-Button
          Positioned(
            bottom: 30,
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
    );
  }



  Future<void> _onAddClass() async {
    final newClassName = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => const AddClassPage(),
      ),
    );

    if (newClassName == null || newClassName.trim().isEmpty) return;

    try {
      final created = await _api.createClass(newClassName.trim());

      setState(() {
        _classes.add(created);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Klas "${created.name}" aangemaakt')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kon klas niet aanmaken: $e')),
      );
    }
  }

  void _openClassActions(SchoolClass cls) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Klasse hernoemen'),
                onTap: () {
                  Navigator.pop(context);
                  _showRenameDialog(cls);
                },
              ),
              ListTile(
                leading: const Icon(Icons.group),
                title: const Text('Studenten beheren'),
                onTap: () {
                  Navigator.pop(context);
                  _showEditStudentsSheet(cls);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  'Klasse verwijderen',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDelete(cls);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showRenameDialog(SchoolClass cls) {
    final ctrl = TextEditingController(text: cls.name);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Klasse hernoemen'),
          content: TextField(
            controller: ctrl,
            decoration:
            const InputDecoration(hintText: 'Nieuwe naam'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final newName = ctrl.text.trim();
                if (newName.isEmpty || newName == cls.name) {
                  Navigator.pop(context);
                  return;
                }

                try {
                  await _api.renameClass(cls.id, newName);

                  setState(() {
                    _classes = _classes
                        .map((c) => c.id == cls.id
                        ? SchoolClass(id: c.id, name: newName)
                        : c)
                        .toList();
                  });

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                        Text('Klas hernoemd naar "$newName"')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                        Text('Kon klas niet hernoemen: $e')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(SchoolClass cls) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Klas verwijderen?'),
          content: Text(
            'Weet je zeker dat je "${cls.name}" wilt verwijderen?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuleer'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);

                try {
                  await _api.deleteClass(cls.id);

                  setState(() {
                    _classes.removeWhere((c) => c.id == cls.id);
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                        Text('Klas "${cls.name}" verwijderd')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                        Text('Kon klas niet verwijderen: $e')),
                  );
                }
              },
              child: const Text(
                'Verwijder',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
  Future<void> _showEditStudentsSheet(SchoolClass cls) async {
    try {
      // 1. alle User laden
      final users = await _api.getUsers(); // diese Methode hast du ja für AddClass
      final allStudents =
      users.where((u) => u.role == Role.student).toList();

      // 2. Schüler, die bereits in dieser Klasse sind (Backend-API anpassen!)
      final currentStudentIds = await _api.getClassStudents(cls.id);
      List<User> selectedStudents = allStudents
          .where((u) => currentStudentIds.contains(u.id))
          .toList();

      User? selectedDropdownStudent;

      // 3. Bottom Sheet mit StatefulBuilder für lokale UI-States
      // ignore: use_build_context_synchronously
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (ctx) {
          return StatefulBuilder(
            builder: (ctx, setModalState) {
              String fullName(User u) {
                if (u.middlename != null &&
                    u.middlename!.trim().isNotEmpty) {
                  return '${u.firstname} ${u.middlename} ${u.lastname}';
                }
                return '${u.firstname} ${u.lastname}';
              }

              final availableStudents = allStudents
                  .where((s) =>
              !selectedStudents.any((sel) => sel.id == s.id))
                  .toList();

              return Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Studenten in "${cls.name}"',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),

                    const Text(
                      'Student toevoegen:',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),

                    Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButton<User>(
                        isExpanded: true,
                        value: selectedDropdownStudent,
                        underline: const SizedBox(),
                        hint: const Text('Selecteer een student'),
                        items: availableStudents
                            .map(
                              (s) => DropdownMenuItem<User>(
                            value: s,
                            child: Text(fullName(s)),
                          ),
                        )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setModalState(() {
                              selectedStudents.add(value);
                              selectedDropdownStudent = null;
                            });
                          }
                        },
                      ),
                    ),

                    const SizedBox(height: 14),

                    if (selectedStudents.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Studenten in deze klas:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: selectedStudents.map((s) {
                              return Chip(
                                label: Text(fullName(s)),
                                deleteIcon: const Icon(Icons.close),
                                onDeleted: () {
                                  setModalState(() {
                                    selectedStudents.removeWhere(
                                            (u) => u.id == s.id);
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ),

                    const SizedBox(height: 18),

                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            final ids = selectedStudents
                                .map((u) => u.id)
                                .toList();
                            await _api.updateClassStudents(
                                cls.id, ids);

                            // ignore: use_build_context_synchronously
                            Navigator.of(ctx).pop();
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                  Text('Klasse bijgewerkt')),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Kon klas niet bijwerken: $e'),
                              ),
                            );
                          }
                        },
                        child: const Text('Opslaan'),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kon studenten niet laden: $e')),
      );
    }
  }
  Future<void> _showClassStudents(SchoolClass cls) async {
    try {
      // 1. Alle User laden
      final users = await _api.getUsers();
      final allStudents =
      users.where((u) => u.role == Role.student).toList();

      // 2. IDs der Schüler, die zu dieser Klasse gehören
      final studentIds = await _api.getClassStudents(cls.id);

      // 3. Liste der User-Objekte für diese Klasse
      List<User> classStudents = allStudents
          .where((u) => studentIds.contains(u.id))
          .toList();

      // 4. BottomSheet anzeigen
      // ignore: use_build_context_synchronously
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (ctx) {
          return StatefulBuilder(
            builder: (ctx, setModalState) {
              String fullName(User u) {
                if (u.middlename != null &&
                    u.middlename!.trim().isNotEmpty) {
                  return '${u.firstname} ${u.middlename} ${u.lastname}';
                }
                return '${u.firstname} ${u.lastname}';
              }

              return Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Studenten in "${cls.name}"',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),

                    if (classStudents.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          'Geen studenten aan deze klas gekoppeld.',
                        ),
                      )
                    else
                      Flexible(
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: classStudents.length,
                          separatorBuilder: (_, __) =>
                          const Divider(height: 0),
                          itemBuilder: (context, index) {
                            final student = classStudents[index];
                            return ListTile(
                              title: Text(fullName(student)),
                              subtitle: Text(student.email),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.remove_circle,
                                  color: Colors.red,
                                ),
                                onPressed: () async {

                                  setModalState(() {
                                    classStudents.removeAt(index);
                                  });


                                  final newIds = classStudents
                                      .map((u) => u.id)
                                      .toList();
                                  try {
                                    await _api.updateClassStudents(
                                        cls.id, newIds);
                                  } catch (e) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Kon student niet verwijderen: $e',
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      ),

                    const SizedBox(height: 12),
                  ],
                ),
              );
            },
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kon studenten niet laden: $e')),
      );
    }
  }


}
