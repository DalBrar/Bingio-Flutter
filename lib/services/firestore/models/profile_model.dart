import 'package:bingio/services/firestore/models/abstract_firestore_model.dart';

class ProfileModel implements FirestoreModel {
  static const String collection = 'profiles';
  static const String keyAccountUID = "accountUID";
  static const String keyDisplayName = "displayName";
  static const String keyBgColor = "bgColor";
  static const String keyPicColor = "picColor";
  static const String keyPicNumber = "picNumber";
  static const String keyKidsProfile ="kidsProfile";
  
  @override
  final String? id;
  final String accountUID;
  String displayName;
  int bgColor;
  int picColor;
  int picNumber;
  bool kidsProfile;

  ProfileModel({
    this.id,
    required this.accountUID,
    required this.displayName,
    required this.bgColor,
    required this.picColor,
    required this.picNumber,
    required this.kidsProfile,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      keyAccountUID: accountUID,
      keyDisplayName: displayName,
      keyBgColor: bgColor,
      keyPicColor: picColor,
      keyPicNumber: picNumber,
      keyKidsProfile: kidsProfile
    };
  }

  factory ProfileModel.fromMap(String docId, Object data) {
    if (data is! Map<String, dynamic>) { throw Exception("Invalid data format for ProfileModel"); }

    final map = data;
    return ProfileModel(
      id: docId,
      accountUID: map[keyAccountUID] as String? ?? '',
      displayName: map[keyDisplayName] as String? ?? 'Anon?',
      bgColor: map[keyBgColor] as int? ?? 2,
      picColor: map[keyPicColor] as int? ?? 5,
      picNumber: map[keyPicNumber] as int? ?? 99,
      kidsProfile: map[keyKidsProfile] as bool? ?? false,
    );
  }
}
