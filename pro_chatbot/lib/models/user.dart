enum Role {
  admin,
  teacher,
  student,
}

extension RoleExtension on Role {
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

class School {
  int id;
  String name;
  String zipCode;
  String streetName;
  String houseNumber;
  String town;

  School({
    required this.id,
    required this.name,
    required this.zipCode,
    required this.streetName,
    required this.houseNumber,
    required this.town,
  });

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

class SchoolClass {
  int id;
  String name;

  SchoolClass({
    required this.id,
    required this.name,
  });

  factory SchoolClass.fromJson(Map<String, dynamic> json) {
    return SchoolClass(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class User {
  final int id;
  final String email;
  final String firstname;
  final String lastname;
  final String? middlename;
  final Role role;
  final int? classId;

  bool online = false;

  SchoolClass? schoolClass;
  School? school;

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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstname': firstname,
      'lastname': lastname,
      'middlename': middlename,
      'role': role.toString().split('.').last,
      'school': school?.toJson(),
      'class': schoolClass?.toJson(),
    };
  }

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
