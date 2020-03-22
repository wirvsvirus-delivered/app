// Based on https://github.com/tattwei46/flutter_login_demo/blob/master/lib/services/authentication.dart

import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<String> signUp(String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();

  Future<bool> isAccountInfoCompleted();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;

  Future<String> signIn(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  Future<String> signUp(String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  Future<bool> isAccountInfoCompleted() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return _firestore
        .collection("users")
        .document(user.uid)
        .get()
        .then((DocumentSnapshot ds) {
      return ds.data["complete"];
    });
  }

  Future<Map<String, dynamic>> getAccountInfoStatus() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return _firestore
        .collection("users")
        .document(user.uid)
        .get()
        .then((DocumentSnapshot ds) {
      return <String, dynamic>{
        "fname": ds.data["fname"],
        "lname": ds.data["lname"],
        "street": ds.data["street"],
        "number": ds.data["number"],
        "zip": ds.data["zip"],
        "birth": ds.data["birth"],
      };
    });
  }
}
