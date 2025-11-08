import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  static const String selectedProfileKey = 'selectedProfileID';
  
  static Future<SharedPreferences> getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  static Future<String?> getSelectedProfile({String? defaultValue}) async {
    final sp = await getPrefs();
    return sp.getString(selectedProfileKey) ?? defaultValue;
  }

  static Future<bool> setSelectedProfile(String? value) async {
    final sp = await getPrefs();
    if (value == null) {
      return sp.remove(selectedProfileKey);
    } else {
      return sp.setString(selectedProfileKey, value);
    }
  }
}
