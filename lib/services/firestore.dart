import 'package:flutter/material.dart';
import 'package:trove_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreNotifier extends ChangeNotifier {
  FirebaseFirestore _firebaseFirestore;
  // bool _useFirestoreEmulator = true;
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

  Future<void> addDefaultPortfolio(
      {var json, String collection, String document}) async {
    try {
      await _firebaseFirestore.collection(collection).doc(document).set({
        'defaultData': json,
      });
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  ///get list of all portfolio
  Future getUserPortfolio(String uid) async {

    ///TODO: change document string path to ['document-$uid']
    try {
      var data = await _firebaseFirestore
          .collection('portfolio')
          .doc('document$uid')
          .get();
      print('User portfolio: ${data.data()}');
      // return portfolioFromJson(data.data()['defaultData']);
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future getPortfolioValue(String uid) async {
    try {
      var data = await _firebaseFirestore
          .collection('portfolio')
          .doc('document$uid')
          .get();
      //
      var portfolioList = List.castFrom(data.data()['defaultData']);

      //
      double value = 0;

      // adds all equity value
      for (int i = 0; i < portfolioList.length; i++) {
        value += portfolioList[i]['equityValue'];
      }

      print('Sum equity: $value');

      String valueString = value.toString();

      // returns an amount with comma
      return valueString.replaceAllMapped(
          new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');

    } on FirebaseException catch (e) {
      print(e);
    }
  }
}
