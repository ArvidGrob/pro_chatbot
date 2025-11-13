/*
// all the roles within the organisation
enum Role {
  admin,
  teacher,
  student,
}

// all rows in the database prochatbot
class User {
  final int id;
  final String name;
  final String firstname;
  final String middlename;
  final String lastname;
  final String email;
  final Role role;

  User({
    required this.id,
    required this.name,
    required this.firstname,
    required this.middlename,
    required this.lastname,
    required this.email,
    required this.role,
  });

// Factory to create a User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      firstname: json['firstname'],
      middlename: json['middlename'] ?? '',
      lastname: json['lastname'],
      email: json['email'],
      role: Role.values
          .firstWhere((r) => r.toString().split('.').last == json['role']),
    );
  }
}
*/
