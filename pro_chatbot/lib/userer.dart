enum Role {
  admin,
  teacher,
  student,
}

class User {
  final String id; // Automatically generated
  final String name; // First Name and Last Name
  final String email;
  final String password;
  final Role role; // Admin, Teacher, Student

  User({
    required this.id, // Automatically generated
    required this.name, // First Name and Last Name
    required this.email,
    required this.password,
    required this.role, // Admin, Teacher, Student
  });
}
