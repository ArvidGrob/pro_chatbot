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

  Future<String> sendChatMessage(String message) async {
    final url = Uri.parse('$baseUrl/api/chat');

    final response = await _client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': 1,
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

  // ---------- LOGIN (wie vorher) ----------
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

  // ---------- KLASSEN LADEN ----------
  Future<List<SchoolClass>> getClasses() async {
    final url =
        Uri.parse('$baseUrl/api/classes'); // <– ENDPOINT später evtl. anpassen

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

  // ---------- KLASSE ERSTELLEN ----------
  Future<SchoolClass> createClass(String name) async {
    final url =
        Uri.parse('$baseUrl/api/classes'); // <– ENDPOINT später evtl. anpassen

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
      // falls der Server das Objekt direkt zurückgibt:
      return SchoolClass.fromJson(data);
      // falls er in einem Feld liegt, dann evtl:
      // return SchoolClass.fromJson(data['class']);
    } else {
      throw Exception(
          'Server returned ${response.statusCode}: ${response.body}');
    }
  }

  // ---------- KLASSE UMBENENNEN ----------
  Future<void> renameClass(int id, String newName) async {
    final url = Uri.parse('$baseUrl/api/classes/$id'); // evtl. anpassen

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

  // ---------- KLASSE LÖSCHEN ----------
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
