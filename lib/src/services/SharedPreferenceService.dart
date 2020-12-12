import 'package:mobile/src/interfaces/LocalStorageInterface.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService implements LocalStorageInterface {
  @override
  Future<dynamic> get(String key) async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    return instance.get(key);
  }

  @override
  Future<void> set(String key, dynamic value) async {
    SharedPreferences instance = await SharedPreferences.getInstance();

    switch (value.runtimeType) {
      case String:
        instance.setString(key, value);
        break;
      case bool:
        instance.setBool(key, value);
        break;
      case double:
        instance.setDouble(key, value);
        break;
      case int:
        instance.setInt(key, value);
        break;
    }
  }

  @override
  Future<void> delete(String key) async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    instance.remove(key);
  }
}
