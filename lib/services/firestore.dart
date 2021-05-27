import 'package:flutter/material.dart';
import 'package:trove_app/models/portfolio_position.dart';
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

    try{
    var data = await _firebaseFirestore.collection('users').doc(uid).get();
    print(data.data());

    return UserModel.getUserDetails(data.data());

    } on FirebaseException catch (e){
      print(e);
    }
    
    // .map((snap) => UserModel.getUser(snap.data()));
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
      return convertMapToList(data.data()['defaultData']);
    } on FirebaseException catch (e) {
      print(e);
    }
    // return sna
  }

  // Stream<List<Portfolio>> get portfolioData {
  //   return _firebaseFirestore
  //       .collection('portfolio')
  //       .snapshots()
  //       .map(portfolio);
  // }

  // List<Portfolio> portfolio(QuerySnapshot snapshot) {
  //   snapshot.docs.map((doc) {
  //     List<Portfolio> newList = [];
  //     List<dynamic> portfolioMap = doc.data()['defaultData'];
  //     portfolioMap.forEach((element) {
  //       newList.add(
  //         Portfolio(
  //           equityValue: element['equityValue'],
  //           totalQuantity: element['totalQuantity'],
  //           pricePerShare: element['pricePerShare'],
  //           symbol: element['symbol'],
  //         ),
  //       );
  //     });
  //     return newList;
  //   });
  // }

  convertMapToList(List data) {
    var list = [];
    for (var i = 0; i < data.length; i++) {
      Map<dynamic, dynamic> currentElement = data[i];
      // currentElement.forEach((key, value) => list.add())
      list.add(Portfolio.fromMap(currentElement));
    }
    return list;
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
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
    } on FirebaseException catch (e) {
      print(e);
    }
  }
}
