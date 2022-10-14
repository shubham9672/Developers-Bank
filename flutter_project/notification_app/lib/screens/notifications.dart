import 'package:dev_task/components/constants.dart';
import 'package:dev_task/components/notifcation_card.dart';
import 'package:dev_task/database/database.dart';
import 'package:dev_task/models/custom_text.dart';
import 'package:dev_task/models/notification.dart';
import 'package:flutter/material.dart';

class AllNotifications extends StatefulWidget {
  final String userUID;
  const AllNotifications({Key? key, required this.userUID}) : super(key: key);

  @override
  State<AllNotifications> createState() => _AllNotificationsState();
}

class _AllNotificationsState extends State<AllNotifications> {
  List<dynamic> _seenList = [];
  List<dynamic> _unseenList = [];
  dynamic delete(int ind) {
    setState(() {
      _seenList.removeAt(ind);
    });
  }

  Widget seenNotificationList() {
    return ListView.builder(
        itemCount: _seenList.length + _unseenList.length,
        itemBuilder: (context, ind) {
          if (ind == 0 && _unseenList.length > 0)
            return Column(
              children: [
                MyText(
                  data: 'Unread Notifications (${_unseenList.length})',
                  c: primaryColor,
                ),
                NotificationCard(
                  appName: _unseenList[ind]['appName'],
                  title: _unseenList[ind]['title'],
                  message: _unseenList[ind]['message'],
                  timestamp: _unseenList[ind]['timestamp'],
                  uid: _unseenList[ind]['uid'],
                  userUID: widget.userUID,
                  delete: () {
                    setState(() {
                      _seenList.removeAt(ind);
                    });
                  },
                  softWrap: true,
                  bgColor: Color.fromARGB(255, 210, 208, 208),
                )
              ],
            );
          if (ind < _unseenList.length) {
            return NotificationCard(
              appName: _unseenList[ind]['appName'],
              title: _unseenList[ind]['title'],
              message: _unseenList[ind]['message'],
              timestamp: _unseenList[ind]['timestamp'],
              uid: _unseenList[ind]['uid'],
              userUID: widget.userUID,
              delete: () {
                setState(() {
                  _seenList.removeAt(ind);
                });
              },
              softWrap: true,
              bgColor: Color.fromARGB(255, 210, 208, 208),
            );
          }
          ind -= _unseenList.length;
          if (ind == 0 && _seenList.length > 0)
            return Column(
              children: [
                MyText(
                  data: 'Read Notifications (${_seenList.length})',
                  c: primaryColor,
                ),
                NotificationCard(
                  appName: _seenList[ind]['appName'],
                  title: _seenList[ind]['title'],
                  message: _seenList[ind]['message'],
                  timestamp: _seenList[ind]['timestamp'],
                  uid: _seenList[ind]['uid'],
                  userUID: widget.userUID,
                  delete: () {
                    setState(() {
                      _seenList.removeAt(ind);
                    });
                  },
                  softWrap: true,
                )
              ],
            );
          return NotificationCard(
            appName: _seenList[ind]['appName'],
            title: _seenList[ind]['title'],
            message: _seenList[ind]['message'],
            timestamp: _seenList[ind]['timestamp'],
            uid: _seenList[ind]['uid'],
            userUID: widget.userUID,
            delete: () {
              setState(() {
                _seenList.removeAt(ind);
              });
            },
            softWrap: true,
          );
        });
  }

  // Widget unseenNotificationList() {
  //   return ListView.builder(
  //       itemCount: _unseenList.length, itemBuilder: (context, ind) {});
  // }

  @override
  void initState() {
    DatabaseMethods().getUnseenNotifications(widget.userUID).then((value) {
      setState(() {
        _unseenList = value;
      });
    });
    DatabaseMethods().getSeenNotifications(widget.userUID).then((value) {
      setState(() {
        _seenList = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: MyText(
                data: 'All Notifications',
                c: Colors.white,
              ),
              centerTitle: true,
            ),
            body: seenNotificationList()));
  }
}
