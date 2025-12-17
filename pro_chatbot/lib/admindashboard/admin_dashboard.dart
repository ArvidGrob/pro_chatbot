import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/theme_manager.dart';
import '/wave_background_layout.dart';
import 'package:pro_chatbot/admindashboard/teacher_overview.dart';
import 'student_overview.dart';
import 'class_overview.dart';
import '../models/user.dart';
import '/api/auth_guard.dart';
import '../api/user_provider.dart';
import '../navigation/navigation_page.dart';

void main() {
  runApp(
    // Provide global state objects to the widget tree
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeManager()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        // Only admins and teachers are allowed to access this page
        home: AuthGuard(
          allowedRoles: [Role.admin, Role.teacher],
          child: AdminDashboard(),
        ),
      ),
    ),
  );
}

// page for the admin dashboard management
class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  String _pressedButton = '';

  @override
  Widget build(BuildContext context) {
    // Access theme colors
    final themeManager = Provider.of<ThemeManager>(context);
    // Get currently logged-in user
    final currentUser = Provider.of<UserProvider>(context).currentUser;

    return WaveBackgroundLayout(
      // Access theme manager for background color
      backgroundColor: themeManager.backgroundColor,
      child: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Title + Welcome Message
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Admin dashboard',
                        maxLines: 1,
                        style: TextStyle(
                          color: Color(0xFF4242BD),
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (currentUser != null)
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: const TextStyle(
                              color: Color(0xFF4242BD),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    'Hallo ${currentUser.firstname} ${currentUser.middlename} ${currentUser.lastname}, jouw rol is ',
                              ),
                              TextSpan(
                                text: currentUser.role.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold, // Role name bold
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // teachers button
                  _buildDashboardButton(
                    buttonId: 'docent',
                    label: 'Docent',
                    iconPath: 'assets/images/docent.png',
                    primaryColor: themeManager.getContainerColor(0),
                    secondaryColor: themeManager.getSecondaryContainerColor(0),
                    onTap: () {
                      final userProvider =
                          Provider.of<UserProvider>(context, listen: false);

                      if (userProvider.hasRole(Role.admin)) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const TeacherOverviewPage(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                children: [
                                  TextSpan(
                                      text:
                                          "Toegang geweigerd. Deze pagina vereist de rol "),
                                  TextSpan(
                                    text: "admin",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 3),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 25),

                  // Student button
                  _buildDashboardButton(
                    buttonId: 'student',
                    label: 'Student',
                    iconPath: 'assets/images/student.png',
                    primaryColor: themeManager.getContainerColor(1),
                    secondaryColor: themeManager.getSecondaryContainerColor(1),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const StudentOverviewPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 25),

                  // Class button
                  _buildDashboardButton(
                    buttonId: 'klas',
                    label: 'Klas',
                    iconPath: 'assets/images/beheer.png',
                    primaryColor: themeManager.getContainerColor(2),
                    secondaryColor: themeManager.getSecondaryContainerColor(2),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ClassOverviewPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 25),

                  // Return button
                  Center(
                    child: _buildReturnButton(
                      buttonId: 'return',
                      iconPath: 'assets/images/return.png',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NavigationPage(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget for dashboard buttons
  Widget _buildDashboardButton({
    required String buttonId,
    required String label,
    required String iconPath,
    required Color primaryColor,
    required Color secondaryColor,
    required VoidCallback onTap,
  }) {
    // Determine if the button is currently pressed
    bool isPressed = _pressedButton == buttonId;
    final Color displayPrimary = isPressed
        ? ThemeManager().darkenColor(primaryColor, 0.25)
        : primaryColor;
    final Color displaySecondary = isPressed
        ? ThemeManager().darkenColor(secondaryColor, 0.25)
        : secondaryColor;

    // Build the button widget
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressedButton = buttonId),
      onTapUp: (_) {
        setState(() => _pressedButton = '');
        onTap();
      },
      onTapCancel: () => setState(() => _pressedButton = ''),
      child: Container(
        height: 120,
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: displayPrimary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 10.0, bottom: 0.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: 150,
              height: 120,
              decoration: BoxDecoration(
                color: displaySecondary,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Center(
                child: Image.asset(
                  iconPath,
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for return button
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
