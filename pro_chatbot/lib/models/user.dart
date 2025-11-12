class User {
  final int id;
  final String email;
  final String firstname;
  final String lastname;
  final String? middlename;
  final String role;

  User({
    required this.id,
    required this.email,
    required this.firstname,
    required this.lastname,
    this.middlename,
    required this.role,
  });

  // Convert JSON to User object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      middlename: json['middlename'],
      email: json['email'],
      role: json['role'],
    );
  }

  // String get fullName => '$firstname $middlename $lastname';
}
