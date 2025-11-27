import 'dart:convert';
import 'package:http/http.dart' as http;
import '/models/user.dart';
import '/models/school_class.dart';

class ApiService {
  static const String baseUrl = 'https://chatbot.duonra.nl';
  final http.Client _client = http.Client();
  Future<List<User>> getUsers() async {
    final url = Uri.parse('$baseUrl/api/students');

    final response = await _client.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> list = jsonDecode(response.body);
      return list.map((e) => User.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load students: ${response.statusCode}');
    }
  }
  Future<User> createStudent(User user, String password) async {
    final url = Uri.parse('$baseUrl/api/students');

    final response = await _client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "firstname": user.firstname,
        "middlename": user.middlename,
        "lastname": user.lastname,
        "email": user.email,
        "password": password
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return User.fromJson(data);
    } else {
      throw Exception('Error creating student: ${response.body}');
    }
  }


  // ---------- LOGIN  ----------
  Future<User> login(String email, String password) async {
    try {
      final url = Uri.parse('$baseUrl/api/login');

      final response = await _client.post(
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

  // ---------- upload classes ----------
  Future<List<SchoolClass>> getClasses() async {
    final url = Uri.parse('$baseUrl/api/classes');

    final response = await _client.get(url);

    print('GET $url -> ${response.statusCode}');
    print('BODY: ${response.body}');

    if (response.statusCode == 200) {
      final body = response.body.trim();
      if (body.isEmpty) {
        throw Exception('Empty answer.');
      }

      final List<dynamic> jsonList = jsonDecode(body);
      return jsonList.map((e) => SchoolClass.fromJson(e)).toList();
    } else {
      throw Exception(
          'Server returned ${response.statusCode}: ${response.body}');
    }
  }

  // ---------- create classes ----------
  Future<SchoolClass> createClass(String name) async {
    final url = Uri.parse('$baseUrl/api/classes');

    final response = await _client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name}),
    );

    print('POST $url -> ${response.statusCode}');
    print('BODY: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = response.body.trim();
      if (body.isEmpty) {
        throw Exception('empty answer.');
      }
      final Map<String, dynamic> data = jsonDecode(body);
      return SchoolClass.fromJson(data);
    } else {
      throw Exception(
          'Server returned ${response.statusCode}: ${response.body}');
    }
  }

  // ---------- change name of classes ----------
  Future<void> renameClass(int id, String newName) async {
    final url = Uri.parse('$baseUrl/api/classes/$id');

    final response = await _client.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': newName}),
    );

    print('PUT $url -> ${response.statusCode}');
    print('BODY: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception(
          'Server returned ${response.statusCode}: ${response.body}');
    }
  }

  // ---------- Delete classes ----------
  Future<void> deleteClass(int id) async {
    final url = Uri.parse('$baseUrl/api/classes/$id');

    final response = await _client.delete(url);

    print('DELETE $url -> ${response.statusCode}');
    print('BODY: ${response.body}');

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
          'Server returned ${response.statusCode}: ${response.body}');
    }
  }
  Future<List<int>> getClassStudents(int classId) async {
    final url = Uri.parse('$baseUrl/api/classes/$classId/students');

    final response = await _client.get(url);

    print('GET $url -> ${response.statusCode}');
    print('BODY: ${response.body}');

    if (response.statusCode == 200) {
      final body = response.body.trim();
      if (body.isEmpty) {
        return <int>[];
      }

      final List<dynamic> jsonList = jsonDecode(body);
      return jsonList.map((e) => e as int).toList();
    } else if (response.statusCode == 404) {
      // noch keine Studenten zugeordnet
      return <int>[];
    } else {
      throw Exception(
        'Server returned ${response.statusCode}: ${response.body}',
      );
    }
  }



  Future<void> updateClassStudents(int classId, List<int> studentIds) async {
    final url = Uri.parse('$baseUrl/api/classes/$classId/students');

    final response = await _client.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'students': studentIds, // ggf. key an Backend anpassen
      }),
    );

    print('PUT $url -> ${response.statusCode}');
    print('BODY: ${response.body}');

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
        'Server returned ${response.statusCode}: ${response.body}',
      );
    }
  }



}
