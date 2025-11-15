import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static late SharedPreferences _prefs;

  /// Initialisation à faire au démarrage de l’app
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setSound(bool value) async {
    await _prefs.setBool('sound', value);
  }

  static bool getSound() {
    return _prefs.getBool('sound') ?? false;
  }

  static Future<void> setVibration(bool value) async {
    await _prefs.setBool('vibration', value);
  }

  static bool getVibration() {
    return _prefs.getBool('vibration') ?? false;
  }
}
