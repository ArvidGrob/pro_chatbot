import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/api/user_provider.dart';
import '/models/user.dart';
import '/login/login_page.dart';
import '../access_denied_page.dart';

/// A reusable widget that guards pages based on user authentication and roles.
class AuthGuard extends StatelessWidget {
  /// The page to show if the user is allowed
  final Widget child;

  /// Roles allowed to access this page
  final List<Role> allowedRoles;

  const AuthGuard({
    Key? key,
    required this.child,
    required this.allowedRoles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    // User not logged in → redirect to login page
    if (!userProvider.isLoggedIn) {
      // Ensure Navigator runs after the current frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      });

      // Show a loading indicator while redirecting
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // User logged in but role not allowed → show access denied page
    if (!userProvider.hasAnyRole(allowedRoles)) {
      return const AccessDeniedPage();
    }

    // User is allowed → show requested page
    return child;
  }
}
