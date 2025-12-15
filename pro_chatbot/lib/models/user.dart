// Defines the roles a user can have in the system
enum Role {
  admin,
  teacher,
  student,
}

// Extension to add extra functionality to the Role enum
extension RoleExtension on Role {
  // Returns a readable name for each role
  String get displayName {
    switch (this) {
      case Role.admin:
        return "Admin";
      case Role.teacher:
        return "Docent";
      case Role.student:
        return "Student";
    }
  }
}

// Model representing a school entity
class School {
  int id;
  String name;
  String zipCode;
  String streetName;
  String houseNumber;
  String town;

  // Constructor for creating a School instance
  School({
    required this.id,
    required this.name,
    required this.zipCode,
    required this.streetName,
    required this.houseNumber,
    required this.town,
  });

  // Creates a School object from a JSON map
  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      id: json['id'],
      name: json['name'],
      zipCode: json['zip_code'],
      streetName: json['street_name'],
      houseNumber: json['house_number'],
      town: json['town'],
    );
  }

  // Converts a School object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'zip_code': zipCode,
      'street_name': streetName,
      'house_number': houseNumber,
      'town': town,
    };
  }
}

// Model representing a class within a school
class SchoolClass {
  int id;
  String name;

  // Constructor for creating a SchoolClass instance
  SchoolClass({
    required this.id,
    required this.name,
  });

  // Creates a SchoolClass object from a JSON map
  factory SchoolClass.fromJson(Map<String, dynamic> json) {
    return SchoolClass(
      id: json['id'],
      name: json['name'],
    );
  }

  // Converts the SchoolClass object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

// Model representing a user in the system
class User {
  final int id;
  final String email;
  final String firstname;
  final String lastname;
  final String? middlename;
  final Role role;
  final int? classId;

  // Indicates whether the user is currently online (Later implementation)
  bool online = false;

  // Related school and class objects
  SchoolClass? schoolClass;
  School? school;

  // Constructor for creating a User instance
  User({
    required this.id,
    required this.email,
    required this.firstname,
    required this.lastname,
    this.middlename,
    required this.role,
    this.school,
    this.schoolClass,
    this.classId,
  });

  // Creates a User object from a JSON map
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      middlename: json['middlename'],
      email: json['email'],
      role: Role.values.firstWhere(
        (r) => r.toString() == 'Role.${json['role']}',
      ),

      // Parse school only if object is returned
      school: json['school'] != null ? School.fromJson(json['school']) : null,

      // Parse class
      schoolClass:
          json['class'] != null ? SchoolClass.fromJson(json['class']) : null,

      // Parse classId from JSON
      classId: json['class_id'],
    );
  }

  // Converts the User object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstname': firstname,
      'lastname': lastname,
      'middlename': middlename,
      // Convert Role enum back to string for API usage
      'role': role.toString().split('.').last,
      // Include related objects only if they exist
      'school': school?.toJson(),
      'class': schoolClass?.toJson(),
    };
  }

  // Creates a copy of the User with optional overridden values
  User copyWith({
    int? id,
    String? email,
    String? firstname,
    String? lastname,
    String? middlename,
    Role? role,
    School? school,
    SchoolClass? schoolClass,
    int? classId,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      middlename: middlename ?? this.middlename,
      role: role ?? this.role,
      school: school ?? this.school,
      schoolClass: schoolClass ?? this.schoolClass,
      classId: classId ?? this.classId,
    );
  }
}
