import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/token_service.dart';
import '../pages/LoginPage.dart';
import '../pages/HomeScreen.dart';
import '../../constence/MyColor.dart';

class SplashController extends GetxController {
  final TokenService _tokenService = TokenService();

  @override
  void onInit() {
    super.onInit();
    _checkAuth();
  }

  void _checkAuth() async {
    // انتظار لحظي لظهور الشعار (اختياري)
    await Future.delayed(const Duration(seconds: 2));

    // فحص التوكن
    String? token = await _tokenService.getToken();

    if (token != null && token.isNotEmpty) {
      // إذا وجد توكن -> اذهب للرئيسية
      Get.offAll(() => const HomeScreen());
    } else {
      // لا يوجد توكن -> اذهب لتسجيل الدخول
      Get.offAll(() => LoginPage());
    }
  }
}

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController()); // تفعيل الكونترولر

    return Scaffold(
      backgroundColor: MyColor.primaryBlue, // لون التطبيق
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // أيقونة أو لوغو التطبيق
            const Icon(Icons.admin_panel_settings, size: 80, color: Colors.white),
            const SizedBox(height: 20),
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}