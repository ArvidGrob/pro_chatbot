import 'package:flutter/material.dart';
import 'user.dart';

class UserProvider extends ChangeNotifier {
  User? _currentUser;

  /// Currently logged-in user (null if not logged in)
  User? get currentUser => _currentUser;

  /// True if a user is logged in
  bool get isLoggedIn => _currentUser != null;

  /// Logs in a user
  void login(User user) {
    _currentUser = user;
    notifyListeners();
  }

  /// Logs out the user
  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  /// Updates current user info
  void updateUser(User user) {
    _currentUser = user;
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
