enum MessageSender {
  student,
  teacher,
}

class HelpRequestMessage {
  final int id;
  final int helpRequestId;
  final MessageSender sender;
  final int senderId;
  final String senderName;
  final String message;
  final DateTime createdAt;

  HelpRequestMessage({
    required this.id,
    required this.helpRequestId,
    required this.sender,
    required this.senderId,
    required this.senderName,
    required this.message,
    required this.createdAt,
  });

  factory HelpRequestMessage.fromJson(Map<String, dynamic> json) {
    return HelpRequestMessage(
      id: json['id'],
      helpRequestId: json['help_request_id'],
      sender: json['sender'] == 'student'
          ? MessageSender.student
          : MessageSender.teacher,
      senderId: json['sender_id'],
      senderName: json['sender_name'] ?? '',
      message: json['message'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'help_request_id': helpRequestId,
      'sender': sender == MessageSender.student ? 'student' : 'teacher',
      'sender_id': senderId,
      'sender_name': senderName,
      'message': message,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
