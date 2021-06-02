import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:trove_app/services/auth.dart';

class MockUser extends Mock implements User {}

final MockUser _mockUser = MockUser();

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  @override
  Stream<User> authStateChanges() {
    return Stream.fromIterable([_mockUser]);
  }
}

void main() {
  final MockFirebaseAuth mockAuth = MockFirebaseAuth();

  final Auth auth = Auth.instance(mockAuth);

  setUp(() {});
  tearDown(() {});

  test('Create Account', () async {
    when(
      mockAuth.createUserWithEmailAndPassword(
          email: 'henryifebunandu@gmail.com', password: '123456'),
    ).thenAnswer((realInvocation) => null);

    expect(
        await auth.createUserWithEmailAndPassword(
            'henryifebunandu@gmail.com', '123456'),
        _mockUser.uid);
  });

  test('Sign In', () async {
    when(mockAuth.signInWithEmailAndPassword(
            email: 'henryifebunandu@gmail.com', password: '123456'))
        .thenAnswer((realInvocation) => null);

    expect(
        await auth.signInWithEmailAndPassword(
            'henryifebunandu@gmail.com', '123456'),
        _mockUser.uid);
  });

  test('Create user exception', () async {
    when(mockAuth.createUserWithEmailAndPassword(
            email: 'henryifebunandu@gmail.com', password: '123456')).thenThrow(FirebaseAuthException(code: "", message: "Something Went Wrong."));
        // .thenAnswer((realInvocation) => throw FirebaseAuthException( message: "Something Went Wrong."));

    expect(
        await auth.createUserWithEmailAndPassword(
            'henryifebunandu@gmail.com', '123456'),
        "Something Went Wrong.");
  });

  test('Sign In exception', () async {
    when(mockAuth.signInWithEmailAndPassword(
            email: 'henryifebunandu@gmail.com', password: '123456'))
        .thenAnswer((realInvocation) => throw FirebaseAuthException(
            code: "", message: "Something Went Wrong."));

    expect(
        await auth.signInWithEmailAndPassword(
            'henryifebunandu@gmail.com', '123456'),
        "Something Went Wrong.");
  });

  test('Sign out', () async {
    when(mockAuth.signOut()).thenAnswer((realInvocation) => null);

    expect(() => auth.signOut(), returnsNormally);
  });

  test('Sign out exception', () async {
    when(mockAuth.signOut()).thenAnswer((realInvocation) => throw FirebaseAuthException(code: '', message: "Something went wrong."));

    expect(() => auth.signOut(), returnsNormally);
  });
}
