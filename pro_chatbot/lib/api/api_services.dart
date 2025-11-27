import 'dart:convert';
import 'package:http/http.dart' as http;
import '/models/user.dart';
import '/models/school_class.dart';

class ApiService {
  static const String baseUrl = 'https://chatbot.duonra.nl';

  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final http.Client _client = http.Client();
  String? _conversationId;
  int? _currentUserId;

  /// Set the current user ID for chat messages
  void setUserId(int userId) {
    _currentUserId = userId;
  }

  /// Reset conversation (for starting a new chat)
  void resetConversation() {
    _conversationId = null;
  }

  Future<String> sendChatMessage(String message) async {
    final url = Uri.parse('$baseUrl/api/chat');

    if (_currentUserId == null) {
      throw Exception('User ID not set. Please login first.');
    }

    final response = await _client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': _currentUserId,
        'message': message,
        if (_conversationId != null) 'conversation_id': _conversationId,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Server returned ${response.statusCode}: ${response.body}');
    }

    final data = jsonDecode(response.body);

    if (data['conversation_id'] != null) {
      _conversationId = data['conversation_id'];
    }

    return data['response'];
  }

  // ---------- LOGIN (user) ----------
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

  // ------- Creating Students ----------
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

  // ------- Fetching Students from database ----------
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

  // ------- Creating teachers ----------
  Future<User> createTeacher({
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
        'role': 'teacher',
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
        role: Role.teacher,
      );
    } else if (response.statusCode == 409) {
      // Only show email duplicate message
      throw Exception('E-mail bestaat al');
    } else {
      // message for all other errors (if there are any)
      throw Exception('Het is niet gelukt om de docent aan te maken');
    }
  }

  // ------- Fetching teachers and admins for lists ----------
  Future<List<User>> fetchTeachersAndAdmins() async {
    final url =
        Uri.parse('$baseUrl/api/users/teachers'); // matches backend route
    final response =
        await http.get(url, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      final users = data.map((json) => User.fromJson(json)).toList();
      return users;
    } else {
      throw Exception('Het is niet gelukt om docenten en admins op te halen.');
    }
  }

  Future<School> fetchUserSchool(int userId) async {
    final url = Uri.parse('$baseUrl/api/users/$userId/school');
    final response =
        await http.get(url, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return School.fromJson(data);
    } else {
      throw Exception('Kon school niet ophalen');
    }
  }

  // ------- Update school information ----------
  Future<void> updateSchool(School school) async {
    final url = Uri.parse('$baseUrl/api/schools/${school.id}');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(school.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Het is niet gelukt om de school bij te werken');
    }
  }

  // ---------- Load Classes ----------
  Future<List<SchoolClass>> getClasses() async {
    final url = Uri.parse('$baseUrl/api/classes');

    final response = await _client.get(url);

    print('GET $url -> ${response.statusCode}');
    print('BODY: ${response.body}');

    if (response.statusCode == 200) {
      final body = response.body.trim();
      if (body.isEmpty) {
        throw Exception('Leere Antwort vom Server.');
      }

      final List<dynamic> jsonList = jsonDecode(body);
      return jsonList.map((e) => SchoolClass.fromJson(e)).toList();
    } else {
      throw Exception(
          'Server returned ${response.statusCode}: ${response.body}');
    }
  }

  // ---------- Creatin Classes ----------
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
        throw Exception('Leere Antwort beim Erstellen der Klasse.');
      }

      final Map<String, dynamic> data = jsonDecode(body);
      return SchoolClass.fromJson(data);
    } else {
      throw Exception(
          'Server returned ${response.statusCode}: ${response.body}');
    }
  }

  // ---------- Rename Classes ----------
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

  // ---------- Delete Classes ----------
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
}
