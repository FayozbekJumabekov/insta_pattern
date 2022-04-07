import 'package:get_storage/get_storage.dart';
import 'package:insta_pattern/services/log_service.dart';

enum StorageKeys {
  UID,
  TOKEN,
}

class GetXLocalDB {
  static final box = GetStorage();

  static store(StorageKeys key, String data) async {
    await box.write(_getKey(key), data);
  }

  static Future<String?> load(StorageKeys key) async {
    return box.read(_getKey(key));
  }

  static Future<void> remove(StorageKeys key) async {
    await box.remove(_getKey(key));
  }

  static String _getKey(StorageKeys key) {
    switch (key) {
      case StorageKeys.UID:
        return "uid";
      case StorageKeys.TOKEN:
        return "token";
    }
  }
}
