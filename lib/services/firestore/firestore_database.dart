import 'dart:ui';
import 'package:bingio/services/firestore/models/abstract_firestore_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

typedef OnErrorCallback = void Function(Object error);

class FirestoreDatabase {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> createOrUpdate<FSM extends FirestoreModel>(String collection, FSM profile, {VoidCallback? onSuccess, OnErrorCallback? onError}) async {
    await db.collection(collection)
      .doc(profile.id)
      .set(profile.toMap())
      .then((_) {
        if (onSuccess != null) onSuccess();
      })
      .catchError((error) {
        if (onError != null) onError(error);
      });
  }
  
  Future<void> createOrUpdateMany<FSM extends FirestoreModel>(String collection, Iterable<FSM> profiles, {VoidCallback? onSuccess, OnErrorCallback? onError}) async {
    final batch = db.batch();
    final coll = db.collection(collection);

    for (final profile in profiles) {
      final docRef = profile.id != null
        ? coll.doc(profile.id!) // override existing profile
        : coll.doc(); // create new profile
      batch.set(docRef, profile.toMap());
    }

    await batch.commit()
      .then((_) {
        if (onSuccess != null) onSuccess();
      })
      .catchError((error) {
        if (onError != null) onError(error);
      });
  }

  Future<void> delete(String collection, String docId, {VoidCallback? onSuccess, OnErrorCallback? onError}) async {
    await db.collection(collection).doc(docId)
      .delete()
      .then((_) {
        if (onSuccess != null) onSuccess();
      })
      .catchError((error) {
        if (onError != null) onError(error);
      });
  }

  Future<List<FSM>> getDocsByUID<FSM extends FirestoreModel>(
    String collection,
    String uid,
    String docKey,
    FSM Function(String docId, Object data) fromMap,
    {OnErrorCallback? onError}
  ) async {
    try {
      QuerySnapshot querySnapshot = await db.collection(collection).where(docKey, isEqualTo: uid).get();

      return querySnapshot.docs.map((doc) {
        return fromMap(doc.id, doc.data()!);
      }).toList();
    }
    catch (error) {
      if (onError != null) {
        onError(error);
        return List<FSM>.empty();
      }
      rethrow;
    }
  }

  Stream<Iterable<FSM>> streamDocsByUID<FSM extends FirestoreModel>(
    String collection,
    String uid,
    String docKey,
    FSM Function(String docId, Object data) fromMap
  ) {
    return db.collection(collection).where(docKey, isEqualTo: uid).snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return fromMap(doc.id, doc.data());
      });
    });
  }
}
