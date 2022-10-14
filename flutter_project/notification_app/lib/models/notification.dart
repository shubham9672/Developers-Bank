class NotificatioN {
  final String appName;
  final String title;
  final String message;
  final DateTime timestamp;
  bool seen;
  NotificatioN(
      {required this.appName,
      required this.title,
      required this.message,
      required this.timestamp,
      this.seen = false});
  Map<String, dynamic> toData() {
    Map<String, dynamic> data = {};
    data['appName'] = appName;
    data['title'] = title;
    data['message'] = message;
    data['timestamp'] = timestamp;
    data['seen'] = seen;
    return data;
  }

  @override
  String toString() {
    // TODO: implement toString
    return this.appName + this.title + this.message;
  }
}
