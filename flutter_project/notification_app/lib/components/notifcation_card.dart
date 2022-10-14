import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev_task/database/database.dart';
import 'package:dev_task/models/custom_text.dart';
import 'package:flutter/material.dart';

class NotificationCard extends StatefulWidget {
  final String appName;
  final String title;
  final String message;
  final Timestamp timestamp;
  final String userUID;
  final String uid;
  bool softWrap;
  Color bgColor;
  final dynamic delete;
  NotificationCard(
      {Key? key,
      required this.appName,
      required this.title,
      required this.message,
      required this.timestamp,
      required this.userUID,
      required this.uid,
      required this.delete,
      this.softWrap = false,
      this.bgColor = Colors.white})
      : super(key: key);

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  bool isExpanded = false;
  bool isDelete = false;
  @override
  void initState() {
    // TODO: implement initState
    DatabaseMethods().updateSeenNotification(widget.userUID, widget.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !isDelete,
      child: GestureDetector(
        onTap: () {
          setState(() {
            isExpanded = !isExpanded;
          });
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          height: isExpanded ? 150 : 80,
          child: Card(
            color: widget.bgColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.android),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MyText(
                            data: widget.title,
                            overFlow: false,
                          ),
                          if (!isExpanded)
                            MyText(
                              data: widget.message.length > 50
                                  ? widget.message.substring(0, 30)
                                  : widget.message,
                              overFlow: true,
                            )
                        ],
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          widget.delete();
                          DatabaseMethods()
                              .deleteNotification(widget.userUID, widget.uid);
                        },
                        icon: Icon(Icons.delete))
                  ],
                ),
                if (isExpanded)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Column(
                      children: [
                        Container(
                          height: 60,
                          child: ListView(
                            children: [
                              MyText(
                                data: widget.message,
                                softWrap: true,
                              )
                            ],
                          ),
                        ),
                        MyText(
                          data: widget.timestamp.toDate().toString(),
                          c: Color.fromARGB(255, 116, 115, 115),
                        )
                      ],
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
