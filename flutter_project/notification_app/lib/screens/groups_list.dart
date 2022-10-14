import 'package:dev_task/auth_service/auth_service.dart';
import 'package:dev_task/components/group_tiles.dart';
import 'package:dev_task/database/database.dart';
import 'package:dev_task/models/custom_text.dart';
import 'package:dev_task/screens/new_group.dart';
import 'package:flutter/material.dart';

class GroupsList extends StatefulWidget {
  final String userUID;
  const GroupsList({Key? key, required this.userUID}) : super(key: key);

  @override
  State<GroupsList> createState() => _GroupsListState();
}

class _GroupsListState extends State<GroupsList> {
  Widget groupsList() {
    return StreamBuilder(
      stream: DatabaseMethods().getGroupsList(widget.userUID),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData || snapshot.data.docs.length == 0)
          return Center(
            child: MyText(data: 'Create a group to start Conversation'),
          );
        return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, ind) {
              // return ListTile(
              //   leading: Icon(Icons.group),
              //   title: snapshot.data.docs[ind].data()['name'],
              // );

              return GroupTile(
                groupName: snapshot.data.docs[ind].data()!['name'],
                lastMessage: snapshot.data.docs[ind].data()!['lastMessage'],
                timestamp: snapshot.data.docs[ind].data()!['timestamp'],
                groupUID: snapshot.data.docs[ind].id,
                users: snapshot.data.docs[ind].data()!['users'],
                userUID: widget.userUID,
              );
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: groupsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateGroup(
                        userUID: widget.userUID,
                      )));
        },
        child: Icon(Icons.group_add),
      ),
    );
  }
}
