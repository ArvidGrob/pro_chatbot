import 'package:flutter/material.dart';
import 'student_store.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student creator',
      home: const StudentCreatorPage(),
    );
  }
}
class StudentCreatorPage extends StatefulWidget {
  const StudentCreatorPage({super.key});

  @override
  State<StudentCreatorPage> createState() => _StudentCreatorPageState();
}

class _StudentCreatorPageState extends State<StudentCreatorPage> {
  static const primary = Color(0xFF6464FF);

  final TextEditingController _searchCtrl = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  bool _showPopup = false;

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(_onSearchChanged);
    _searchFocus.addListener(() {
      setState(() => _showPopup = _searchFocus.hasFocus && _searchCtrl.text.isNotEmpty);
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
    // hide already-added names
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

  @override
  Widget build(BuildContext context) {
    final results = _results();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'Beheer',
          style: TextStyle(
            color: primary,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Blue segmented "Student" header bar
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

              // Section title "Student"
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 6, 16, 6),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Student',
                    style: TextStyle(
                      color: primary,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),

              // Search field
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                child: TextField(
                  controller: _searchCtrl,
                  focusNode: _searchFocus,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Een student zoeken',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.manage_search_outlined),
                      onPressed: () => _onSearchChanged(),
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
              ),

              const Divider(height: 0),

              // Current student list (auto-updates)
              Expanded(
                child: ValueListenableBuilder<List<Student>>(
                  valueListenable: StudentStore.instance.students,
                  builder: (context, list, _) {
                    if (list.isEmpty) {
                      return const Center(child: Text('Nog geen studenten.'));
                    }
                    return ListView.separated(
                      itemCount: list.length,
                      separatorBuilder: (_, __) => const Divider(height: 0),
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
                              StudentStore.instance.removeByName(s.name);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Verwijderd: ${s.name}')),
                              );
                            },
                            child: const Text('verwijder'),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),

          // Search pop-up below the search bar
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
    );
  }
}
