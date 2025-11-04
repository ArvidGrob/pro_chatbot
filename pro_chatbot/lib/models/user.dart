class User {
  final int id;
  final String email;
  final String firstname;
  final String lastname;
  final String middlename;

  User({
    required this.id,
    required this.email,
    required this.firstname,
    required this.lastname,
    required this.middlename,
  });

  // Convert JSON to User object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      middlename: json['middlename'],
    );
  }

  String get fullName => '$firstname $middlename $lastname';
}
