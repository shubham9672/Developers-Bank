import 'package:flutter/material.dart';
import 'package:track_ez/Component/activityCard.dart';
import 'package:track_ez/constants.dart';
import 'package:track_ez/screens/auth/Database/database.dart';

class Unclassified extends StatefulWidget {
  final String userUID;

  const Unclassified({Key? key, required this.userUID}) : super(key: key);

  @override
  State<Unclassified> createState() => _UnclassifiedState();
}

class _UnclassifiedState extends State<Unclassified> {
  List<dynamic> activities = [];
  bool isLoading = true;
  getActivity() {
    DatabaseMethods().getUnclassifiedRide(widget.userUID).then((value) {
      // print(value);
      setState(() {
        activities = value;
        isLoading = false;
      });
    });
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
          title: Text('Rate Your Activity',
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
          child: isLoading
              ? Container()
              : (activities.length == 0
                  ? Text(
                      'No activity',
                      style: TextStyle(
                          color: textColor, fontFamily: fontText, fontSize: 15),
                    )
                  : activityList()),
        ),
      ),
    );
  }
}
