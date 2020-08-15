import 'package:mobile/src/interfaces/LocalStorageInterface.dart';
import 'package:mobile/src/services/SharedPreferenceService.dart';

class TokenService {
  final LocalStorageInterface _storage = new SharedPreferenceService();
  final String _keyName = 'token';

  Future<String> getToken() async {
    return await _storage.get(_keyName);
  }

  void setToken(String value) {
    _storage.set(_keyName, value);
  }

  void deleteToken() {
    _storage.delete(_keyName);
  }
}
