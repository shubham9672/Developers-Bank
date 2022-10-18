import 'package:flutter/material.dart';
import 'package:track_ez/Component/activityCard.dart';
import 'package:track_ez/constants.dart';
import 'package:track_ez/screens/auth/Database/database.dart';

class Activity extends StatefulWidget {
  final String userUID;
  const Activity({Key? key, required this.userUID}) : super(key: key);

  @override
  State<Activity> createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  List<dynamic> activities = [];
  bool isLoading = true;
  getActivity() {
    DatabaseMethods().getClassifiedRide(widget.userUID).then((value) {
      // print(value);
      setState(() {
        activities = value;
        isLoading = false;
      });
    });
  }

  deleteActivity(int index) {
    activities.removeAt(index);
    // setState(() {});
  }

  Widget activityList() {
    return ListView.builder(
        itemCount: activities.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return ActivityCard(
            userUID: widget.userUID,
            rideInfo: activities[index],
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    getActivity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text('Activity',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: fontText,
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
          centerTitle: true,
          elevation: 0.5,
          actions: [],
        ),
        body: Center(
          child: isLoading ? Container() : activityList(),
        ),
      ),
    );
  }
}
