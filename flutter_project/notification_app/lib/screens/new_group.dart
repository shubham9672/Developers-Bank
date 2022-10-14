import 'dart:ffi';

import 'package:dev_task/components/constants.dart';
import 'package:dev_task/database/database.dart';
import 'package:dev_task/models/custom_text.dart';
import 'package:dev_task/models/group.dart';
import 'package:flutter/material.dart';

class CreateGroup extends StatefulWidget {
  final String userUID;
  const CreateGroup({Key? key, required this.userUID}) : super(key: key);

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  late List<dynamic> friends = [];
  late TextEditingController _nameController;
  List<dynamic> addedUser = [];
  List<dynamic> friendsInfo = [];

  getFriendInfo() async {
    for (var i = 0; i < friends.length; i++) {
      await DatabaseMethods().findUserWithUID(friends[i]).then((value) {
        friendsInfo.add(value.data());
      });
    }
    setState(() {});
    addedUser.add(widget.userUID);
  }

  Widget friendsList() {
    return ListView.builder(
        itemCount: friendsInfo.length,
        itemBuilder: (context, ind) {
          return ListTile(
              onTap: () {
                // DatabaseMethods().addFriend(widget.userUID, friends['ui']);
                if (addedUser.contains(friendsInfo[ind]['uid']))
                  addedUser.remove(friendsInfo[ind]['uid']);
                else
                  addedUser.add(friendsInfo[ind]['uid']);
                setState(() {});
              },
              leading: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Icon(
                    Icons.person,
                    size: 50,
                  )),
              title: MyText(
                data: friendsInfo[ind]['name'],
                softWrap: true,
                overFlow: true,
              ),
              subtitle: MyText(
                data: friendsInfo[ind]['email'],
                softWrap: true,
                overFlow: true,
                // maxLines: 1,
              ),
              trailing: addedUser.contains(friendsInfo[ind]['uid'])
                  ? Icon(
                      Icons.radio_button_checked,
                      color: primaryColor,
                    )
                  : Icon(
                      Icons.radio_button_off_rounded,
                    ));
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    _nameController = TextEditingController();
    DatabaseMethods().getFriendsList(widget.userUID).then((value) {
      setState(() {
        friends = value;
      });
      getFriendInfo();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: const Text('Create Group'),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: secondaryColor),
              )),
          TextButton(
              onPressed: addedUser.length < 2 || _nameController.text.length < 5
                  ? null
                  : () {
                      Group group = Group(
                          groupName: _nameController.text,
                          adminUID: widget.userUID,
                          users: addedUser);
                      DatabaseMethods().createGroup(group);
                      Navigator.pop(context);
                    },
              child: MyText(
                data: 'Done',
                c: secondaryColor,
              )),
        ],
      ),
      body: SizedBox(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.fromLTRB(15, 8, 0, 0),
                child: InkWell(
                  onTap: () {
                    // _pickImage();
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: primaryColor.withOpacity(0.8),
                    child: Icon(
                      Icons.group,
                      size: 50,
                      color: secondaryColor,
                    ),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20, top: 20),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Group Name',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                        fontSize: 24),
                  )),
            ),
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10)),
              child: TextField(
                onChanged: (_) {
                  setState(() {});
                },
                controller: _nameController,
                style: const TextStyle(color: textColor),
                maxLength: 25,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Group Name',
                    hintStyle: TextStyle(color: textColor)),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Add People',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                        fontSize: 24),
                  )),
            ),
            Expanded(child: friendsList())
          ],
        ),
      ),
    );
  }
}
