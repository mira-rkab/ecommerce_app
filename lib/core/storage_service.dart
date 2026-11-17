
import 'package:get_storage/get_storage.dart';
import 'app_constants.dart';

class StorageService {
  static final GetStorage _storage = GetStorage();

  // Save Token
  static Future<void> saveToken(String token) async {
    await _storage.write(AppConstants.tokenKey, token);
  }

  // Get Token
  static String? getToken() {
    return _storage.read<String>(AppConstants.tokenKey);
  }

  // Save User Information
  static Future<void> saveUser({
    required int id,
    required String name,
    required String email,
  }) async {
    await _storage.write(AppConstants.userIdKey, id);
    await _storage.write(AppConstants.userNameKey, name);
    await _storage.write(AppConstants.userEmailKey, email);
  }

  // Get User Information
  static int? getUserId() {
    return _storage.read<int>(AppConstants.userIdKey);
  }

  static String? getUserName() {
    return _storage.read<String>(AppConstants.userNameKey);
  }

  static String? getUserEmail() {
    return _storage.read<String>(AppConstants.userEmailKey);
  }

  // Clear User Session
  static Future<void> clearSession() async {
    await _storage.remove(AppConstants.tokenKey);
    await _storage.remove(AppConstants.userIdKey);
    await _storage.remove(AppConstants.userNameKey);
    await _storage.remove(AppConstants.userEmailKey);
  }
}
