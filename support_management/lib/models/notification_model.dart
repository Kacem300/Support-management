class NotificationModel {
  final String title;
  final String subtitle;
  final String date;
  final String? flag;
  final List<String>? actions;

  NotificationModel({
    required this.title,
    required this.subtitle,
    required this.date,
    this.flag,
    this.actions,
  });
}
