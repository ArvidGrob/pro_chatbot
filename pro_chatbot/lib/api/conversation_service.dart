import 'dart:convert';
import 'package:http/http.dart' as http;
import '/models/conversation.dart';

class ConversationService {
  static const String baseUrl = 'https://chatbot.duonra.nl';

  /// Get all conversations for a specific user
  Future<List<Conversation>> getUserConversations(int userId) async {
    try {
      final url = Uri.parse('$baseUrl/api/conversations/user/$userId');

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Conversation.fromJson(json)).toList();
      } else {
        print('Error getting conversations: ${response.statusCode}');
        throw Exception('Failed to retrieve conversations');
      }
    } catch (e) {
      print('Exception in getUserConversations: $e');
      if (e is Exception) rethrow;
      throw Exception('Server connection error');
    }
  }

  /// Get a specific conversation by ID
  Future<Conversation> getConversation(String conversationId) async {
    try {
      final url = Uri.parse('$baseUrl/api/conversations/$conversationId');

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Conversation.fromJson(data);
      } else {
        print('Error getting conversation: ${response.statusCode}');
        throw Exception('Failed to retrieve conversation');
      }
    } catch (e) {
      print('Exception in getConversation: $e');
      if (e is Exception) rethrow;
      throw Exception('Server connection error');
    }
  }

  /// Delete a conversation
  Future<bool> deleteConversation(String conversationId) async {
    try {
      final url = Uri.parse('$baseUrl/api/conversations/$conversationId');

      final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Error deleting conversation: ${response.statusCode}');
        throw Exception('Failed to delete conversation');
      }
    } catch (e) {
      print('Exception in deleteConversation: $e');
      if (e is Exception) rethrow;
      throw Exception('Server connection error');
    }
  }

  /// Update conversation title
  Future<bool> updateConversationTitle(
      String conversationId, String newTitle) async {
    try {
      final url = Uri.parse('$baseUrl/api/conversations/$conversationId/title');

      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'title': newTitle}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Error updating conversation title: ${response.statusCode}');
        throw Exception('Failed to update conversation title');
      }
    } catch (e) {
      print('Exception in updateConversationTitle: $e');
      if (e is Exception) rethrow;
      throw Exception('Server connection error');
    }
  }
}
