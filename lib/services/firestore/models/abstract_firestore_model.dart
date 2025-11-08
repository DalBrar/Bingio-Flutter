/// Parent class to ensure all Firestore Models
/// are setup in a similar way.
abstract class FirestoreModel {
  /// Document id
  String? get id;

  /// Method to convert class to Map
  Map<String, dynamic> toMap();

  /// Error thrown when fromMap() is not implemented to display Subclass name
  static UnimplementedError missingFromMap(Type subclassType) {
    return UnimplementedError('fromMap() must be implemented by subclass: $subclassType');
  }

  /// Factory constructor to create class from Map
  factory FirestoreModel.fromMap(String docId, Object data) {
    throw FirestoreModel.missingFromMap(FirestoreModel);
  }
}
