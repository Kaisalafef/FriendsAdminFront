import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controller/adminController.dart';
import '../../constence/MyColor.dart';

class CreateCityAdminScreen extends StatelessWidget {
  const CreateCityAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("إضافة مشرف مدينة", style: TextStyle(color: Colors.white)), backgroundColor: MyColor.primaryBlue, iconTheme: const IconThemeData(color: Colors.white)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: MyColor.primaryBlue.withOpacity(0.1),
              child: Icon(Icons.location_city, size: 50, color: MyColor.primaryBlue),
            ),
            const SizedBox(height: 30),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)],
              ),
              child: Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    _input(controller.nameController, "اسم مسؤول المدينة", Icons.person),
                    const SizedBox(height: 15),
                    _input(controller.phoneController, "رقم الهاتف", Icons.phone),
                    const SizedBox(height: 15),
                    _input(controller.passwordController, "كلمة السر", Icons.lock, isPass: true),
                    const SizedBox(height: 15),
                    Obx(() => _dropdown("المحافظة التابع لها", controller.locations.keys.toList(), controller.selectedGovernorate.value, (v) => controller.updateGovernorate(v))),
                    const SizedBox(height: 15),
                    Obx(() => _dropdown("حدد المدينة", controller.availableCities, controller.selectedCity.value, (v) => controller.selectedCity.value = v)),
                    const SizedBox(height: 30),
                    // ربط الزر بدالة حفظ أدمن المدينة
                    Obx(() => controller.isLoading.value
                        ? const CircularProgressIndicator()
                        : _submitBtn("حفظ بيانات المشرف", controller.saveCityAdmin)
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // نفس الودجات المساعدة السابقة...
  Widget _input(TextEditingController ctr, String label, IconData icon, {bool isPass = false}) {
    return TextFormField(
      controller: ctr, obscureText: isPass, validator: (val) => val!.isEmpty ? "مطلوب" : null,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon, color: MyColor.primaryBlue), border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
    );
  }

  Widget _dropdown(String label, List<String> items, String? val, Function(String?) onChange) {
    return DropdownButtonFormField<String>(
      value: val, hint: Text(label), items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChange, decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
    );
  }

  Widget _submitBtn(String txt, VoidCallback tap) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: MyColor.primaryBlue, minimumSize: const Size(double.infinity, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
      onPressed: tap, child: Text(txt, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }
}