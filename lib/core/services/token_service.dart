import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  static const String _key = 'auth_token';

  // حفظ التوكن عند تسجيل الدخول
  Future<void> saveToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, token);
  }

  // قراءة التوكن لإرساله للسيرفر
  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }

  // حذف التوكن عند تسجيل الخروج
  Future<void> deleteToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}