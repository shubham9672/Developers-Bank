import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev_task/models/group.dart';
import 'package:dev_task/models/message.dart';
import 'package:dev_task/models/notification.dart';
import 'package:dev_task/models/user.dart';

class DatabaseMethods {
  final firestore = FirebaseFirestore.instance;

  createUser(UseR user) {
    firestore.collection('users').doc(user.uid).set(user.toData());
  }

  Future findUserWithEmail(String email) async {
    return firestore.collection('users').where('email', isEqualTo: email).get();
  }

  Future findUserWithUID(String userUID) async {
    return firestore.collection('users').doc(userUID).get();
  }

  addFriend(String userUID, String friendUID) {
    firestore.collection('users').doc(userUID).update({
      'friendList': FieldValue.arrayUnion([friendUID])
    });
    firestore.collection('users').doc(friendUID).update({
      'friendList': FieldValue.arrayUnion([userUID])
    });
  }

  Future getFriendsList(String userUID) async {
    List<dynamic> friendUIDs = [];
    await firestore.collection('users').doc(userUID).get().then((value) {
      if (!value.exists) return;
      friendUIDs = value.data()!['friendList'];
    });
    return friendUIDs;
  }

  saveNotification(NotificatioN notificatioN, String userUID) {
    firestore
        .collection('users')
        .doc(userUID)
        .collection('notifications')
        .doc()
        .set(notificatioN.toData());
  }

  Future getUnseenNotifications(String userUID) async {
    List<dynamic> notifications = [];
    await firestore
        .collection('users')
        .doc(userUID)
        .collection('notifications')
        .where('seen', isEqualTo: false)
        .orderBy('timestamp', descending: true)
        .get()
        .then((value) {
      for (var i = 0; i < value.docs.length; i++) {
        String id = value.docs[i].id;
        notifications.add(value.docs[i].data());
        notifications[i]['uid'] = id;
      }
    });
    return notifications;
  }

  Future getSeenNotifications(String userUID) async {
    List<dynamic> notifications = [];
    await firestore
        .collection('users')
        .doc(userUID)
        .collection('notifications')
        .where('seen', isEqualTo: true)
        .orderBy('timestamp', descending: true)
        .get()
        .then((value) {
      for (var i = 0; i < value.docs.length; i++) {
        String id = value.docs[i].id;
        notifications.add(value.docs[i].data());
        notifications[i]['uid'] = id;
      }
    });
    return notifications;
  }

  updateSeenNotification(String userUID, String notifUID) {
    firestore
        .collection('users')
        .doc(userUID)
        .collection('notifications')
        .doc(notifUID)
        .update({'seen': true});
  }

  deleteNotification(String userUID, String notifUID) {
    firestore
        .collection('users')
        .doc(userUID)
        .collection('notifications')
        .doc(notifUID)
        .delete();
  }

  createGroup(Group group) {
    firestore.collection('groups').doc().set(group.toData());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getGroupsList(String userUID) {
    return firestore
        .collection('groups')
        .where('users', arrayContains: userUID)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  sendMessage(Message message, String groupUID) {
    firestore
        .collection('groups')
        .doc(groupUID)
        .collection('chats')
        .doc()
        .set(message.toData());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getChats(String groupUID) {
    return firestore
        .collection('groups')
        .doc(groupUID)
        .collection('chats')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
  // getGroups(String userUID) {
  //   firestore
  //       .collection('groups')
  //       .where('users', arrayContains: userUID)
  //       .orderBy('timestamp', descending: true)
  //       .get()
  //       .then((value) {
  //     print('a');
  //     print(value.docs.first.data());
  //   });
  // }
}
