import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev_task/models/custom_text.dart';
import 'package:dev_task/screens/group_chatroom.dart';
import 'package:flutter/material.dart';

class GroupTile extends StatefulWidget {
  final String userUID;
  final String groupName;
  final String lastMessage;
  final Timestamp timestamp;
  final String groupUID;
  final List users;
  const GroupTile(
      {Key? key,
      required this.groupName,
      required this.lastMessage,
      required this.timestamp,
      required this.groupUID,
      required this.userUID,
      required this.users})
      : super(key: key);

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  String claculateTime(_timestamp) {
    DateTime currentTime = DateTime.now();
    var timestamp =
        DateTime.fromMicrosecondsSinceEpoch(_timestamp.microsecondsSinceEpoch);
    var yearDiff = currentTime.year - timestamp.year;
    var monthDiff = currentTime.month - timestamp.month;
    var dayDiff = currentTime.day - timestamp.day;
    var hourDiff = currentTime.hour - timestamp.hour;
    var minDiff = currentTime.minute - timestamp.minute;

    var min = '${timestamp.minute}'.length > 1
        ? '${timestamp.minute}'
        : '0${timestamp.minute}';

    var hour = '${timestamp.hour}'.length > 1
        ? '${timestamp.hour}'
        : '0${timestamp.hour}';

    var day = '${timestamp.day}'.length > 1
        ? '${timestamp.day}'
        : '0${timestamp.day}';

    var month = '${timestamp.month}'.length > 1
        ? '${timestamp.month}'
        : '0${timestamp.month}';

    var year = '${timestamp.year}'.substring(2);

    if (yearDiff < 1 &&
        monthDiff < 1 &&
        dayDiff < 1 &&
        hourDiff < 1 &&
        minDiff < 1) {
      return 'Just Now';
    } else if (yearDiff < 1 && monthDiff < 1 && dayDiff < 1) {
      if (int.parse(hour) == 0) {
        return '12:$min AM';
      } else if (int.parse(hour) == 12) {
        return '12:$min PM';
      } else if (int.parse(hour) > 12) {
        return '${int.parse(hour) - 12}:$min PM';
      } else {
        return '$hour:$min AM';
      }
    } else if ((yearDiff < 1 && monthDiff < 1 && dayDiff < 2) ||
        (yearDiff < 1 && monthDiff <= 1 && dayDiff < 0) ||
        (yearDiff == 1 && currentTime.day == 1 && currentTime.month == 1)) {
      return 'Yesterday';
    } else {
      return '$day/$month/$year';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => GroupChatRoom(
                        groupName: widget.groupName,
                        groupUID: widget.groupUID,
                        users: widget.users,
                        userUID: widget.userUID,
                      )));
        },
        leading: Icon(
          Icons.group,
          size: 40,
        ),
        title: MyText(data: widget.groupName),
        subtitle: MyText(data: widget.lastMessage),
        trailing: MyText(data: claculateTime(widget.timestamp)),
      ),
    );
  }
}
