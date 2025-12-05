import 'dart:convert';
import 'package:http/http.dart' as http;
import '/models/user.dart';

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

  /// Set conversation ID (for loading existing conversation)
  void setConversationId(String conversationId) {
    _conversationId = conversationId;
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
    required int
        schoolId, // The created teacher or admin inherits the school_id of the loggedin user
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
        'schoolId':
            schoolId, // The created teacher or admin inherits the school_id of the loggedin user
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
      throw Exception('E-mail bestaat al');
    } else {
      throw Exception('Het is niet gelukt om de student aan te maken');
    }
  }

// ---------- Delete Student ----------
  Future<void> deleteStudent(int id) async {
    try {
      final url = Uri.parse('$baseUrl/api/users/$id');

      final response = await _client.delete(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      print('DELETE $url -> ${response.statusCode}');
      print('BODY: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Successfully deleted
        return;
      } else if (response.statusCode == 404) {
        throw Exception('Student niet gevonden');
      } else if (response.statusCode == 403) {
        throw Exception('Alleen studenten kunnen verwijderd worden');
      } else {
        throw Exception(
            'Server fout (${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Kan geen verbinding maken met de server');
    }
  }

  // ------- Fetching Students from database ----------
  Future<List<User>> fetchStudents(int schoolId) async {
    final url = Uri.parse('$baseUrl/api/users?schoolId=$schoolId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Kon studenten niet ophalen');
    }
  }

  // ------- Update Students from database ----------
  Future<void> updateStudent({
    required User student,
    String? oldPassword,
    String? newPassword,
  }) async {
    final url = Uri.parse('$baseUrl/api/users/${student.id}');
    final body = {
      'firstname': student.firstname,
      'middlename': student.middlename,
      'lastname': student.lastname,
      'email': student.email,
    };

    // Only send the password if it's being changed
    if (newPassword != null && newPassword.isNotEmpty) {
      body['password'] = newPassword;
      if (oldPassword != null && oldPassword.isNotEmpty) {
        body['old_password'] = oldPassword;
      }
    }

    final response = await _client.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception('Kon student niet bijwerken');
    }
  }

// ------- Create Teacher/Admin ----------
  Future<User> createTeacherOrAdmin({
    required String firstname,
    String? middlename,
    required String lastname,
    required String email,
    required String password,
    String role = 'teacher',
    required int
        schoolId, // The created teacher or admin inherits the school_id of the loggedin user
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
        'role': role,
        'schoolId':
            schoolId, // The created teacher or admin inherits the school_id of the loggedin user
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
        role: role == 'admin' ? Role.admin : Role.teacher,
      );
    } else if (response.statusCode == 409) {
      throw Exception('E-mail bestaat al');
    } else {
      throw Exception('Het is niet gelukt om de gebruiker aan te maken');
    }
  }

  // ------- Delete Teacher/Admin ----------
  Future<void> deleteTeacherOrAdmin(int id) async {
    try {
      final url = Uri.parse('$baseUrl/api/users/$id');

      final response = await _client.delete(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      print('DELETE $url -> ${response.statusCode}');
      print('BODY: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Successfully deleted
        return;
      } else if (response.statusCode == 404) {
        throw Exception('Gebruiker niet gevonden');
      } else if (response.statusCode == 403) {
        throw Exception('Alleen docenten/admins kunnen verwijderd worden');
      } else {
        throw Exception(
            'Server fout (${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Kan geen verbinding maken met de server');
    }
  }

  // ------- Update Teacher/Admin ----------
  Future<void> updateTeacherOrAdmin({
    required User user,
    String? oldPassword,
    String? newPassword,
  }) async {
    final url = Uri.parse('$baseUrl/api/users/${user.id}');
    final body = {
      'firstname': user.firstname,
      'middlename': user.middlename,
      'lastname': user.lastname,
      'email': user.email,
    };

    // Only send the password if it's being changed
    if (newPassword != null && newPassword.isNotEmpty) {
      body['password'] = newPassword; // match database column
      if (oldPassword != null && oldPassword.isNotEmpty) {
        body['old_password'] = oldPassword; // optional, if backend verifies
      }
    }

    final response = await _client.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception('Kon gebruiker niet bijwerken');
    }
  }

  // ------- Fetching teachers and admins for lists ----------
  Future<List<User>> fetchTeachersAndAdmins(int schoolId) async {
    final url = Uri.parse('$baseUrl/api/users/teachers?schoolId=$schoolId');
    final response =
        await http.get(url, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
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
  Future<List<SchoolClass>> getClasses(int schoolId) async {
    final url = Uri.parse('$baseUrl/api/classes?school_id=$schoolId');

    final response = await _client.get(url);

    print('GET $url -> ${response.statusCode}');
    print('BODY: ${response.body}');

    if (response.statusCode == 200) {
      final body = response.body.trim();
      if (body.isEmpty) throw Exception("Empty response");

      final List<dynamic> jsonList = jsonDecode(body);
      return jsonList.map((item) => SchoolClass.fromJson(item)).toList();
    }

    throw Exception('Server returned ${response.statusCode}: ${response.body}');
  }

// ---------- Filter list with students without a Class----------
  Future<List<User>> fetchUnassignedStudents(int schoolId) async {
    final url =
        Uri.parse('$baseUrl/api/users/unassigned-students?school_id=$schoolId');

    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Het is niet gelukt om studenten op te halen.');
    }
  }

// ---------- Create Class ----------
  Future<SchoolClass> createClass(
      String name, List<Map<String, dynamic>> students, int schoolId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/classes'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'school_id': schoolId, // <-- include school ID
        'students': students, // list of maps
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return SchoolClass.fromJson(data); // convert JSON back to object
    } else {
      throw Exception('Kon klas niet aanmaken: ${response.body}');
    }
  }

// ---------- Rename Class ----------
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
      throw Exception('Error renaming: ${response.statusCode}');
    }
  }

  // ---------- Update class with students ----------
  Future<void> updateClasses({
    required int classId,
    required int studentId,
    required bool assign,
  }) async {
    final url = Uri.parse('$baseUrl/api/classes/$classId/updateclasses');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'student_id': studentId, 'assign': assign}),
    );

    if (response.statusCode != 200) {
      throw Exception('Kon student niet updaten: ${response.body}');
    }
  }

// ---------- Delete Class ----------
  Future<void> deleteClass(int id) async {
    final url = Uri.parse('$baseUrl/api/classes/$id');

    final response = await _client.delete(url);

    print('DELETE $url -> ${response.statusCode}');
    print('BODY: ${response.body}');

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Delete failed: ${response.statusCode}');
    }
  }

  // ---------- Add users to a Class ----------
  Future<List<User>> fetchUsersByRole(Role role) async {
    Uri url;

    // Choose endpoint based on role
    if (role == Role.student) {
      url = Uri.parse('$baseUrl/api/users'); // backend already filters students
    } else if (role == Role.teacher || role == Role.admin) {
      url = Uri.parse('$baseUrl/api/users/teachers');
    } else {
      throw Exception('Unknown role: ${role.name}');
    }

    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      final users = jsonData.map((u) => User.fromJson(u)).toList();

      // Filter if backend returns multiple roles
      if (role == Role.student) {
        return users.where((u) => u.role == Role.student).toList();
      } else if (role == Role.teacher) {
        return users.where((u) => u.role == Role.teacher).toList();
      } else if (role == Role.admin) {
        return users.where((u) => u.role == Role.admin).toList();
      }

      return users;
    } else {
      throw Exception(
          'Failed to load users with role ${role.name}: ${response.statusCode}');
    }
  }
}
