import '../core/api/dio_client.dart';
import '../core/services/token_service.dart';

class AuthRepository {
  final DioClient _dioClient = DioClient();
  final TokenService _tokenService = TokenService();

  // دالة تسجيل الدخول
  Future<bool> login(String email, String password) async {
    try {
      final response = await _dioClient.post('/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        // افترضنا أن لارافيل يرجع التوكن داخل حقل اسمه token
        String token = response.data['token'];
        
        // حفظ التوكن
        await _tokenService.saveToken(token);
        return true;
      }
      return false;
    } catch (e) {
      throw Exception('فشل تسجيل الدخول: $e');
    }
  }

  // دالة التسجيل
  Future<bool> register(String name, String email, String password) async {
    try {
      final response = await _dioClient.post('/register', data: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        // يمكنك حفظ التوكن هنا أيضاً إذا كان الـ API يرجعه مباشرة بعد التسجيل
        String token = response.data['token'];
        await _tokenService.saveToken(token);
        return true;
      }
      return false;
    } catch (e) {
      throw Exception('فشل إنشاء الحساب: $e');
    }
  }

  // دالة تسجيل الخروج
  Future<void> logout() async {
    try {
      // إرسال طلب للسيرفر لإلغاء التوكن (اختياري حسب الـ Backend)
      await _dioClient.post('/logout');
    } catch (e) {
      // نتجاهل الخطأ ونقوم بحذف التوكن محلياً في كل الأحوال
    } finally {
      // حذف التوكن من الجهاز
      await _tokenService.deleteToken();
    }
  }
}