import 'package:dev_task/components/constants.dart';
import 'package:dev_task/database/database.dart';
import 'package:dev_task/models/custom_text.dart';
import 'package:dev_task/models/message.dart';
import 'package:flutter/material.dart';

class GroupChatRoom extends StatefulWidget {
  final String userUID;
  final String groupName;
  final String groupUID;
  final List users;
  const GroupChatRoom(
      {Key? key,
      required this.userUID,
      required this.groupName,
      required this.groupUID,
      required this.users})
      : super(key: key);

  @override
  State<GroupChatRoom> createState() => _GroupChatRoomState();
}

class _GroupChatRoomState extends State<GroupChatRoom> {
  late TextEditingController _messageController;
  Map<String, String> members = {};
  bool isLoading = true;
  getMembersData() async {
    for (var i = 0; i < widget.users.length; i++) {
      await DatabaseMethods().findUserWithUID(widget.users[i]).then((value) {
        members[value.data()['uid']] = value.data()['name'];
      });
    }
    members[widget.userUID] = 'You';
    setState(() {
      isLoading = false;
    });
  }

  Widget footer() {
    return Container(
        child: Row(
      children: [
        Expanded(
            child: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: primaryColor.withOpacity(0.1)),
                child: TextField(
                  controller: _messageController,
                  minLines: 1,
                  maxLines: 4,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter your Message',
                      hintStyle: TextStyle(color: textColor)),
                ))),
        IconButton(
            onPressed: () {
              setState(() {});
              if (_messageController.text.trim().length == 0) return;
              Message message = Message(
                  message: _messageController.text.trim(),
                  senderUID: widget.userUID,
                  groupUID: widget.groupUID);
              DatabaseMethods().sendMessage(message, widget.groupUID);
              _messageController.clear();
            },
            icon: Icon(
              Icons.send,
              color: primaryColor,
            ))
      ],
    ));
  }

  Widget chats() {
    return StreamBuilder(
      stream: DatabaseMethods().getChats(widget.groupUID),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData || snapshot.data.docs.length == 0)
          return Center(
            child: MyText(data: 'Start conversation'),
          );
        return ListView.builder(
            padding: EdgeInsets.only(bottom: 100),
            shrinkWrap: true,
            reverse: true,
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, ind) {
              bool sendByme =
                  snapshot.data.docs[ind].data()['senderUID'] == widget.userUID;
              String senderID =
                  snapshot.data.docs[ind].data()['senderUID'].toString();
              return Wrap(
                  crossAxisAlignment: WrapCrossAlignment.end,
                  alignment: sendByme ? WrapAlignment.end : WrapAlignment.start,
                  children: [
                    Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        margin: EdgeInsets.only(
                            top: 8,
                            bottom: 8,
                            left: sendByme ? 50 : 8,
                            right: sendByme ? 8 : 50),
                        decoration: BoxDecoration(
                            color: sendByme
                                ? primaryColor
                                : Color.fromARGB(255, 135, 169, 228),
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!sendByme && senderID != null)
                                Text(
                                  members[senderID]!,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 12,
                                      color: sendByme
                                          ? primaryColor.withOpacity(0.7)
                                          : textColor),
                                ),
                              Text(
                                snapshot.data.docs[ind].data()['message'],
                                style: TextStyle(
                                    color: secondaryColor,
                                    fontFamily: textFont,
                                    fontSize: 15),
                              ),
                            ]))
                  ]);
            });
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    _messageController = TextEditingController();
    getMembersData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: MyText(
            data: widget.groupName,
            c: secondaryColor,
          ),
        ),
        body: Stack(children: [
          isLoading
              ? Center(
                  child: MyText(
                  data: 'Fetching chats',
                ))
              : Align(alignment: Alignment.bottomCenter, child: chats()),
          Align(
            alignment: Alignment.bottomCenter,
            child: footer(),
          )
        ]),
      ),
    );
  }
}
