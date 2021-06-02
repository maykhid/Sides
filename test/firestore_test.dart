import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:trove_app/models/user_model.dart';
import 'package:trove_app/services/firestore.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

// class MockCollectionReference extends Mock implements CollectionReference{}
class MockCollectionReference extends Mock implements CollectionReference {}

class MockDocumentReference extends Mock implements DocumentReference {}

class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}

void main() {
  final MockFirebaseFirestore mockFirebaseFirestore = MockFirebaseFirestore();
  // UserModel _userModel = UserModel();

  final FirestoreNotifier firestoreNotifier =
      FirestoreNotifier.instance(mockFirebaseFirestore);

  MockDocumentSnapshot mockDocumentSnapshot;
  MockCollectionReference mockCollectionReference;
  MockDocumentReference mockDocumentReference;

  setUp(() {
    // instance = MockFirestore();
    mockCollectionReference = MockCollectionReference();
    mockDocumentReference = MockDocumentReference();
    mockDocumentSnapshot = MockDocumentSnapshot();
  });
  //
  tearDown(() {
    // when(mockFirebaseFirestore.collection(any)).thenReturn(mockCollectionReference);
    // when(mockCollectionReference.doc(any)).thenReturn(mockDocumentReference);
    // when(mockDocumentReference.get()).thenAnswer((_) async => mockDocumentSnapshot);
    // when(mockDocumentSnapshot.data()).thenReturn(responseMap);
  });

  // tests write user
  // test('Adds user to db', () async {
  //   _userModel = UserModel(
  //       uid: 'uid',
  //       email: 'email',
  //       username: 'username',
  //       createdAt: Timestamp.now());

  //   // when(mockFirebaseFirestore.collection('collectionPath').doc('doc')).thenAnswer((realInvocation) => );

  //   // expect(() => firestoreNotifier.);

  //   when(mockFirebaseFirestore
  //           .collection('collectionPath')
  //           .doc('doc')
  //           .set(_userModel.setUser(_userModel)))
  //       .thenAnswer((realInvocation) => null);

  //   expect(
  //       () => firestoreNotifier.addUserToDb(
  //           uid: 'uid',
  //           email: 'email',
  //           username: 'username',
  //           time: Timestamp.now()),
  //       returnsNormally);
  // });

  test('Adds user to db', () async {
    when(mockFirebaseFirestore.collection(any))
        .thenReturn(mockCollectionReference);
    when(mockCollectionReference.doc(any)).thenReturn(mockDocumentReference);
    when(mockDocumentReference.get())
        .thenAnswer((_) async => mockDocumentSnapshot);
    when(mockDocumentSnapshot.data()).thenReturn({
      "uid": "767g8988y7ff677t7987",
      "email": "henryifebunandu@gmail.com",
      "username": "Henry",
      "createdAt": Timestamp.now(),
    });

    // final result = await remoteDataSource.getData('user_id');
    //assert
    expect(
        () => firestoreNotifier.addUserToDb(
            uid: '767g8988y7ff677t7987',
            email: 'henryifebunandu@gmail.com',
            username: 'Henry',
            time: Timestamp.now()),
        returnsNormally);
  });

  test('Adds user to db exception', () async {
    when(mockFirebaseFirestore.collection(any))
        .thenReturn(mockCollectionReference);

    when(mockCollectionReference.doc(any)).thenReturn(mockDocumentReference);
    when(mockDocumentReference.get())
        .thenAnswer((_) async => mockDocumentSnapshot);

    when(mockDocumentSnapshot.data()).thenAnswer((realInvocation) =>
        throw FirebaseException(
            plugin: 'Firestore',
            code: 'unknown',
            message: 'Something went wrong.'));

    expect(
        () => firestoreNotifier.addUserToDb(
            uid: 'uid',
            email: 'email',
            username: 'username',
            time: Timestamp.now()),
        returnsNormally);
  });

  // });
}
