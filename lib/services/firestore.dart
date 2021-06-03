import 'package:flutter/material.dart';
import 'package:trove_app/extras/essentials.dart';
import 'package:trove_app/models/loan_model.dart';
import 'package:trove_app/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreNotifier extends ChangeNotifier {
  // bool _useFirestoreEmulator = true;
  UserModel _userModel = UserModel();
  EssentialFunctions _essentialFunctions = EssentialFunctions();
  bool _inProgress = false;
  String _message = '';

  FirebaseFirestore _firebaseFirestore;

  FirestoreNotifier.instance(this._firebaseFirestore);

  bool get inProgress => _inProgress;
  String get message => _message;

  /// Adds user details to database
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

  /// Gets user details
  // ignore: missing_return
  Future<UserModel> getUserFromDb({@required String uid}) async {
    try {
      var data = await _firebaseFirestore.collection('users').doc(uid).get();
      print(data.data());

      return UserModel.getUserDetails(data.data());
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  /// Adds dummy data for user
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

  /// Get list of portfolio
  Future getUserPortfolio(String uid) async {
    ///
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

  /// Get total portfolio value
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

  /// Gets a loan for user
  Future acquireLoan({
    // String collection,
    String document,
    var amount,
    var duration,
    var paid,
  }) async {
    try {
      updateStatus('Loading...', true);
      await _firebaseFirestore
          .collection('loans')
          .doc(document)
          .set({
            'loanData': {
              "amount": amount,
              "paid": paid,
              "duration": duration,
            },
          })
          .timeout(Duration(seconds: 20), onTimeout: () {
            throw Exception('Time out. Check connection');
          })
          .then((value) => updateStatus('Success', false))
          .onError((error, stackTrace) => updateStatus('$error', false));
      // .);
      // ;
    } on FirebaseException catch (e) {
      updateStatus('$e', false);
      print(e);
    }
  }

  /// Get user loan data
  // ignore: missing_return
  // Stream<Loan> userLoanStream(String uid, String document) {
  //   try {
  //     return _firebaseFirestore
  //         .collection('loans')
  //         .doc(document)
  //         .snapshots()
  //         .map((snap) => Loan.fromMap(snap.data()));
  //   } on FirebaseException catch (e) {}
  // }

  // ignore: missing_return
  Future<Loan> userLoanFuture(String uid) async {
    try {
      var loansData = await _firebaseFirestore
          .collection('loans')
          .doc('loansDoc$uid')
          .get();
      // .snapshots()
      // .map((snap) => Loan.fromMap(snap.data()));
      return Loan.fromMap(loansData.data()['loanData']);
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future updateUsername(String newUsername, String uid) async {
    try {
      updateStatus('Loading...', true);
      await _firebaseFirestore
          .collection('users')
          .doc(uid)
          .update({"username": newUsername}).whenComplete(() async {
        print("completed");
        updateStatus('Successful', false);
      }).catchError((e) {
        updateStatus('Write failed: $e', false);
        print(e);
      });
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  /// updates message and inProgress
  updateStatus(String message, bool inProgress) {
    _inProgress = inProgress;
    _message = message;
    notifyListeners();
    print('Message: $_message, inProgress: $_inProgress');
  }
}
