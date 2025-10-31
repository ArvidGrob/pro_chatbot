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

  // Mock-Klassen – später durch echten Store ersetzen
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
          // Hintergrund
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

                  // searchfield
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
                        // Navigiere zur Add-Class-Seite
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const AddClassPage(),
                          ),
                        );
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

                  // Liste all classes
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
                            trailing: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFFFF4D4D),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  _classes.remove(cls);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Removed: $cls')),
                                );
                              },
                              child: const Text(
                                'remove',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            onTap: () {
                              //  "class detail"
                            },
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
}
