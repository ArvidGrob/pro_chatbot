import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/theme_manager.dart';
import '/wave_background_layout.dart';
import '../models/user.dart';
import '../api/user_provider.dart';
import '/api/api_services.dart';
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
  static const Color primaryBlue = Color(0xFF4A4AFF);

  User? user;
  bool _loading = true;
  final ApiService api = ApiService();

  @override
  void initState() {
    super.initState();
    _loadUserSchool();
  }

  Future<void> _loadUserSchool() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.currentUser != null) {
      user = userProvider.currentUser!;
      if (user!.school != null) {
        setState(() => _loading = false);
      } else {
        try {
          final school = await api.fetchUserSchool(user!.id);
          setState(() {
            user!.school = school;
            _loading = false;
          });
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
        const SnackBar(content: Text('School succesvol bijgewerkt')),
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
      builder: (context) => AlertDialog(
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
            child: const Text('Annuleren'),
          ),
          ElevatedButton(
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
            child: const Text('Opslaan'),
          ),
        ],
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Schoolinformatie',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: primaryBlue,
                  ),
                ),
                const SizedBox(height: 20),
                if (user?.school != null)
                  Container(
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Naam: ${user!.school!.name}'),
                        Text('Postcode: ${user!.school!.zipCode}'),
                        Text('Straat: ${user!.school!.streetName}'),
                        Text('Huisnummer: ${user!.school!.houseNumber}'),
                        Text('Stad: ${user!.school!.town}'),
                        const SizedBox(height: 12),
                        Center(
                          child: ElevatedButton(
                            onPressed: () => _showEditDialog(user!),
                            child: const Text('Wijzig school'),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
