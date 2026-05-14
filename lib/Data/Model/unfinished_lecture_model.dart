class UnfinishedLecture {
  final String doctorName;
  final String? subjectName;
  final String? groupName;
  final String? programName;
  final String? levelName;
  final String eventDay;

  UnfinishedLecture({
    required this.doctorName,
    this.subjectName,
    this.groupName,
    this.programName,
    this.levelName,
    required this.eventDay,
  });

  factory UnfinishedLecture.fromJson(Map<String, dynamic> json) {
    return UnfinishedLecture(
      doctorName: (json['doctor_name'] ?? '').toString(),
      subjectName: json['subject_name']?.toString(),
      groupName: json['group_name']?.toString(),
      programName: json['program_name']?.toString(),
      levelName: json['level_name']?.toString(),
      eventDay: (json['event_day'] ?? '').toString(),
    );
  }
}
