class ConversationMessage {
  final String role; // 'user' or 'assistant'
  final String content;
  final DateTime timestamp;

  ConversationMessage({
    required this.role,
    required this.content,
    required this.timestamp,
  });

  factory ConversationMessage.fromJson(Map<String, dynamic> json) {
    return ConversationMessage(
      role: json['role'] ?? '',
      content: json['content'] ?? '',
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

class Conversation {
  final String id;
  final int userId;
  final String title;
  final List<ConversationMessage> messages;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Conversation({
    required this.id,
    required this.userId,
    required this.title,
    required this.messages,
    required this.createdAt,
    this.updatedAt,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    var messagesList = json['messages'] as List? ?? [];
    List<ConversationMessage> messages =
        messagesList.map((msg) => ConversationMessage.fromJson(msg)).toList();

    return Conversation(
      id: json['_id'] ?? json['id'] ?? '',
      userId: json['user_id'] ?? 0,
      title: json['title'] ?? 'Nieuwe conversatie',
      messages: messages,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'messages': messages.map((msg) => msg.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Get the first user message as a preview
  String getPreview() {
    if (messages.isEmpty) return 'Geen berichten';

    final userMessage = messages.firstWhere(
      (msg) => msg.role == 'user',
      orElse: () => messages.first,
    );

    return userMessage.content.length > 50
        ? '${userMessage.content.substring(0, 50)}...'
        : userMessage.content;
  }

  /// Get the last message timestamp for sorting
  DateTime getLastMessageTime() {
    if (messages.isEmpty) return createdAt;
    return messages.last.timestamp;
  }
}
