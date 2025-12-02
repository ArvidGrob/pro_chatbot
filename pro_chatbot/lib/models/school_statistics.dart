class SchoolStatistics {
  final int totalLogins;
  final int totalQuestions;
  final int totalSessionDuration; // en minutes

  SchoolStatistics({
    required this.totalLogins,
    required this.totalQuestions,
    required this.totalSessionDuration,
  });

  factory SchoolStatistics.fromJson(Map<String, dynamic> json) {
    return SchoolStatistics(
      totalLogins: json['total_logins'] ?? 0,
      totalQuestions: json['total_questions'] ?? 0,
      totalSessionDuration: json['total_session_duration'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_logins': totalLogins,
      'total_questions': totalQuestions,
      'total_session_duration': totalSessionDuration,
    };
  }

  /// Convertit la durée de session en format lisible (ex: "180 uur")
  String get formattedDuration {
    final hours = (totalSessionDuration / 60).floor();
    return '$hours uur';
  }

  /// Convertit le nombre de questions en format lisible (ex: "6500 vragen")
  String get formattedQuestions {
    return '$totalQuestions vragen';
  }
}
