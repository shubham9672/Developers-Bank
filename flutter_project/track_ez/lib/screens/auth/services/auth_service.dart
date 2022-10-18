// ignore_for_file: avoid_print, unnecessary_import, unused_element

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:track_ez/screens/auth/Database/database.dart';

import '../../../export.dart';

class AuthService {
  handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          // ignore: prefer_const_constructors
          return HomePage();
        } else {
          return const signInPage();
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
        DatabaseMethods().createUserDatabase(name, email, value.user?.uid);
      }
    });
    // DatabaseMethods().createUserDatabase(name, email, )
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
