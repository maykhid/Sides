import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:trove_app/services/firestore.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

// class MockCollectionReference extends Mock implements CollectionReference{}
// ignore: must_be_immutable
class MockCollectionReference extends Mock implements CollectionReference {}

class MockDocumentReference extends Mock implements DocumentReference {}

class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}

void main() {
  final MockFirebaseFirestore mockFirebaseFirestore = MockFirebaseFirestore();

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
  tearDown(() {});

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
