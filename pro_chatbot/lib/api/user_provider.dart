import 'package:flutter/material.dart';
import 'user.dart';

class UserProvider extends ChangeNotifier {
  User? _currentUser;

  /// Returns the currently logged-in user (or null if not logged in)
  User? get currentUser => _currentUser;

  /// Returns true if a user is logged in
  bool get isLoggedIn => _currentUser != null;

  /// Logs in a user (for example, after successful authentication)
  void login(User user) {
    _currentUser = user;
    notifyListeners(); // notifies the UI that the state has changed
  }

  /// Logs out the user
  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  /// Checks if the user has a specific role
  bool hasRole(Role role) {
    return _currentUser?.role == role;
  }

  /// Checks if the user has any of the given roles
  bool hasAnyRole(List<Role> roles) {
    return _currentUser != null && roles.contains(_currentUser!.role);
  }
}
