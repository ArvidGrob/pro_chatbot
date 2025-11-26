enum Role {
  admin,
  teacher,
  student,
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

class User {
  final int id;
  final String email;
  final String firstname;
  final String lastname;
  final String? middlename;
  final Role role;

  bool online = false;

  School? school; // WE NEED THIS FOR ALL USERS!

  User({
    required this.id,
    required this.email,
    required this.firstname,
    required this.lastname,
    this.middlename,
    required this.role,
    this.school,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      middlename: json['middlename'],
      email: json['email'],
      role:
          Role.values.firstWhere((r) => r.toString() == 'Role.${json['role']}'),
      school: json['school'] != null
          ? School.fromJson(json['school'])
          : null, // parse school
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
