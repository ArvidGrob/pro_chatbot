import 'package:flutter/material.dart';
import 'addteacher.dart';
import 'school_overview.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Teachers',
      home: const TeacherOverviewPage(),
    );
  }
}

class TeacherOverviewPage extends StatefulWidget {
  const TeacherOverviewPage({super.key});

  @override
  State<TeacherOverviewPage> createState() => _TeacherOverviewPageState();
}

class _TeacherOverviewPageState extends State<TeacherOverviewPage> {
  final TextEditingController _searchCtrl = TextEditingController();

  final List<String> _teachers = [
    'Daan de Vries',
    'Sanne Janssen',
    'Fleur van Dijk',
    'Tim Visser',
    'Bram Meijer',
    'Lotte Smit',
    'Eva Mulder',
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
        ? _teachers
        : _teachers
        .where((t) => t.toLowerCase().contains(query))
        .toList();

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header mit Back + Titel
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Image.asset(
                          'assets/images/return.png',
                          width: 46,
                          height: 46,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Admin View',
                        style: TextStyle(
                          color: Color(0xFF1A2B8F),
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          shadows: [
                            Shadow(
                              offset: Offset(0, 2),
                              blurRadius: 4,
                              color: Colors.black26,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Zwei große Kacheln: Leerkracht / School
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      _bigTile(
                        label: 'Leerkracht',
                        icon: Icons.school_rounded,
                        onTap: () {
                          // optional: hier könntest du später andere Funktionen öffnen
                        },
                      ),
                      const SizedBox(height: 14),
                      _bigTile(
                        label: 'School',
                        icon: Icons.apartment_rounded,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const SchoolOverviewPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Add teacher button (dein Wunsch)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 42,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const AddTeacherPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6F73FF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 6,
                      ),
                      child: const Text(
                        'Add teacher',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // Weißes Panel mit Suche + Liste
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                          const SizedBox(height: 10),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              'Recente Docenten',
                              style: TextStyle(
                                color: Color(0xFF1A2B8F),
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Suchfeld
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                            ),
                            child: TextField(
                              controller: _searchCtrl,
                              onChanged: (_) => setState(() {}),
                              decoration: InputDecoration(
                                hintText: 'Een docent zoeken',
                                prefixIcon: const Icon(Icons.search),
                                suffixIcon: const Icon(Icons.manage_search_outlined),
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
                          ),
                          const SizedBox(height: 6),
                          const Divider(height: 0),

                          // Liste
                          Expanded(
                            child: ListView.separated(
                              itemCount: filtered.length,
                              separatorBuilder: (_, __) =>
                              const Divider(height: 0, thickness: .4),
                              itemBuilder: (context, i) {
                                final name = filtered[i];
                                return ListTile(
                                  title: Text(
                                    name,
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
                                        horizontal: 12,
                                        vertical: 4,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _teachers.remove(name);
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Verwijderd: $name'),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'verwijder',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                );
                              },
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
        ],
      ),
    );
  }

  // Großer Kachel-Button oben
  Widget _bigTile({
    required String label,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF6F73FF),
              Color(0xFF4F54D9),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
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
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Spacer(),
            Icon(
              icon,
              color: Colors.white,
              size: 34,
            ),
          ],
        ),
      ),
    );
  }
}
