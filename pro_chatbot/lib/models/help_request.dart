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
  final int? schoolId; // NOUVEAU
  final int? classId; // NOUVEAU
  final String? className; // NOUVEAU

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
    this.schoolId, // NOUVEAU
    this.classId, // NOUVEAU
    this.className, // NOUVEAU
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
      schoolId: json['school_id'], // NOUVEAU
      classId: json['class_id'], // NOUVEAU
      className: json['class_name'], // NOUVEAU
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
      'school_id': schoolId, // NOUVEAU
      'class_id': classId, // NOUVEAU
      'class_name': className, // NOUVEAU
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
    int? schoolId, // NOUVEAU
    int? classId, // NOUVEAU
    String? className, // NOUVEAU
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
      schoolId: schoolId ?? this.schoolId, // NOUVEAU
      classId: classId ?? this.classId, // NOUVEAU
      className: className ?? this.className, // NOUVEAU
    );
  }
}
