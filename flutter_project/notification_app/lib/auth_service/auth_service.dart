import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev_task/database/database.dart';
import 'package:dev_task/models/user.dart';
import 'package:dev_task/screens/home.dart';
import 'package:dev_task/screens/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return Home();
        } else {
          return SignInPage();
        }
      },
    );
  }

  signout() {
    FirebaseAuth.instance.signOut();
  }

  signin(String email, String password, context) {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((val) => {print('Signed In')});
  }

  signUp(String email, String password, String name) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      if (value.user!.uid != '') {
        UseR useR = UseR(email: email, name: name, uid: value.user!.uid);
        DatabaseMethods().createUser(useR);
      }
    });
  }

  resetPass(String email) {
    return FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Future getCurrentUser() async {
    return FirebaseAuth.instance.currentUser;
  }

  getCurrentUserUid() async {
    return FirebaseAuth.instance.currentUser?.uid;
  }
}
