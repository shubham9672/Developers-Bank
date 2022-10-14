class Group {
  final String groupName;
  final String adminUID;
  final String description;
  final List<dynamic> users;
  Group(
      {required this.groupName,
      required this.adminUID,
      required this.users,
      this.description = ''});

  Map<String, dynamic> toData() {
    Map<String, dynamic> group = {};
    group['name'] = groupName;
    group['adminUID'] = adminUID;
    group['description'] = description;
    group['users'] = users;
    group['lastMessage'] = "Admin created the Group";
    group['timestamp'] = DateTime.now();
    return group;
  }
}
