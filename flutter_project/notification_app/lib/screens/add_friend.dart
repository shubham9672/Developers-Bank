import 'package:dev_task/components/constants.dart';
import 'package:dev_task/database/database.dart';
import 'package:dev_task/models/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddFriend extends StatefulWidget {
  final String userUID;
  const AddFriend({Key? key, required this.userUID}) : super(key: key);

  @override
  State<AddFriend> createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
  late TextEditingController _controller;
  dynamic user = '';
  @override
  void initState() {
    // TODO: implement initState
    _controller = TextEditingController();
    super.initState();
  }

  Widget searchUserTile() {
    if (user == '') return SizedBox();
    return ListTile(
        onTap: () {
          DatabaseMethods().addFriend(widget.userUID, user['uid']);
          Fluttertoast.showToast(msg: 'Friend added');
        },
        leading: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Icon(
              Icons.person,
              size: 50,
            )),
        title: MyText(
          data: user['name'],
          softWrap: true,
          overFlow: true,
        ),
        subtitle: MyText(
          data: user['email'],
          softWrap: true,
          overFlow: true,
          // maxLines: 1,
        ),
        trailing: Icon(
          Icons.person_add_alt_rounded,
          size: 30,
        ));
  }

  Widget searchField() {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color.fromARGB(255, 173, 213, 245)),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Icon(
              Icons.person,
            ),
          ),
          Expanded(
            child: TextField(
              onChanged: (value) {
                setState(() {});
                DatabaseMethods()
                    .findUserWithEmail(_controller.text.trim())
                    .then((value) {
                  if (value.size > 0 &&
                      value!.docs.first.data()['uid'] != widget.userUID) {
                    setState(() {
                      user = value!.docs.first.data();
                    });
                  }
                });
              },
              controller: _controller,
              style: const TextStyle(color: Colors.black),
              cursorColor: Colors.black,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: ' John@example.com',
                  hintStyle:
                      TextStyle(color: Colors.grey[200], fontFamily: textFont)),
            ),
          ),
          IconButton(
            icon: Icon(
                _controller.text.isEmpty ? Icons.search : Icons.close_rounded,
                color: Colors.black),
            onPressed: () {
              setState(() {
                _controller.clear();
                user = '';
              });
            },
          )
        ],
      ),
    );
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
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            searchField(),
            SizedBox(
              height: 20,
            ),
            user == '' && _controller.text.length == 0
                ? MyText(data: 'No User Found')
                : MyText(data: 'Search Result'),
            searchUserTile(),
            // MyText(data: 'hello')
          ],
        ),
      ),
    );
  }
}
