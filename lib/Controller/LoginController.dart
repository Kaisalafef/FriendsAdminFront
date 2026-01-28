import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class LoginController extends GetxController {
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  bool isPasswordVisible = false;
  String? passwordErrorText;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    update();
  }

  void clearPasswordError() {
    passwordErrorText = null;
    update();
  }

  void validatePassword() {
    final password = passwordController.text;

    if (password.isEmpty) {
      passwordErrorText = 'يرجى إدخال كلمة السر';
    } else if (password.length < 8) {
      passwordErrorText = 'يجب أن تكون كلمة السر على الاقل 8 محارف';
    } else {
      passwordErrorText = null;
    }
    update();
  }
}
