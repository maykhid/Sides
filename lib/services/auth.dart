// user login statuses
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum Status {
  Unininitialized,
  Authenticated,
  Authenticating,
  Unauthenticated,
  NewUser
}

class Auth with ChangeNotifier {
  final FirebaseAuth _firebaseAuth;
  User _user;
  Status _status = Status.Unininitialized;
  bool _inProgress = false;
  String _message = '';
  // Firestrore store;

  Auth.instance(this._firebaseAuth) {
    _firebaseAuth.authStateChanges().listen(onAuthStateChanged);
    print('This is the status #on instantiating Auth -> ${_status.toString()}');
  }

  Status get status => _status;
  User get user => _user;
  bool get inProgress => _inProgress;
  String get message => _message;

  /// This function is to be called on cases where
  /// updating status is needed
  updateStatus(Status status) {
    _status = status;
    print('This is the status #on updateStatus Auth -> ${_status.toString()}');
    notifyListeners();
  }

  Future<String> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      updateStatus(Status.Authenticating);
      print(
          'This is the status #on createUserWithEmailAndPassword -> ${_status.toString()}');
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      return currentUser();
    } on FirebaseAuthException catch (e) {
      updateStatus(Status.Unauthenticated);
      if (e.code == 'weak-password') {
        print("The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        print("The account already exists for that email.");
      } else if (e.code == 'invalid-email') {
        print("Email is invalid");
      } else {
        print("Something Went Wrong.");
      }
    }
  }

  /// Returns currentUser uid

  currentUser() {
    _user = _firebaseAuth.currentUser;
    // notifyListeners();
    return _user?.uid;
  }

  // signInWithEmailAndPassword
  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      updateStatus(Status.Authenticating);
      print(
          'This is the status #on signInWithPassword -> ${_status.toString()}');
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return currentUser();
    } on FirebaseAuthException catch (e) {
      updateStatus(Status.Unauthenticated);
      print(
          'This is the status #on signInWithPassword -> ${_status.toString()}');
      if (e.code == 'user-not-found') {
        return "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        return "Wrong password provided for that user.";
      } else {
        return "Something Went Wrong.";
      }
    }
  }

  // change password
  Future<void> updatePassword(String newPassword) async {
    try {
      await _firebaseAuth.currentUser.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      print('updatePassword error: $e');
    }
  }

  // reset password
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      //
      if (e.code == 'auth/invalid-email') {
        print("Email address not valid.");
      } else if (e.code == 'auth/missing-android-pkg-name') {
        print(
            "An Android package name must be provided if the Android app is required to be installed.");
      } else if (e.code == 'auth/user-not-found') {
        print('This user does not exist');
      } else {
        print("Something Went Wrong.");
      }
    }
  }

  // confirm passwordReset
  Future<void> confirmPasswordReset(String code, String newPassword) async {
    try {
      await _firebaseAuth.confirmPasswordReset(
          code: code, newPassword: newPassword);
    } on FirebaseAuthException catch (e) {
      print('confirmPasswordReset error: $e');
    }
  }

  /// signOut
  Future<void> signOut() async {
    updateStatus(Status.Authenticating);
    try {
      await _firebaseAuth.signOut();
      updateStatus(Status.Unauthenticated);
    } on FirebaseAuthException catch (e) {
      print(e);
      updateStatus(Status.Authenticated);
    }

    
  }

  Future<void> onAuthStateChanged(User user) async {
    if (user == null) {
      updateStatus(Status.Unauthenticated);
      print('This is the status #onAuthStateChanged -> ${_status.toString()}');
    } else {
      _user = user;
      updateStatus(Status.Authenticated);
      print('This is the status #onAuthStateChanged -> ${_status.toString()}');
    }
  }

  // validate form and save
  bool validateAndSave(GlobalKey<FormState> formKey) {
    final FormState form = formKey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // runs validateAndSave() and submits depending on formType
  // e.g if formType == FormType.login perform signInWithEmailAndPassword
  Future<void> validateAndLogin(
      GlobalKey<FormState> formKey, String email, String password) async {
    try {
      if (validateAndSave(formKey)) {
        // if (formType == FormType.login) {
        final String userId = await signInWithEmailAndPassword(email, password);
        print('Logged In: $userId');
      }
    }
    // else {
    //   final String userId = await createUserWithEmailAndPassword(
    //       email, password, username, DateTime.now());
    //   print('Signed Up: $userId');
    // }
    catch (e) {
      print('Error: $e');
    }
  }
  // notifyListeners();

  Future<void> validateAndSignUp(GlobalKey<FormState> formKey, String email,
      String password, String username) async {
    try {
      if (validateAndSave(formKey)) {
        final String userId =
            await createUserWithEmailAndPassword(email, password);
        print('Signed Up: $userId');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
