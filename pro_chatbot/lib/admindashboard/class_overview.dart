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

  static const primaryColor = Color(0xFF3D4ED8);

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
      _toast('Fout bij het laden van de klassen: $e', success: false);
    }
  }

  @override
  void dispose() {
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

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final query = _searchCtrl.text.trim().toLowerCase();
    final filtered = query.isEmpty
        ? _classes
        : _classes.where((c) => c.name.toLowerCase().contains(query)).toList();

    return WaveBackgroundLayout(
      backgroundColor: themeManager.backgroundColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 16),

              // Header
              const Center(
                child: Text(
                  'Klas overzicht',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Add class button
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

              // Container with title + search + list
              Expanded(
                child: Container(
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

                      // Title
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Klassen',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Search field
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: TextField(
                          controller: _searchCtrl,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            hintText: 'Een klas zoeken...',
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

                      // Class list
                      Expanded(
                        child: _loading
                            ? const Center(child: CircularProgressIndicator())
                            : filtered.isEmpty
                                ? const Center(
                                    child: Text('Geen klassen gevonden'))
                                : ListView.separated(
                                    itemCount: filtered.length,
                                    separatorBuilder: (_, __) => const Divider(
                                        height: 0, thickness: 0.4),
                                    itemBuilder: (context, i) {
                                      final cls = filtered[i];
                                      return ListTile(
                                        title: Text(
                                          cls.name,
                                          style: const TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        trailing: IconButton(
                                          icon: const Icon(Icons.more_vert),
                                          onPressed: () =>
                                              _openClassActions(cls),
                                        ),
                                      );
                                    },
                                  ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Return button
              GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
                child: SizedBox(
                  width: 70,
                  height: 70,
                  child: Image.asset(
                    'assets/images/return.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===== Actions =====

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

      _toast('Klas "${created.name}" aangemaakt');
    } catch (e) {
      _toast('Kon klas niet aanmaken: $e', success: false);
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
                title: const Text('Klas hernoemen'),
                onTap: () {
                  Navigator.pop(context);
                  _showRenameDialog(cls);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  'Klas verwijderen',
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
            decoration: const InputDecoration(hintText: 'Nieuwe naam'),
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
                  _toast('Klas hernoemd naar "$newName"');
                } catch (e) {
                  _toast('Kon klas niet hernoemen: $e', success: false);
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
          content: Text('Weet je zeker dat je "${cls.name}" wilt verwijderen?'),
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
                  _toast('Klas "${cls.name}" verwijderd');
                } catch (e) {
                  _toast('Kon klas niet verwijderen: $e', success: false);
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
}
