import 'package:flutter/material.dart';
import 'add_class.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'School',
      home: const ClassOverviewPage(),
    );
  }
}

class ClassOverviewPage extends StatefulWidget {
  const ClassOverviewPage({super.key});

  @override
  State<ClassOverviewPage> createState() => _ClassOverviewPageState();
}

class _ClassOverviewPageState extends State<ClassOverviewPage> {
  static const Color primary = Color(0xFF4A4AFF);

  final TextEditingController _searchCtrl = TextEditingController();

  List<String> _classes = [
    'Klas 1A',
    'Klas 2B',
    'Klas 3C',
    'Wiskunde groep',
    'Nederlands 5V',
    'Projectgroep ICT',
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchCtrl.text.trim().toLowerCase();
    final filtered = query.isEmpty
        ? _classes
        : _classes.where((c) => c.toLowerCase().contains(query)).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Header
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).maybePop(),
                        child: Image.asset(
                          'assets/images/return.png',
                          width: 46,
                          height: 46,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Class overview',
                        style: TextStyle(
                          color: Color(0xFF3D4ED8),
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          shadows: [
                            Shadow(
                              offset: Offset(0, 2),
                              blurRadius: 3,
                              color: Colors.black26,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // search
                  TextField(
                    controller: _searchCtrl,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Search class...',
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

                  // Add class button
                  SizedBox(
                    width: double.infinity,
                    height: 42,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final newClassName = await Navigator.of(context).push<String>(
                          MaterialPageRoute(
                            builder: (_) => const AddClassPage(),
                          ),
                        );

                        if (newClassName != null &&
                            newClassName.trim().isNotEmpty) {
                          setState(() {
                            if (!_classes.any((c) =>
                            c.toLowerCase() ==
                                newClassName.trim().toLowerCase())) {
                              _classes.add(newClassName.trim());
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Klas "$newClassName" bestaat al'),
                                ),
                              );
                            }
                          });
                        }
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add class'),
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

                  // List
                  Expanded(
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
                      child: filtered.isEmpty
                          ? const Center(
                        child: Text('No classes found'),
                      )
                          : ListView.separated(
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const Divider(
                          height: 0,
                        ),
                        itemBuilder: (context, i) {
                          final cls = filtered[i];
                          return ListTile(
                            title: Text(
                              cls,
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            // actions rechts
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
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () => _confirmDelete(cls),
                                  child: const Text(
                                    'remove',
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openClassActions(String cls) {
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
                title: const Text('Rename class'),
                onTap: () {
                  Navigator.pop(context);
                  _showRenameDialog(cls);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  'Delete class',
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

  void _showRenameDialog(String oldName) {
    final ctrl = TextEditingController(text: oldName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Rename class'),
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
              onPressed: () {
                final newName = ctrl.text.trim();
                if (newName.isEmpty) return;

                // prüfen auf Duplikat
                final exists = _classes.any((c) =>
                c.toLowerCase() == newName.toLowerCase() &&
                    c != oldName);
                if (exists) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Naam bestaat al voor een andere klas')),
                  );
                  return;
                }

                setState(() {
                  final idx = _classes.indexOf(oldName);
                  if (idx != -1) {
                    _classes[idx] = newName;
                  }
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(String cls) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Klas verwijderen?'),
          content: Text('Weet je zeker dat je "$cls" wilt verwijderen?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuleer'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _classes.remove(cls);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Removed: $cls')),
                );
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
