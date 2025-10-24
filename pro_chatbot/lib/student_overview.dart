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
      title: 'Students',
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          'Studentenoverzicht',
          style: TextStyle(
            color: primary,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
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
                    ? const Icon(Icons.manage_search_outlined)
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
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const Divider(height: 0),

          Expanded(
            child: ValueListenableBuilder<List<Student>>(
              valueListenable: StudentStore.instance.students,
              builder: (context, list, _) {
                final q = _searchCtrl.text.trim().toLowerCase();
                final filtered = q.isEmpty
                    ? list
                    : list.where((s) => s.name.toLowerCase().contains(q)).toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text('Geen studenten gevonden'));
                }

                return ListView.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const Divider(height: 0),
                  itemBuilder: (context, i) {
                    final s = filtered[i];
                    return ListTile(
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      title: Text(
                        s.name,
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: Text(
                        s.online ? 'Online' : 'Offline',
                        style: TextStyle(
                          color: s.online ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      onTap: () {
                        // Demo: toggle status on tap
                        final newStatus = !s.online;
                        StudentStore.instance.setStatus(s.name, newStatus);
                      },
                    );
                  },
                );
              },
            ),
          ),
          // Return button
          Center(
            child: _buildReturnButton(
              buttonId: 'return',
              iconPath: 'assets/images/return.png',
              onTap: () {
                print('Return tapped');
              },
            ),
          ),
        ],
      ),
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
