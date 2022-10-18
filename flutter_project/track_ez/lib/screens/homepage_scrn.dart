// ignore_for_file: unused_import, avoid_print, non_constant_identifier_names

import 'dart:async';
import 'dart:developer';
import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:track_ez/constants.dart';
import 'package:track_ez/export.dart';
import 'package:track_ez/screens/activity.dart';
import 'package:track_ez/screens/auth/Database/database.dart';
import 'package:track_ez/screens/unclassified.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic> rides = {
    'category': 'unclassified',
    'startTime': '',
    'endTime': '',
    'sub-category': '',
    'source': [],
    'destination': [],
    'rating': 'NA',
    'markType': '',
    'stopDuration': ''
  };
  List<Marker> _markers = [];
  Stopwatch watch = Stopwatch();
  late Timer timer;
  LocationData? currentLocation;
  String elapsedTime = '';
  bool startTimer = false;
  String uid = '';
  Stopwatch watch2 = Stopwatch();
  bool isStop = false;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  double velocity = 0;
  double highestVelocity = 0.0;
  void getCurrentLocation() {
    setState(() {
      Location location = Location();
      location.getLocation().then((location) {
        currentLocation = location;
        setState(() {});
        print(currentLocation.toString());
      });
    });
  }

  Future<void> onSelectNotification() async {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return Unclassified(
        userUID: uid,
      );
    }));
    // return true;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    var initializationSettingsIOs = IOSInitializationSettings();
    var initSetttings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: ((payload) {
      onSelectNotification();
    }));

    AuthService().getCurrentUser().then((value) {
      setState(() {
        uid = value.uid;
      });
    });
    FlutterBackground.enableBackgroundExecution();
    backgroundService();
    userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      _onAccelerate(event);
    });
    getCurrentLocation();

    super.initState();
  }

  showNotification() async {
    var android = AndroidNotificationDetails('id', 'channel ',
        priority: Priority.high, importance: Importance.max);
    var iOS = IOSNotificationDetails();
    var platform = NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(
        0, 'Activity Completed', 'Rate your Activity', platform,
        payload: 'abc');
  }

  backgroundService() async {
    // ignore: prefer_const_constructors
    final androidConfig = FlutterBackgroundAndroidConfig(
      notificationTitle: "Tracking ",
      notificationText: "Tracking Your location",
      notificationImportance: AndroidNotificationImportance.High,
      // ignore: prefer_const_constructors
      notificationIcon: AndroidResource(
          name: 'background_icon',
          defType: 'drawable'), // Default is ic_launcher from folder mipmap
    );

    await FlutterBackground.initialize(androidConfig: androidConfig);
  }

  void _onAccelerate(UserAccelerometerEvent event) {
    double newVelocity =
        sqrt(event.x * event.x + event.y * event.y + event.z * event.z);

    if ((newVelocity - velocity).abs() < 1) {
      return;
    }
    setState(() {
      velocity = newVelocity;
      highestVelocity = max(velocity, highestVelocity);
    });
    print(velocity);
    if (_markers.length == 1 && newVelocity < 1 && !isStop) {
      watch2.start();
      setState(() {
        isStop = true;
      });
      Timer timer2 = Timer.periodic(const Duration(milliseconds: 500), (t) {
        print('timer2');
        if (newVelocity < 5 && watch2.elapsed.inMinutes >= 1) {
          print('reached at destination');
          addDestinationMarker();
          t.cancel();
        } else if (newVelocity > 20 && watch.elapsed.inMinutes < 15) {
          watch2.stop();
          watch2.reset();
          setState(() {
            isStop = false;
          });
          t.cancel();
        } else if (newVelocity > 1) {}
      });
    } else if (newVelocity > 20) {
      ifInMotion();
    }
  }

  ifInMotion() {
    if (_markers.length == 2 && isStop && velocity.toInt() > 20) {
      rides['stopDuration'] =
          transformMilliSeconds(watch2.elapsed.inMilliseconds);
      DatabaseMethods().addRide(rides, uid);
      showNotification();
      End();
      _markers.clear();
      print("New Journey Started");
      addSourceMarker();
      watch.start();
    } else if (velocity.toInt() > 20 && _markers.isEmpty) {
      print("Journey Started");
      addSourceMarker();
      watch.start();
      // StartArrivalTracking();
    }
  }

  StartArrivalTracking() {
    watch.start();
    if (velocity < 20) {
      setState(() {
        addDestinationMarker();
        startWatch();
      });
    } else {
      return ifInMotion();
    }
  }

  addSourceMarker() {
    getCurrentLocation();
    print("Source Marker");
    setState(() {
      _markers.add(Marker(
        markerId: const MarkerId('source'),
        position:
            LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
      ));
      rides['source'] = [
        currentLocation!.latitude!,
        currentLocation!.longitude!
      ];
      rides['startTime'] = DateTime.now();
      print(_markers);
    });
  }

  addDestinationMarker() {
    getCurrentLocation();
    setState(() {
      // startWatch();
      _markers.add(
        Marker(
            markerId: const MarkerId('destination'),
            position: LatLng(
                currentLocation!.latitude!, currentLocation!.longitude!)),
      );
      rides['destination'] = [
        currentLocation!.latitude!,
        currentLocation!.longitude!
      ];
      rides['endTime'] = DateTime.now();
    });
  }

  End() {
    watch.stop();
    watch.reset();
    watch2.stop();
    watch2.reset();
    _markers.clear();
    setState(() {
      isStop = false;
    });
  }

  startOrStop() {
    if (startTimer) {
      startWatch();
    } else {
      stopWatch();
    }
  }

  stopWatch() {
    setState(() {
      watch.stop();
      setTime();
    });
  }

  setTime() {
    var timeSoFar = watch.elapsedMilliseconds;
    setState(() {
      elapsedTime = transformMilliSeconds(timeSoFar);
    });
  }

  startWatch() {
    setState(() {
      watch.start();
      timer = Timer.periodic(const Duration(milliseconds: 100), updateTime);
    });
  }

  updateTime(Timer timer) {
    if (watch.isRunning) {
      setState(() {
        elapsedTime = transformMilliSeconds(watch.elapsedMilliseconds);
      });
    }
  }

  transformMilliSeconds(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();
    int hours = (minutes / 60).truncate();

    String hoursStr = (hours % 60).toString().padLeft(2, '0');
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    return "$hoursStr:$minutesStr:$secondsStr";
  }

  Widget _home() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Take a Drive',
            style:
                TextStyle(fontFamily: fontText, fontSize: 24, color: textColor),
          ),
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.swap_vert_circle_outlined,
                  color: textColor,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Logs automatically. No start/stop required.',
                    style: TextStyle(
                        fontFamily: fontText, fontSize: 13, color: textColor),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.phone_android,
                  color: textColor,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Works while running in the background.      ',
                    style: TextStyle(
                        fontFamily: fontText, fontSize: 13, color: textColor),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.access_time_rounded,
                  color: textColor,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Drives appear several minutes after arrival.',
                    style: TextStyle(
                        fontFamily: fontText, fontSize: 13, color: textColor),
                  ),
                )
              ],
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 150,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: textColor),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.circle,
                    color: Colors.greenAccent,
                    size: 15,
                  ),
                  Text(
                    'TrackEZ is Ready',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: fontText,
                        fontSize: 15),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // const LatLng sourceLocation = LatLng(37.33500926, -122.03272188);
    // const LatLng destination = LatLng(37.33429383, -122.06600055);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text("Track EZ",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: fontText,
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
          centerTitle: true,
          elevation: 0.5,
          actions: [
            IconButton(
                onPressed: addSourceMarker, icon: const Icon(Icons.bar_chart))
          ],
        ),
        drawer: Drawer(
          width: max(MediaQuery.of(context).size.width / 1.8, 220),
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.grey,
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 30,
                      ),
                      Text(
                        'TrackEZ',
                        style: TextStyle(
                            fontFamily: fontText,
                            color: Colors.white,
                            fontSize: 30),
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.car_crash,
                ),
                title: const Text('Unclassified',
                    style: TextStyle(
                        color: Color.fromARGB(255, 116, 116, 116),
                        fontFamily: fontText,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Unclassified(
                                userUID: uid,
                              )));
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.car_crash,
                ),
                title: const Text('Activity',
                    style: TextStyle(
                        color: Color.fromARGB(255, 116, 116, 116),
                        fontFamily: fontText,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Activity(
                                userUID: uid,
                              )));
                },
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: const Text('Sign out',
                    style: TextStyle(
                        color: Color.fromARGB(255, 116, 116, 116),
                        fontFamily: fontText,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                onTap: () {
                  AuthService().signout();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: _home(),
      ),
    );
  }

  Widget MapCard() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        height: 300,
        width: double.infinity,
        child: Card(
            elevation: 1,
            color: Colors.black,
            child: currentLocation == null
                ? const Center(
                    child: Text("Loading"),
                  )
                : GoogleMap(
                    initialCameraPosition: CameraPosition(
                        target: LatLng(currentLocation!.latitude!,
                            currentLocation!.longitude!),
                        zoom: 13),
                    markers: Set<Marker>.of(_markers),
                    mapType: MapType.normal,
                  )),
      ),
    );
  }
}
