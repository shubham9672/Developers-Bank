class Message {
  final String message;
  final String senderUID;
  final String groupUID;

  Message(
      {required this.message, required this.senderUID, required this.groupUID});

  Map<String, dynamic> toData() {
    Map<String, dynamic> data = {};
    data['message'] = message;
    data['groupUID'] = groupUID;
    data['senderUID'] = senderUID;
    data['timestamp'] = DateTime.now();
    return data;
  }
}
