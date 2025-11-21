import 'package:flutter/material.dart';
import 'package:pro_chatbot/admindashboard/class_overview.dart';
import 'package:pro_chatbot/api/api_services.dart';
import 'addteacher.dart';
import 'school_overview.dart';
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
          allowedRoles: [Role.admin],
          child: TeacherOverviewPage(),
        ),
      ),
    ),
  );
}

class TeacherOverviewPage extends StatefulWidget {
  const TeacherOverviewPage({super.key});

  @override
  State<TeacherOverviewPage> createState() => _TeacherOverviewPageState();
}

class _TeacherOverviewPageState extends State<TeacherOverviewPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  late Future<List<User>> _usersFuture; // Teachers and admins

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  void _fetchUsers() {
    final api = ApiService();
    _usersFuture = api.fetchTeachersAndAdmins();
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

    return WaveBackgroundLayout(
      backgroundColor: themeManager.backgroundColor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                    child: Center(
                      child: const Text(
                        'Principal overzicht',
                        style: TextStyle(
                          color: Color(0xFF1A2B8F),
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // School tile
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: _bigTile(
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
                  ),
                  const SizedBox(height: 24),

                  // Add teacher button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 42,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(
                                MaterialPageRoute(
                                  builder: (_) => const AddTeacherPage(),
                                ),
                              )
                              .then(
                                  (_) => setState(_fetchUsers)); // Refresh list
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
                          'Leraar toevoegen',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

// Teacher/Admin list
                  Flexible(
                    flex: 6, // reduced from 8 to make container smaller
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 8),
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
                                'Recente Docenten / Admins',
                                style: TextStyle(
                                  color: Color(0xFF1A2B8F),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Search field
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: TextField(
                                controller: _searchCtrl,
                                onChanged: (_) => setState(() {}),
                                decoration: InputDecoration(
                                  hintText: 'Een docent zoeken',
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
                            ),
                            const SizedBox(height: 6),
                            const Divider(height: 0),
                            // List
                            Flexible(
                              // changed from Expanded
                              child: FutureBuilder<List<User>>(
                                future: _usersFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(
                                      child: Text(
                                        'Fout bij het ophalen: ${snapshot.error}',
                                        textAlign: TextAlign.center,
                                      ),
                                    );
                                  }

                                  final list = snapshot.data ?? [];
                                  final query =
                                      _searchCtrl.text.trim().toLowerCase();
                                  final filtered = query.isEmpty
                                      ? list
                                      : list.where((u) {
                                          final fullName =
                                              '${u.firstname} ${u.middlename ?? ''} ${u.lastname}';
                                          return fullName
                                              .toLowerCase()
                                              .contains(query);
                                        }).toList();

                                  if (filtered.isEmpty) {
                                    return const Center(
                                      child: Text(
                                          'Geen docenten of admins gevonden'),
                                    );
                                  }

                                  return ListView.separated(
                                    itemCount: filtered.length,
                                    separatorBuilder: (_, __) =>
                                        const Divider(height: 0, thickness: .4),
                                    itemBuilder: (context, i) {
                                      final user = filtered[i];
                                      final fullName =
                                          '${user.firstname} ${user.middlename ?? ''} ${user.lastname}'
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
                                          user.role == Role.admin
                                              ? 'Admin'
                                              : 'Teacher',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        trailing: IconButton(
                                          icon: const Icon(Icons.more_vert),
                                          onPressed: () =>
                                              _openUserActions(user),
                                        ),
                                      );
                                    },
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
              // Return button
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
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
        ),
      ),
    );
  }

  void _openUserActions(User user) {
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

  // Big tile button
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
