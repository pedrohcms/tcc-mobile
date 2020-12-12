import 'package:mobile/src/interfaces/LocalStorageInterface.dart';
import 'package:mobile/src/services/SharedPreferenceService.dart';

class TokenService {
  static final LocalStorageInterface _storage = new SharedPreferenceService();
  static final String _keyName = 'token';

  static Future<String> getToken() async {
    return await _storage.get(_keyName);
  }

  static void setToken(String value) {
    _storage.set(_keyName, value);
  }

  static void deleteToken() {
    _storage.delete(_keyName);
  }
}
