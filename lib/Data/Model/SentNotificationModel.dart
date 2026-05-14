class SentNotification {
  final int notificationId;
  final String date;
  final String time;
  final String type;
  final String title;
  final String sender;
  final String description;


  SentNotification({
    required this.notificationId,
    required this.date,
    required this.time,
    required this.type,
    required this.title,
    required this.sender,
    required this.description,
  });

  factory SentNotification.fromJson(Map<String, dynamic> json) {
    return SentNotification(
      notificationId: int.tryParse((json['notification_id'] ?? 0).toString()) ?? 0,
      date: (json['date'] ?? '').toString(),
      time: (json['time'] ?? '').toString(),
      type: (json['type'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      sender: (json['sender'] ?? '').toString(),
    );
  }
}
