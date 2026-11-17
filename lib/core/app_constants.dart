
class AppConstants {
  AppConstants._();

  static const String baseUrl = 'http://127.0.0.1:8000';

  static const String tokenKey = 'token';
  static const String userIdKey = 'user_id';
  static const String userNameKey = 'user_name';
  static const String userEmailKey = 'user_email';
  static const String userRoleKey = 'user_role';

  static const String defaultLanguage = 'en';

  static const Duration connectionTimeout =
  Duration(seconds: 20);
}
