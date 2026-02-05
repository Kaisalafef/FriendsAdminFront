import 'package:get/get.dart';
import 'package:friends_admin/core/services/token_service.dart';
import 'package:friends_admin/View/pages/LoginPage.dart';

class LogoutController extends GetxController {
  final TokenService _tokenService = TokenService();

  // دالة تسجيل الخروج
  Future<void> logout() async {
    try {
      // 1. مسح التوكن من التخزين المحلي
      await _tokenService.deleteToken();
      
      // 2. توجيه المستخدم لصفحة تسجيل الدخول ومسح التاريخ (Stack)
      Get.offAll(() => LoginPage());
      
      Get.snackbar("وداعاً", "تم تسجيل الخروج بنجاح");
    } catch (e) {
      Get.snackbar("خطأ", "فشل تسجيل الخروج");
    }
  }
}