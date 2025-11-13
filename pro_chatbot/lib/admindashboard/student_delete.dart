import 'package:flutter/material.dart';
import 'student_store.dart';
import 'package:provider/provider.dart';
import '/theme_manager.dart';
import '/wave_background_layout.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeManager(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student creator',
      home: const StudentDeletePage(),
    );
  }
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

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(_onSearchChanged);
    _searchFocus.addListener(() {
      setState(() =>
          _showPopup = _searchFocus.hasFocus && _searchCtrl.text.isNotEmpty);
    });
  }

  @override
  void dispose() {
    _searchCtrl.removeListener(_onSearchChanged);
    _searchCtrl.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _showPopup = _searchFocus.hasFocus && _searchCtrl.text.trim().isNotEmpty;
    });
  }

  List<String> _results() {
    final q = _searchCtrl.text.trim().toLowerCase();
    if (q.isEmpty) return const [];
    final store = StudentStore.instance;
    return store.directory
        .where((n) => n.toLowerCase().contains(q))
        .where((n) => !store.containsName(n))
        .toList();
  }

  void _add(String name) {
    StudentStore.instance.addByName(name);
    _searchCtrl.clear();
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Toegevoegd: $name')),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String name) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Bevestiging'),
          content: Text('Weet je zeker dat je $name wilt verwijderen?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Annuleren'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                StudentStore.instance.removeByName(name);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Verwijderd: $name')),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Verwijderen'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final results = _results();

    return WaveBackgroundLayout(
      backgroundColor: themeManager.backgroundColor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 16),

                  // Title centered
                  const Center(
                    child: Text(
                      'Beheer',
                      style: TextStyle(
                        color: primary,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Blue "Student" header bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6F73FF),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.12),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.school_rounded, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Student',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Search field
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                    child: TextField(
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
                  ),

                  // Current student list in white container
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Container(
                      constraints: const BoxConstraints(
                        maxHeight: 380, // Limite la hauteur de la bulle
                      ),
                      padding: const EdgeInsets.all(8),
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
                      child: ValueListenableBuilder<List<Student>>(
                        valueListenable: StudentStore.instance.students,
                        builder: (context, list, _) {
                          if (list.isEmpty) {
                            return const Center(
                                child: Text('Nog geen studenten.'));
                          }
                          return ListView.separated(
                            itemCount: list.length,
                            separatorBuilder: (_, __) =>
                                const Divider(height: 0),
                            itemBuilder: (context, i) {
                              final s = list[i];
                              return ListTile(
                                title: Text(
                                  s.name,
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                trailing: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: const Color(0xFFFF4D4D),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  onPressed: () {
                                    _showDeleteConfirmation(context, s.name);
                                  },
                                  child: const Text('verwijder'),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),

                  const Spacer(), // Espace flexible
                ],
              ),

              // Bouton retour en bas centré
              Positioned(
                bottom: 20,
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

              // Search popup
              if (_showPopup && results.isNotEmpty)
                Positioned(
                  top: 158,
                  left: 12,
                  right: 12,
                  child: Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      constraints: const BoxConstraints(maxHeight: 260),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: results.length,
                        separatorBuilder: (_, __) =>
                            const Divider(height: 0, thickness: .6),
                        itemBuilder: (context, i) {
                          final name = results[i];
                          return ListTile(
                            title: Text(name),
                            trailing: ElevatedButton(
                              onPressed: () => _add(name),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4CAF50),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              child: const Text('add'),
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
    );
  }
}
