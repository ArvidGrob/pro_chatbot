enum Role {
  admin,
  teacher,
  student,
}

class User {
  final int id;
  final String email;
  final String firstname;
  final String lastname;
  final String? middlename;
  final Role role;

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
      role:
          Role.values.firstWhere((r) => r.toString() == 'Role.${json['role']}'),
    );
  }
  User copyWith({
    int? id,
    String? email,
    String? firstname,
    String? lastname,
    String? middlename,
    Role? role,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      middlename: middlename ?? this.middlename,
      role: role ?? this.role,
    );
  }
}
