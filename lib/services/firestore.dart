import 'package:flutter/material.dart';
import 'package:trove_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreNotifier extends ChangeNotifier {
  FirebaseFirestore _firebaseFirestore;
  // bool _useFirestoreEmulator = true;
  Query _query;
  UserModel _userModel = UserModel();

  FirestoreNotifier.instance(this._firebaseFirestore);

  Future<void> addUserToDb({
    @required String uid,
    @required String email,
    @required String username,
    @required DateTime time,
  }) async {
    _userModel =
        UserModel(uid: uid, email: email, username: username, createdAt: time);
    try {
      await _firebaseFirestore
          .collection('users')
          .doc(uid)
          .set(_userModel.setUser(_userModel));
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Stream<UserModel> getUserFromDb({String uid}) {
    return _firebaseFirestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((snap) => UserModel.getUser(snap.data()));
    // print(doc.data().toString());
    // return UserModel.getUser(doc.data());
    // return doc;
  }

  Future<void> addDefaultPortfolio({var json, String collection, String document}) async {
    try {
      await _firebaseFirestore.collection(collection).doc(document).set({
        'defaultData': json,
      });
    } on FirebaseException catch (e) {
      print(e);
    }
  }
}
