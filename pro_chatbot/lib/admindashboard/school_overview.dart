import 'package:flutter/material.dart';
import 'package:pro_chatbot/admindashboard/teacher_overview.dart';
import 'package:provider/provider.dart';
import '/theme_manager.dart';
import '/wave_background_layout.dart';
import '../models/user.dart';
import '../api/user_provider.dart';
import '/api/api_services.dart';
import '/api/auth_guard.dart';
import '../models/school_statistics.dart';
import 'dart:async';

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
          child: SchoolOverviewPage(),
        ),
      ),
    ),
  );
}

class SchoolOverviewPage extends StatefulWidget {
  const SchoolOverviewPage({super.key});

  @override
  State<SchoolOverviewPage> createState() => _SchoolOverviewPageState();
}

class _SchoolOverviewPageState extends State<SchoolOverviewPage> {
  static const Color primaryBlue = Color(0xFF6464FF);

  User? user;
  bool _loading = true;
  final ApiService api = ApiService();

  // Statistics
  SchoolStatistics? _statistics;
  bool _loadingStats = true;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _loadUserSchool();
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  /// Auto-refresh statistics every 30 seconds
  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (user?.school != null) {
        _loadStatistics();
      }
    });
  }

  Future<void> _loadStatistics() async {
    if (user?.school == null) return;

    try {
      final stats = await api.getSchoolStatistics(user!.school!.id);
      if (mounted) {
        setState(() {
          _statistics = stats;
          _loadingStats = false;
        });
      }
    } catch (e) {
      print('Error loading statistics: $e');
      if (mounted) {
        setState(() => _loadingStats = false);
      }
    }
  }

  Future<void> _loadUserSchool() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.currentUser != null) {
      user = userProvider.currentUser!;
      if (user!.school != null) {
        setState(() => _loading = false);
        _loadStatistics(); // Load statistics after school is loaded
      } else {
        try {
          final school = await api.fetchUserSchool(user!.id);
          setState(() {
            user!.school = school;
            _loading = false;
          });
          _loadStatistics(); // Load statistics after school is loaded
        } catch (e) {
          setState(() => _loading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Kon school niet ophalen: $e')),
          );
        }
      }
    }
  }

  Future<void> _updateSchool(School updatedSchool) async {
    try {
      await api.updateSchool(updatedSchool);
      setState(() {
        user!.school = updatedSchool;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'School is succesvol bijgewerkt naar ${updatedSchool.name}, ${updatedSchool.zipCode} ${updatedSchool.streetName} ${updatedSchool.houseNumber}, ${updatedSchool.town}',
          ),
          backgroundColor: const Color(0xFF018F6F),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kon school niet bijwerken: $e')),
      );
    }
  }

  void _showEditDialog(User user) {
    final nameCtrl = TextEditingController(text: user.school?.name ?? '');
    final zipCtrl = TextEditingController(text: user.school?.zipCode ?? '');
    final streetCtrl =
        TextEditingController(text: user.school?.streetName ?? '');
    final houseCtrl =
        TextEditingController(text: user.school?.houseNumber ?? '');
    final townCtrl = TextEditingController(text: user.school?.town ?? '');

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: const Text('Wijzig schoolinformatie'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _dialogField('Naam', nameCtrl),
                _dialogField('Postcode', zipCtrl),
                _dialogField('Straat', streetCtrl),
                _dialogField('Huisnummer', houseCtrl),
                _dialogField('Stad', townCtrl),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(const Color(0xFFFF4D4D)),
              ),
              child: const Text(
                'Annuleren',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.pressed)) {
                    return const Color(0xFF018F6F);
                  }
                  return const Color(0xFF01BA8F);
                }),
              ),
              onPressed: () {
                final updatedSchool = School(
                  id: user.school?.id ?? 0,
                  name: nameCtrl.text.trim(),
                  zipCode: zipCtrl.text.trim(),
                  streetName: streetCtrl.text.trim(),
                  houseNumber: houseCtrl.text.trim(),
                  town: townCtrl.text.trim(),
                );
                _updateSchool(updatedSchool);
                Navigator.of(context).pop();
              },
              child: const Text(
                'Opslaan',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dialogField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return WaveBackgroundLayout(
      backgroundColor: themeManager.backgroundColor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Schoolinformatie',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: primaryBlue,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                if (user?.school != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Naam: ${user!.school!.name}'),
                        Text('Postcode: ${user!.school!.zipCode}'),
                        Text('Straat: ${user!.school!.streetName}'),
                        Text('Huisnummer: ${user!.school!.houseNumber}'),
                        Text('Stad: ${user!.school!.town}'),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith(
                                (states) =>
                                    states.contains(MaterialState.pressed)
                                        ? const Color(0xFF4A4AEE)
                                        : primaryBlue),
                          ),
                          onPressed: () => _showEditDialog(user!),
                          child: const Text(
                            'Wijzig school',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 20),
                // Three statistics containers
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: _infoContainer(
                              'Aantal logins',
                              _loadingStats
                                  ? 'Laden...'
                                  : '${_statistics?.totalLogins ?? 0} logins',
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: _infoContainer(
                              'Aantal vragen',
                              _loadingStats
                                  ? 'Laden...'
                                  : _statistics?.formattedQuestions ??
                                      '0 vragen',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: _infoContainer(
                        'Gebruikstijd alle gebruikers',
                        _loadingStats
                            ? 'Laden...'
                            : _statistics?.formattedDuration ?? '0 uur',
                      ),
                    ),
                  ],
                ),
                const Spacer(),

                // Return button (to SettingsPage - Custom made image)
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TeacherOverviewPage(),
                        ),
                      );
                    },
                    child: Image.asset(
                      'assets/images/return.png',
                      width: 70,
                      height: 70,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoContainer(String title, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: primaryBlue,
            ),
          ),
        ],
      ),
    );
  }
}
