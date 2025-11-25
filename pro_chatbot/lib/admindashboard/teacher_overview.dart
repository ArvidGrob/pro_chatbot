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
  late Future<List<User>> _usersFuture;
  String _pressedTile = ''; // Track pressed tile for custom press effect

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  void _fetchUsers() {
    final api = ApiService();
    _usersFuture = api.fetchTeachersAndAdmins().then((users) {
      users.sort((a, b) {
        return a.firstname.toLowerCase().compareTo(b.firstname.toLowerCase());
      });
      return users;
    });
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
              SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        // Header
                        Center(
                          child: const Text(
                            'Management Overzicht',
                            style: TextStyle(
                              color: Color(0xFF1A2B8F),
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Row with School and Add Teacher buttons
                        Row(
                          children: [
                            Expanded(
                              child: _pressableTile(
                                tileId: 'school',
                                label: 'School',
                                icon: Icons.apartment_rounded,
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const SchoolOverviewPage(),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _pressableTile(
                                tileId: 'add_teacher',
                                label: 'Leraar toevoegen',
                                icon: Icons.person_add,
                                onTap: () {
                                  Navigator.of(context)
                                      .push(
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const AddTeacherPage(),
                                        ),
                                      )
                                      .then((_) => setState(_fetchUsers));
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Teacher/Admin list container
                        Container(
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
                                  'Docenten & Admins',
                                  style: TextStyle(
                                    color: Color(0xFF1A2B8F),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
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

                              // Dynamic height list
                              SizedBox(
                                height: MediaQuery.of(context).size.height *
                                    0.55, // 55% of screen
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
                                    final filtered =
                                        _searchCtrl.text.trim().isEmpty
                                            ? list
                                            : list.where((u) {
                                                final fullName =
                                                    '${u.firstname} ${u.middlename ?? ''} ${u.lastname}';
                                                return fullName
                                                    .toLowerCase()
                                                    .contains(_searchCtrl.text
                                                        .trim()
                                                        .toLowerCase());
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
                                          const Divider(
                                              height: 0, thickness: .4),
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
                        const SizedBox(
                            height: 100), // spacing for bottom button
                      ],
                    ),
                  ),
                ),
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

  // Pressable tile with darken-on-press effect
  Widget _pressableTile({
    required String tileId,
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    bool isPressed = _pressedTile == tileId;
    final Color primaryColor = isPressed
        ? const Color(0xFF4F54D9).withOpacity(0.85)
        : const Color(0xFF6F73FF);

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressedTile = tileId),
      onTapUp: (_) {
        setState(() => _pressedTile = '');
        onTap();
      },
      onTapCancel: () => setState(() => _pressedTile = ''),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: primaryColor,
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
