import 'package:flutter/material.dart';
import 'package:friends_admin/Controller/LoginController.dart';
import 'package:friends_admin/View/pages/HomeScreen.dart';
import 'package:friends_admin/View/pages/SignupPage.dart';
import 'package:friends_admin/constence/MyColor.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: TweenAnimationBuilder(
          duration: const Duration(milliseconds: 800),
          tween: Tween<double>(begin: 0, end: 1),
          builder: (context, double value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 30 * (1 - value)),
                child: child,
              ),
            );
          },
          child: Column(
            children: [
              // تصميم علوي مميز
              Stack(
                children: [
                  Container(
                    height: 280,
                    decoration: BoxDecoration(
                      color: MyColor.primaryBlue,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(100),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Center(
                      child: Lottie.asset('assets/Login.json', height: 180),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        "مرحباً بك",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: MyColor.primaryBlue,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text("سجل دخولك للمتابعة", style: TextStyle(color: Colors.grey[600])),
                      const SizedBox(height: 30),
                      _buildTextField(
                        controller: controller.phoneController,
                        hint: "رقم الهاتف",
                        icon: Icons.phone_android,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: controller.passwordController,
                        hint: "كلمة السر",
                        icon: Icons.lock_outline,
                        isPass: true,
                      ),
                      const SizedBox(height: 40),
                      GetBuilder<LoginController>(
  builder: (controller) => controller.isLoading
    ? CircularProgressIndicator()
    : _buildMainButton("تسجيل الدخول", () {
        controller.login();
      }),
),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("ليس لديك حساب ؟ ", style: TextStyle(color: Colors.grey[600])),
                          TextButton(
                            onPressed: () => Get.offAll(const Signuppage()),
                            child: Text("إنشاء حساب", style: TextStyle(color: MyColor.primaryBlue, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String hint, required IconData icon, bool isPass = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPass,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: MyColor.primaryBlue),
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(20),
        ),
      ),
    );
  }

  Widget _buildMainButton(String title, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: MyColor.primaryBlue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 5,
        ),
        child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }
}