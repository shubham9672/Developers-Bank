class UseR {
  final String email;
  final String name;
  final String uid;
  UseR({
    required this.email,
    required this.name,
    required this.uid,
  });

  Map<String, dynamic> toData() {
    Map<String, dynamic> data = {};
    data['email'] = email;
    data['name'] = name;
    data['uid'] = uid;
    data['friendList'] = [];
    return data;
  }

  @override
  String toString() {
    // TODO: implement toString
    return this.email + this.name;
  }
}
