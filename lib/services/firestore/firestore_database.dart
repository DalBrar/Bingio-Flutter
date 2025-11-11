import 'dart:ui';
import 'package:bingio/services/firestore/models/abstract_firestore_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

typedef OnErrorCallback = void Function(Object error);

class FirestoreDB {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String?> createOrUpdate<FSM extends FirestoreModel>(String collection, FSM model, {Function(String)? onSuccess, OnErrorCallback? onError}) async {
    if (model.id == null) {
      try {
        var docRef = await db.collection(collection).add(model.toMap());
        if (onSuccess != null) onSuccess(docRef.id);
        return docRef.id;
      } catch (error) {
        if (onError != null) onError(error);
        return null;
      }
    }
    else {
      try {
        await db.collection(collection).doc(model.id).set(model.toMap());
        if (onSuccess != null) onSuccess(model.id!);
        return model.id!;
      } catch (error) {
        if (onError != null) onError(error);
        return null;
      }
    }
  }
  
  Future<void> createOrUpdateMany<FSM extends FirestoreModel>(String collection, Iterable<FSM> models, {VoidCallback? onSuccess, OnErrorCallback? onError}) async {
    final batch = db.batch();
    final coll = db.collection(collection);

    for (final profile in models) {
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

  Future<FSM?> getDocById<FSM extends FirestoreModel>(
    {
      required String collection,
      required String docId,
      required FSM Function(String docId, Object data) fromMap,
      OnErrorCallback? onError,
    }
  ) async {
    try {
      DocumentSnapshot docRef = await db.collection(collection).doc(docId).get();

      if (docRef.exists) {
        return fromMap(docId, docRef.data()!);
      }
      return null;
    }
    catch (error) {
      if (onError != null) {
        onError(error);
        return null;
      }
      rethrow;
    }
  }

  Future<List<FSM>> getDocsByKey<FSM extends FirestoreModel>(
    {
      required String collection,
      required String whereKey,
      required String matchingValue,
      required FSM Function(String docId, Object data) fromMap,
      OnErrorCallback? onError,
    }
  ) async {
    try {
      QuerySnapshot querySnapshot = await db.collection(collection).where(whereKey, isEqualTo: matchingValue).get();

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

  Stream<Iterable<FSM>> streamDocsByKey<FSM extends FirestoreModel>(
    {
      required String collection,
      required String whereKey,
      required String matchingValue,
      required FSM Function(String docId, Object data) fromMap,
    }
  ) {
    return db.collection(collection).where(whereKey, isEqualTo: matchingValue).snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return fromMap(doc.id, doc.data());
      });
    });
  }
}
