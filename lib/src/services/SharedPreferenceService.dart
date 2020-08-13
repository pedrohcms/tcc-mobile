import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  SharedPreferences _instance;

  SharedPreferenceService() {
    initInstance();
  }

  Future<void> initInstance() async {
    _instance = await SharedPreferences.getInstance();
  }

  Future<void> setItem(String type, String key, dynamic value) async {
    switch (type) {
      case 'bool':
        await _instance.setBool(key, value);
        break;
      case 'double':
        await _instance.setDouble(key, value);
        break;
      case 'int':
        await _instance.setInt(key, value);
        break;
      case 'string':
        await _instance.setString(key, value);
        break;
    }
  }

  Future<dynamic> getItem(String key) async {
    return await _instance.get(key);
  }

  Future<bool> removeItem(String key) async {
    return await _instance.remove(key);
  }
}
