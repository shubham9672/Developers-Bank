import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_geocoding/google_geocoding.dart';
import 'package:track_ez/constants.dart';
import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:track_ez/screens/auth/Database/database.dart';
import 'package:flutter/physics.dart';
import 'package:geocoding/geocoding.dart';

class ActivityCard extends StatefulWidget {
  final Map<dynamic, dynamic> rideInfo;
  final String userUID;
  const ActivityCard({
    Key? key,
    required this.rideInfo,
    required this.userUID,
  }) : super(key: key);

  @override
  State<ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Alignment> _animation;
  Alignment _dragAlignment = Alignment.center;
  List<String> businessSubCategory = [
    'Between offices',
    'Customer visit',
    'Meeting',
    'Supplies',
    'Meal/Entertain',
    'Temporary site',
    'Airport/Travel'
  ];
  List<String> personalSubCategory = [
    'Dinner',
    'Kids Games',
    'Date Night',
    'Friends'
  ];
  bool isExpanded = false;
  bool swapped = false;
  bool leftSwipe = false;
  bool rightSwipe = false;
  bool isDeleted = false;
  String source = '';
  String destination = '';

  getAddress() async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        widget.rideInfo['source'][0], widget.rideInfo['source'][1]);
    List<Placemark> placemarks2 = await placemarkFromCoordinates(
        widget.rideInfo['destination'][0], widget.rideInfo['destination'][1]);
    if (mounted) {
      setState(() {
        source = '${placemarks.first.name}, ${placemarks.first.locality}';
        destination =
            '${placemarks2.first.name}, ${placemarks2.first.locality}';
      });
    }
  }

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animationController.addListener(() {
      setState(() {
        _dragAlignment = _animation.value;
      });
    });
    getAddress();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();
  }

  /// Calculates and runs a [SpringSimulation].
  void _runAnimation(Offset pixelsPerSecond, Size size) {
    _animation = _animationController.drive(
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment.center,
      ),
    );
    // Calculate the velocity relative to the unit interval, [0,1],
    // used by the animation controller.
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _animationController.animateWith(simulation);
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return (12742 * asin(sqrt(a))).roundToDouble();
  }

  Widget distanceTravelled() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${widget.rideInfo['stopDuration']}',
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w800,
              color: textColor,
              fontFamily: fontText),
        ),
        Text(
          'TIME SPENT',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
              fontFamily: fontText),
        )
      ],
    );
  }

  String calculateTime(_timestamp) {
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
    } else {
      if (int.parse(hour) == 0) {
        return '00:$min AM';
      } else if (int.parse(hour) == 12) {
        return '12:$min PM';
      } else if (int.parse(hour) > 12) {
        return '${int.parse(hour) - 12}:$min PM';
      } else {
        return '$hour:$min AM';
      }
    }
  }

  Widget weekDay() {
    Map<int, String> week = {
      1: 'MON',
      2: 'TUE',
      3: 'WED',
      4: 'THU',
      5: 'FRI',
      6: 'SAT',
      7: 'SUN'
    };
    Timestamp timestamp = widget.rideInfo['startTime'];
    int day = timestamp.toDate().weekday;
    return Text('${week[day]}',
        style: TextStyle(
            color: Colors.white,
            fontFamily: fontText,
            fontSize: 15,
            fontWeight: FontWeight.bold));
  }

  Widget date() {
    Timestamp timestamp = widget.rideInfo['startTime'];
    int day = timestamp.toDate().day;
    return Text('${day}',
        style: TextStyle(
            color: textColor,
            fontFamily: fontText,
            fontSize: 17,
            fontWeight: FontWeight.bold));
  }

  Widget journeyDate() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: textColor),
          borderRadius: BorderRadius.circular(5)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              decoration: BoxDecoration(
                  border: Border.all(color: textColor), color: textColor),
              child: weekDay()),
          date()
        ],
      ),
    );
  }

  Widget top() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [distanceTravelled(), journeyDate()],
    );
  }

  Widget mapCard() {
    final List<Marker> markers = [
      Marker(
          markerId: const MarkerId('source'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          position: LatLng(
              widget.rideInfo['source'][0], widget.rideInfo['source'][1])),
      Marker(
          markerId: const MarkerId('destination'),
          icon: BitmapDescriptor.defaultMarker,
          position: LatLng(widget.rideInfo['destination'][0],
              widget.rideInfo['destination'][1])),
    ];
    return AbsorbPointer(
      absorbing: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
        child: Container(
          height: 170,
          width: double.infinity,
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          child: Card(
              elevation: 1,
              color: Colors.black,
              child: GoogleMap(
                liteModeEnabled: true,
                zoomControlsEnabled: false,
                initialCameraPosition: CameraPosition(
                    target: LatLng(widget.rideInfo['source'][0],
                        widget.rideInfo['source'][1]),
                    zoom: 7.5),
                markers: Set<Marker>.of(markers),
                mapType: MapType.normal,
              )),
        ),
      ),
    );
  }

  Widget pointTile(String type, String title, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          // borderRadius: BorderRadius.circular(15)
        ),
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Icon(
                  Icons.circle,
                  size: 15,
                  color:
                      type == 'source' ? Colors.greenAccent : Colors.redAccent,
                ),
              ),
              SizedBox(
                width: 2,
              ),
              Expanded(
                child: SizedBox(
                  // width: MediaQuery.of(context).size.width - 200,
                  child: Text(
                    title,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        // letterSpacing: 1,
                        fontSize: 17,
                        color: textColor,
                        fontFamily: fontText,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Text(
                time,
                style: TextStyle(
                    fontSize: 17,
                    fontFamily: fontText,
                    color: textColor,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 4,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget sourceAndDestin() {
    return Column(
      children: [
        pointTile(
            'source', source, calculateTime(widget.rideInfo['startTime'])),
        pointTile('destination', destination,
            calculateTime(widget.rideInfo['endTime']))
      ],
    );
  }

  Widget footer() {
    var height = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12)),
          color: Colors.grey),
      height: 50,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () async {},
              child: Padding(
                padding: EdgeInsets.fromLTRB(6, 0, 6, 0),
                child: Icon(Icons.location_on_rounded),
              ),
            ),
          ],
        ),
        InkWell(
          onTap: (() {
            setState(() {
              isExpanded = !isExpanded;
            });
          }),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
            child: MaterialButton(
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: Text(
                'RATE NOW',
                style: TextStyle(
                    fontFamily: fontText,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: (() {
            DatabaseMethods()
                .deleteActivity(widget.userUID, widget.rideInfo['uid']);
            setState(() {
              isDeleted = true;
            });
          }),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
            child: Icon(Icons.delete),
          ),
        )
      ]),
    );
  }

  Widget markButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MaterialButton(
          color: widget.rideInfo['markType'] == 'Do More'
              ? Colors.grey
              : Colors.white,
          onPressed: () {
            setState(() {
              widget.rideInfo['markType'] = 'Do More';
            });
            DatabaseMethods().updateMarkType(
                widget.rideInfo['uid'], widget.userUID, 'Do More');
          },
          child: Text('Do More',
              style: TextStyle(
                color: widget.rideInfo['markType'] == 'Do More'
                    ? Colors.white
                    : textColor,
                fontFamily: fontText,
              )),
          // color: Colors.grey,
        ),
        MaterialButton(
          color: widget.rideInfo['markType'] == 'Do Less'
              ? Colors.grey
              : Colors.white,
          onPressed: () {
            setState(() {
              widget.rideInfo['markType'] = 'Do Less';
            });
            DatabaseMethods().updateMarkType(
                widget.rideInfo['uid'], widget.userUID, 'Do Less');
          },
          child: Text('Do Less',
              style: TextStyle(
                color: widget.rideInfo['markType'] == 'Do Less'
                    ? Colors.white
                    : textColor,
                fontFamily: fontText,
              )),
        ),
      ],
    );
  }

  Widget rateActivity(var height) {
    List<Widget> star = [];
    if (widget.rideInfo['rating'] == 'NA') {
      for (var i = 0; i < 5; i++) {
        star.add(InkWell(
          onTap: () {
            setState(() {
              widget.rideInfo['rating'] = i + 1;
              DatabaseMethods().updateRideRating(
                  widget.rideInfo['uid'], widget.userUID, i + 1);
              // isExpanded = !isExpanded;
            });
          },
          child: Icon(
            Icons.star_border,
            color: Colors.grey,
            size: 35,
          ),
        ));
      }
    } else {
      for (var i = 0; i < widget.rideInfo['rating']; i++) {
        star.add(InkWell(
          onTap: () {
            setState(() {
              widget.rideInfo['rating'] = i + 1;
              DatabaseMethods().updateRideRating(
                  widget.rideInfo['uid'], widget.userUID, i + 1);
              // isExpanded = !isExpanded;
            });
          },
          child: Icon(
            Icons.star,
            color: Colors.amberAccent,
            size: 35,
          ),
        ));
      }
      for (var i = widget.rideInfo['rating']; i < 5; i++) {
        star.add(InkWell(
          onTap: () {
            setState(() {
              widget.rideInfo['rating'] = i + 1;
              DatabaseMethods().updateRideRating(
                  widget.rideInfo['uid'], widget.userUID, i + 1);
              // isExpanded = !isExpanded;
            });
          },
          child: Icon(
            Icons.star_border,
            color: Colors.grey,
            size: 35,
          ),
        ));
      }
    }

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // crossAxisAlignment: CrossAxisAlignment.,
        children: star,
      ),
    );
  }

  Widget subCategoriesList(String type) {
    String subtype = widget.rideInfo['sub-category'];

    return Container(
      height: MediaQuery.of(context).size.height / 2.7,
      width: MediaQuery.of(context).size.width / 1.5,
      child: ListView.builder(
        itemCount: type == 'Business'
            ? businessSubCategory.length
            : personalSubCategory.length,
        itemBuilder: ((context, i) {
          return InkWell(
            onTap: () {
              DatabaseMethods().updateRideCategory(
                  widget.rideInfo['uid'],
                  widget.userUID,
                  type,
                  type == 'Business'
                      ? businessSubCategory[i]
                      : personalSubCategory[i]);
              setState(() {
                widget.rideInfo['category'] = type;
                widget.rideInfo['sub-category'] = type == 'Business'
                    ? businessSubCategory[i]
                    : personalSubCategory[i];
                swapped = !swapped;
                _dragAlignment = Alignment.center;
              });
              Navigator.pop(context);
            },
            child: Container(
              height: 45,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${i + 1}. '),
                      Text(
                        type == 'Business'
                            ? '${businessSubCategory[i]}'
                            : '${personalSubCategory[i]}',
                        style: TextStyle(
                            color: textColor, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  if ((type == 'Business' &&
                          widget.rideInfo['sub-category'] ==
                              businessSubCategory[i]) ||
                      (type == 'Personal' &&
                          widget.rideInfo['sub-category'] ==
                              personalSubCategory[i]))
                    Icon(
                      Icons.done,
                      color: Colors.blueAccent,
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Future markSubCategory(String type, var height) {
    setState(() {
      leftSwipe ? leftSwipe = !leftSwipe : rightSwipe = !rightSwipe;
    });
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async {
              setState(() {
                swapped = !swapped;
                _dragAlignment = Alignment.center;
              });
              return true;
            },
            child: AlertDialog(
                scrollable: true,
                title: Text(type),
                content: subCategoriesList(type)),
          );
        });
  }

  Widget personal() {
    return Container(
      width: 80,
      height: 60,
      decoration: BoxDecoration(
          color: Colors.purple,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), bottomLeft: Radius.circular(25))),
      // ignore: prefer_const_constructors
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.work,
            color: Colors.white,
          ),
          Text(
            'Personal',
            style: TextStyle(fontFamily: fontText, color: Colors.white),
          )
        ],
      ),
    );
  }

  Widget businessIcon() {
    return Container(
      width: 80,
      height: 60,
      decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(25), bottomRight: Radius.circular(25))),
      // ignore: prefer_const_constructors
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.work,
            color: Colors.white,
          ),
          Text(
            'Business',
            style: TextStyle(fontFamily: fontText, color: Colors.white),
          )
        ],
      ),
    );
  }

  Widget activityCard(var size) {
    return GestureDetector(
      onPanDown: (details) {
        _animationController.stop();
      },
      onPanUpdate: (details) {
        setState(() {
          _dragAlignment += Alignment(
            details.delta.dx / (size.width / 2),
            details.delta.dy / (size.height / 2),
          );
          print(_dragAlignment);
          if (_dragAlignment.x < -0.5 && !swapped) {
            setState(() {
              swapped = !swapped;
              leftSwipe = !leftSwipe;
            });
            // User swiped Left
            Timer(Duration(milliseconds: 300), () {
              // DatabaseMethods().updateRideCategory(
              // widget.rideInfo['uid'], widget.userUID, 'Personal', 'Meetup');
              setState(() {
                // widget.rideInfo['category'] = 'Personal';
                // widget.rideInfo['category'] = 'Meetup';
                markSubCategory('Personal', size.height);
              });
            });
            print('left');
          } else if (_dragAlignment.x > 0.5 && swapped == false) {
            // User swiped Right
            setState(() {
              swapped = !swapped;
              rightSwipe = !rightSwipe;
            });
            print('right');
            Timer(Duration(milliseconds: 300), () {
              // DatabaseMethods().updateRideCategory(widget.rideInfo['uid'],
              // widget.userUID, 'Business', 'Meeting');
              setState(() {
                // widget.rideInfo['category'] = 'Business';
                // widget.rideInfo['category'] = 'Meeting';
                markSubCategory('Business', size.height);
              });
            });
          }
        });
      },
      onPanEnd: (details) {
        _runAnimation(details.velocity.pixelsPerSecond, size);
      },
      child: Align(
        alignment: _dragAlignment,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
          child: Container(
            // width: max(size.width - 70, 300),
            width: 350,
            child: AnimatedContainer(
              curve: Curves.fastOutSlowIn,
              duration: Duration(milliseconds: 500),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              height: isExpanded ? 515 : 425,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                surfaceTintColor: Colors.black,
                shadowColor: Colors.black,
                elevation: 10,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [top(), mapCard(), sourceAndDestin()],
                      ),
                    ),
                    footer(),
                    isExpanded
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              rateActivity(size.height),
                              markButton()
                            ],
                          )
                        : const SizedBox()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      // child: Align(
      //   alignment: _dragAlignment,
      //   child: Card(
      //     child: FlutterLogo(),
      //   ),
      // ),
    );
  }

  Widget main() {
    if (leftSwipe) {
      return Stack(
        children: [
          Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                  height: isExpanded ? 480 : 450,
                  child: Align(
                      alignment: Alignment.centerRight, child: personal()))),
          Positioned(
              right: 80,
              // bottom: 50,
              child: activityCard(MediaQuery.of(context).size)),
        ],
      );
    }
    if (rightSwipe) {
      return Stack(
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                  height: isExpanded ? 480 : 450,
                  child: Align(
                      alignment: Alignment.centerLeft, child: businessIcon()))),
          Positioned(
              left: 80,
              // bottom: 50,
              child: activityCard(MediaQuery.of(context).size))
        ],
      );
      // return Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //   children: [businessIcon(), activityCard(MediaQuery.of(context).size)],
      // );
    }

    return activityCard(MediaQuery.of(context).size);
  }

  @override
  Widget build(BuildContext context) {
    return isDeleted ? Container() : main();
  }
}
