import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String email;
  String uid;
  String username;
  Timestamp createdAt;

  UserModel({this.email, this.uid, this.username, this.createdAt});

  String get usersname => username;

  Map setUser(UserModel user) {
    var data = Map<String, dynamic>();

    data["uid"] = user.uid;
    data["username"] = user.username;
    data["email"] = user.email;
    data["createdAt"] = user.createdAt;

    return data;
  }

  // factory UserModel.getUser(Map<dynamic, dynamic> mapData) {
  //   mapData = mapData ?? {};
  //   return UserModel(
  //     uid: mapData['uid'] ?? '',
  //     username: mapData['username'] ?? '',
  //     email: mapData['email'] ?? '',
  //     createdAt: mapData['createdAt'] ?? DateTime.now(),
  //   );
  //   // this.uid = mapData["uid"];
  //   // this.username = mapData["username"];
  //   // this.email = mapData["email"];
  // }

  UserModel.getUserDetails(Map<dynamic, dynamic> mapData)
      : uid = mapData["uid"] ?? '',
        username = mapData["username"] ?? "",
        email = mapData["email"] ?? "",
        createdAt = mapData["createdAt"] ?? "";

        @override
  String toString() {
    return '{ ${this.createdAt}, ${this.email}, ${this.username}, ${this.uid} }';
  }
}
