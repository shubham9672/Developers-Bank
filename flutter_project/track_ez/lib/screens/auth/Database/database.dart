import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class DatabaseMethods {
  final firestore = FirebaseFirestore.instance;

  createUserDatabase(name, email, uid) async {
    Map<String, dynamic> user = {
      "name": name,
      "email": email.toLowerCase(),
      "uid": uid,
      "phone": 'Enter your Mobile Number',
    };
    await firestore.collection('users').doc(uid).set(user);

    return user;
  }

  findUserWithEmail(email) async {
    var user = {};
    await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        user = value.docs[0].data();
      }
    });
    return user;
  }

  addRide(Map<String, dynamic> rideInfo, String uid) {
    return firestore
        .collection('users')
        .doc(uid)
        .collection('activity')
        .doc()
        .set(rideInfo);
  }

  Future getClassifiedRide(String userUID) async {
    List<dynamic> activities = [];
    await firestore
        .collection('users')
        .doc(userUID)
        .collection('activity')
        .where('category', isNotEqualTo: 'unclassified')
        .orderBy('category')
        .orderBy('startTime', descending: true)
        .get()
        .then((value) {
      for (var i = 0; i < value.docs.length; i++) {
        String id = value.docs[i].id;
        activities.add(value.docs[i].data());
        activities[i]['uid'] = id;
      }
    });
    return activities;
  }

  Future getUnclassifiedRide(String userUID) async {
    List<dynamic> activities = [];
    await firestore
        .collection('users')
        .doc(userUID)
        .collection('activity')
        .where('category', isEqualTo: 'unclassified')
        .orderBy('startTime', descending: true)
        .get()
        .then((value) {
      for (var i = 0; i < value.docs.length; i++) {
        String id = value.docs[i].id;
        activities.add(value.docs[i].data());
        activities[i]['uid'] = id;
      }
    });
    return activities;
  }

  updateRideCategory(String rideUID, String userUID, String newCategory,
      String newSubCategory) {
    firestore
        .collection('users')
        .doc(userUID)
        .collection('activity')
        .doc(rideUID)
        .update({'category': newCategory, 'sub-category': newSubCategory});
  }

  updateRideRating(String rideUID, String userUID, int newRating) {
    firestore
        .collection('users')
        .doc(userUID)
        .collection('activity')
        .doc(rideUID)
        .update({'rating': newRating});
  }

  updateMarkType(String rideUID, String userUID, String markType) {
    firestore
        .collection('users')
        .doc(userUID)
        .collection('activity')
        .doc(rideUID)
        .update({'markType': markType});
  }

  deleteActivity(String userUID, String rideUID) {
    firestore
        .collection('users')
        .doc(userUID)
        .collection('activity')
        .doc(rideUID)
        .delete();
  }
}
