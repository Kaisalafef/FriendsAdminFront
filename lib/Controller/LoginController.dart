import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:friends_admin/core/api/dio_client.dart'; 
import 'package:friends_admin/core/services/token_service.dart';
import 'package:friends_admin/View/pages/HomeScreen.dart';

class LoginController extends GetxController {
  final passwordController = TextEditingController();
  final phoneController = TextEditingController(); // سنرسله كـ email للسيرفر
  
  final DioClient _dioClient = DioClient();
  final TokenService _tokenService = TokenService();
  bool isLoading = false;

  Future<void> login() async {
    isLoading = true;
    update();

    try {
      final response = await _dioClient.post('/login', data: {
        'email': phoneController.text, // التعديل هنا ليتوافق مع AuthController.php
        'password': passwordController.text,
      });

      if (response.statusCode == 200) {
        String token = response.data['token'];
        await _tokenService.saveToken(token); 
        Get.offAll(() => const HomeScreen());
      }
    } catch (e) {
      Get.snackbar("خطأ", "فشل تسجيل الدخول، تأكد من البيانات");
    } finally {
      isLoading = false;
      update();
    }
  }
}