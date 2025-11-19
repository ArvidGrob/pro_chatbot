enum HelpRequestStatus {
  pending,
  responded,
  resolved,
}

class HelpRequest {
  final int id;
  final int studentId;
  final String studentName;
  final String subject;
  final String message;
  final DateTime createdAt;
  final HelpRequestStatus status;
  final String? teacherResponse;
  final DateTime? respondedAt;
  final int? teacherId;

  HelpRequest({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.subject,
    required this.message,
    required this.createdAt,
    required this.status,
    this.teacherResponse,
    this.respondedAt,
    this.teacherId,
  });

  factory HelpRequest.fromJson(Map<String, dynamic> json) {
    return HelpRequest(
      id: json['id'],
      studentId: json['student_id'],
      studentName: json['student_name'] ?? 'Onbekende student',
      subject: json['subject'] ?? '',
      message: json['message'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      status: HelpRequestStatus.values.firstWhere(
        (s) => s.toString() == 'HelpRequestStatus.${json['status']}',
        orElse: () => HelpRequestStatus.pending,
      ),
      teacherResponse: json['teacher_response'],
      respondedAt: json['responded_at'] != null
          ? DateTime.parse(json['responded_at'])
          : null,
      teacherId: json['teacher_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'student_name': studentName,
      'subject': subject,
      'message': message,
      'created_at': createdAt.toIso8601String(),
      'status': status.toString().split('.').last,
      'teacher_response': teacherResponse,
      'responded_at': respondedAt?.toIso8601String(),
      'teacher_id': teacherId,
    };
  }

  HelpRequest copyWith({
    int? id,
    int? studentId,
    String? studentName,
    String? subject,
    String? message,
    DateTime? createdAt,
    HelpRequestStatus? status,
    String? teacherResponse,
    DateTime? respondedAt,
    int? teacherId,
  }) {
    return HelpRequest(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      subject: subject ?? this.subject,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      teacherResponse: teacherResponse ?? this.teacherResponse,
      respondedAt: respondedAt ?? this.respondedAt,
      teacherId: teacherId ?? this.teacherId,
    );
  }
}
