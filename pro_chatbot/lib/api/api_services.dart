import 'dart:convert';
import 'package:http/http.dart' as http;
import '/models/user.dart';

class ApiService {
  static const String baseUrl = 'https://chatbot.duonra.nl';

  Future<User> login(String email, String password) async {
    try {
      final url = Uri.parse('$baseUrl/api/login');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data);
      } else if (response.statusCode == 401) {
        throw Exception('Ongeldige inloggegevens');
      } else if (response.statusCode == 400) {
        throw Exception('E-mail en wachtwoord zijn verplicht');
      } else {
        throw Exception('Server fout. Probeer het later opnieuw.');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Kan geen verbinding maken met de server');
    }
  }

  Future<User> createStudent({
    required String firstname,
    String? middlename,
    required String lastname,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/api/users');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'firstname': firstname,
        'middlename': middlename,
        'lastname': lastname,
        'email': email,
        'password': password,
        'role': 'student',
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final int userId = data['id'];

      return User(
        id: userId,
        firstname: firstname,
        middlename: middlename,
        lastname: lastname,
        email: email,
        role: Role.student,
      );
    } else if (response.statusCode == 409) {
      // Only show email duplicate message
      throw Exception('E-mail bestaat al');
    } else {
      // Generic message for other errors
      throw Exception('Het is niet gelukt om de student aan te maken');
    }
  }

  Future<List<User>> fetchStudents() async {
    final url = Uri.parse('$baseUrl/api/users');
    final response =
        await http.get(url, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      final students = data
          .map((json) => User.fromJson(json))
          .where((u) => u.role == Role.student)
          .toList();
      return students;
    } else {
      throw Exception('Het is niet gelukt om studenten op te halen.');
    }
  }
}
