import 'package:flutter/material.dart';
import 'package:friends_admin/Controller/SignupController.dart';
import 'package:friends_admin/View/pages/LoginPage.dart';
import 'package:friends_admin/constence/MyColor.dart';
import 'package:get/get.dart';

class Signuppage extends StatelessWidget {
  const Signuppage({super.key});

  @override
  Widget build(BuildContext context) {
    final Signupcontroller controller = Get.put(Signupcontroller());
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: TweenAnimationBuilder(
          duration: const Duration(milliseconds: 800),
          tween: Tween<double>(begin: 0, end: 1),
          builder: (context, double value, child) {
            return Opacity(opacity: value, child: Transform.translate(offset: Offset(0, 20 * (1 - value)), child: child));
          },
          child: Column(
            children: [
              Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: MyColor.primaryBlue,
                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(80)),
                ),
                child: const Center(
                  child: Text("إنشاء حساب جديد", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildField(controller.nameController, "الاسم الكامل", Icons.person_outline),
                      const SizedBox(height: 15),
                      _buildField(controller.phoneController, "رقم الهاتف", Icons.phone_android),
                      const SizedBox(height: 15),
                      _buildField(controller.passwordController, "كلمة السر", Icons.lock_open, isPass: true),
                      const SizedBox(height: 15),

                      // حقول الموقع بتصميم أنيق
                      GetBuilder<Signupcontroller>(builder: (controller) {
                        return Column(
                          children: [
                            _buildDropdown("المحافظة", controller.locations.keys.toList(), controller.selectedGovernorate, (v) => controller.changeGovernorate(v)),
                            const SizedBox(height: 15),
                            _buildDropdown("المدينة", controller.currentCities, controller.selectedCity, (v) => controller.changeCity(v)),
                          ],
                        );
                      }),

                      const SizedBox(height: 35),
                      _buildBtn("إنشاء الحساب", () {
                        if (_formKey.currentState!.validate()) Get.offAll(LoginPage());
                      }),
                      TextButton(
                        onPressed: () => Get.offAll(LoginPage()),
                        child: Text("لديك حساب بالفعل؟ سجل دخولك", style: TextStyle(color: MyColor.primaryBlue)),
                      )
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

  Widget _buildField(TextEditingController ctr, String hint, IconData icon, {bool isPass = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: TextFormField(
        controller: ctr,
        obscureText: isPass,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: MyColor.primaryBlue),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(18),
        ),
      ),
    );
  }

  Widget _buildDropdown(String hint, List<String> items, String? val, Function(String?) onChange) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(15)),
      child: DropdownButtonFormField<String>(
        value: val,
        decoration: InputDecoration(border: InputBorder.none, hintText: hint),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChange,
      ),
    );
  }

  Widget _buildBtn(String label, VoidCallback tap) {
    return SizedBox(
      width: double.infinity, height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: MyColor.primaryBlue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
        onPressed: tap, child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}