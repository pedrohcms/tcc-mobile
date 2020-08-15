abstract class LocalStorageInterface {
  Future get(String key);
  Future set(String key, dynamic value);
  Future delete(String key);
}
