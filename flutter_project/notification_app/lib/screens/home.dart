import 'dart:async';
import 'package:dev_task/auth_service/auth_service.dart';
import 'package:dev_task/database/database.dart';
import 'package:dev_task/models/custom_text.dart';
import 'package:dev_task/models/notification.dart';
import 'package:dev_task/screens/add_friend.dart';
import 'package:dev_task/screens/groups_list.dart';
import 'package:dev_task/screens/notifications.dart';
import 'package:dev_task/screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:notifications/notifications.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late String userUID;
  late TabController _tabController;
  Notifications? _notifications;
  StreamSubscription<NotificationEvent>? _subscription;
  NotificatioN notificatioN = NotificatioN(
      appName: '', title: '', message: '', timestamp: DateTime.now());
  bool isLoading = true;
  void onData(NotificationEvent event) {
    try {
      if (event.packageName!.trim().isEmpty ||
          event.title!.trim().isEmpty ||
          event.message!.trim().isEmpty) {
        return;
      }
      if (event.packageName != notificatioN.appName ||
          (event.title != notificatioN.title &&
              event.message != notificatioN.message)) {
        NotificatioN newNotifi = NotificatioN(
            appName: event.packageName!,
            title: event.title!,
            message: event.message!,
            timestamp: event.timeStamp!);
        setState(() {
          notificatioN = newNotifi;
        });
        DatabaseMethods().saveNotification(newNotifi, userUID);
        print(event.toString());
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> initPlatformState() async {
    startListening();
  }

  void startListening() {
    _notifications = Notifications();
    try {
      _subscription = _notifications!.notificationStream!.listen(onData);
    } on NotificationException catch (exception) {
      print(exception);
    }
  }

  void stopListening() {
    _subscription?.cancel();
  }

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    initPlatformState();
    AuthService().getCurrentUser().then((value) {
      setState(() {
        userUID = value.uid;
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            child: Center(
              child: MyText(data: 'Fetching data'),
            ),
          )
        : GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: SafeArea(
                child: Scaffold(
              appBar: AppBar(
                  title: Text(
                    'Dev Test',
                    style: TextStyle(fontSize: 24),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(15))),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(60),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TabBar(
                          labelColor: Colors.blue,
                          unselectedLabelColor: Colors.white,
                          padding: const EdgeInsets.all(8),
                          isScrollable: true,
                          indicatorSize: TabBarIndicatorSize.tab,
                          controller: _tabController,
                          indicator: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          tabs: [
                            Container(
                                alignment: Alignment.center,
                                height: 30,
                                child: const Text(
                                  'Chats',
                                )),
                            Container(
                                alignment: Alignment.center,
                                height: 30,
                                child: const Text(
                                  'Add',
                                )),
                            Container(
                                alignment: Alignment.center,
                                height: 30,
                                child: const Text(
                                  'Settings',
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  actions: [
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      AllNotifications(
                                        userUID: userUID,
                                      )));
                        },
                        icon: Icon(Icons.notifications))
                  ]),
              body: TabBarView(controller: _tabController, children: [
                GroupsList(
                  userUID: userUID,
                ),
                AddFriend(
                  userUID: userUID,
                ),
                Settings()
              ]),
            )),
          );
  }
}
