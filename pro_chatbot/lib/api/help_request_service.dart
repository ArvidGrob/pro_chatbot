import 'dart:convert';
import 'package:http/http.dart' as http;
import '/models/help_request.dart';
import '/models/help_request_message.dart';

class HelpRequestService {
  static const String baseUrl = 'https://chatbot.duonra.nl';

  /// Send help request (for students)
  Future<bool> sendHelpRequest({
    required int studentId,
    required String studentName,
    required String subject,
    required String message,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/api/help-requests');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'student_id': studentId,
          'student_name': studentName,
          'subject': subject,
          'message': message,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print(
            'Error sending help request: ${response.statusCode} - ${response.body}');
        throw Exception(
            'Failed to send help request. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception in sendHelpRequest: $e');
      if (e is Exception) rethrow;
      throw Exception('Server connection error');
    }
  }

  /// Get all help requests (for teachers/admin)
  /// CORRECTED: Now requires teacherId to filter by school
  Future<List<HelpRequest>> getAllHelpRequests({required int teacherId}) async {
    try {
      // Pass teacher_id as query parameter to filter by school
      final url = Uri.parse('$baseUrl/api/help-requests?teacher_id=$teacherId');

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => HelpRequest.fromJson(json)).toList();
      } else {
        print('Error getting all help requests: ${response.statusCode}');
        throw Exception('Failed to retrieve help requests');
      }
    } catch (e) {
      print('Exception in getAllHelpRequests: $e');
      if (e is Exception) rethrow;
      throw Exception('Server connection error');
    }
  }

  /// Get help requests for a specific student
  Future<List<HelpRequest>> getStudentHelpRequests(int studentId) async {
    try {
      final url = Uri.parse('$baseUrl/api/help-requests/student/$studentId');

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => HelpRequest.fromJson(json)).toList();
      } else {
        print('Error getting student help requests: ${response.statusCode}');
        throw Exception('Failed to retrieve student help requests');
      }
    } catch (e) {
      print('Exception in getStudentHelpRequests: $e');
      if (e is Exception) rethrow;
      throw Exception('Server connection error');
    }
  }

  /// Respond to help request (for teachers)
  Future<bool> respondToHelpRequest({
    required int requestId,
    required int teacherId,
    required String response,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/api/help-requests/$requestId/respond');

      final httpResponse = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'teacher_id': teacherId,
          'teacher_response': response,
        }),
      );

      if (httpResponse.statusCode == 200) {
        return true;
      } else {
        print('Error responding to help request: ${httpResponse.statusCode}');
        throw Exception('Failed to send response');
      }
    } catch (e) {
      print('Exception in respondToHelpRequest: $e');
      if (e is Exception) rethrow;
      throw Exception('Server connection error');
    }
  }

  /// Mark request as resolved
  Future<bool> markAsResolved(int requestId) async {
    try {
      final url = Uri.parse('$baseUrl/api/help-requests/$requestId/resolve');

      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to change status');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Server connection error');
    }
  }

  /// Get specific help request
  Future<HelpRequest> getHelpRequest(int requestId) async {
    try {
      final url = Uri.parse('$baseUrl/api/help-requests/$requestId');

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return HelpRequest.fromJson(data);
      } else {
        throw Exception('Failed to retrieve request');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Server connection error');
    }
  }

  /// Get conversation messages for a help request
  Future<List<HelpRequestMessage>> getConversationMessages(
      int helpRequestId) async {
    try {
      final url =
          Uri.parse('$baseUrl/api/help-requests/$helpRequestId/messages');

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => HelpRequestMessage.fromJson(json)).toList();
      } else {
        print('Error getting conversation messages: ${response.statusCode}');
        throw Exception('Failed to retrieve conversation messages');
      }
    } catch (e) {
      print('Exception in getConversationMessages: $e');
      if (e is Exception) rethrow;
      throw Exception('Server connection error');
    }
  }

  /// Add a message to conversation (student or teacher)
  Future<bool> addConversationMessage({
    required int helpRequestId,
    required String sender, // 'student' or 'teacher'
    required int senderId,
    required String senderName,
    required String message,
  }) async {
    try {
      final url =
          Uri.parse('$baseUrl/api/help-requests/$helpRequestId/messages');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'sender': sender,
          'sender_id': senderId,
          'sender_name': senderName,
          'message': message,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print('Error adding conversation message: ${response.statusCode}');
        throw Exception('Failed to add message');
      }
    } catch (e) {
      print('Exception in addConversationMessage: $e');
      if (e is Exception) rethrow;
      throw Exception('Server connection error');
    }
  }
}
