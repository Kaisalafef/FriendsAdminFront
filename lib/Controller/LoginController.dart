import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:friends_admin/core/api/dio_client.dart'; // تأكد من المسار
import 'package:friends_admin/core/services/token_service.dart';
import 'package:friends_admin/View/pages/HomeScreen.dart';

class LoginController extends GetxController {
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  
  final DioClient _dioClient = DioClient();
  final TokenService _tokenService = TokenService();
  
  bool isLoading = false; // لمؤشر التحميل

  // دالة تسجيل الدخول الربط مع لارافيل
  Future<void> login() async {
    if (phoneController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar("خطأ", "يرجى ملء جميع الحقول");
      return;
    }

    isLoading = true;
    update();

    try {
      final response = await _dioClient.post('/login', data: {
        'phone': phoneController.text, // أو email حسب لارافيل
        'password': passwordController.text,
      });

      if (response.statusCode == 200) {
        String token = response.data['token'];
        await _tokenService.saveToken(token); // حفظ التوكن في Shared Preferences
        
        Get.offAll(() => const HomeScreen());
      }
    } catch (e) {
      Get.snackbar("فشل الدخول", "تأكد من البيانات أو الاتصال بالانترنت");
    } finally {
      isLoading = false;
      update();
    }
  }

  // ... باقي الدوال الخاصة بك (togglePasswordVisibility إلخ)
}