import 'package:flutter/material.dart';
import 'package:trove_app/extras/essentials.dart';
import 'package:trove_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreNotifier extends ChangeNotifier {
  FirebaseFirestore _firebaseFirestore;
  // bool _useFirestoreEmulator = true;
  UserModel _userModel = UserModel();
  EssentialFunctions _essentialFunctions = EssentialFunctions();

  FirestoreNotifier.instance(this._firebaseFirestore);

  Future<void> addUserToDb({
    @required String uid,
    @required String email,
    @required String username,
    @required Timestamp time,
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

  Future<UserModel> getUserFromDb({@required String uid}) async {
    try {
      var data = await _firebaseFirestore.collection('users').doc(uid).get();
      print(data.data());

      return UserModel.getUserDetails(data.data());
    } on FirebaseException catch (e) {
      print(e);
    }
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
      return _essentialFunctions.convertMapToList(data.data()['defaultData']);
    } on FirebaseException catch (e) {
      print(e);
    }
    // return sna
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

      return value.toInt().toString();
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future acquireLoan({
    String collection,
    String document,
    var amount,
    var duration,
    var paid,
  }) async {
    try {
      await _firebaseFirestore.collection(collection).doc(document).set({
        'loanData': {
          "amount": amount,
          "paid": paid,
          "duration": duration,
        },
      });
    } on FirebaseException catch (e) {
      print(e);
    }
  }
}
