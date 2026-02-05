import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controller/adminController.dart';
import '../../constence/MyColor.dart';

class CreateGovAdminScreen extends StatelessWidget {
  const CreateGovAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("إضافة مشرف محافظة", style: TextStyle(color: Colors.white)),
        backgroundColor: MyColor.primaryBlue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildModernHeader(),
            const SizedBox(height: 30),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)],
              ),
              child: Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    _input(controller.nameController, "اسم المشرف", Icons.person_add_alt),
                    const SizedBox(height: 15),
                    _input(controller.phoneController, "رقم الهاتف", Icons.phone),
                    const SizedBox(height: 15),
                    _input(controller.passwordController, "كلمة السر", Icons.lock, isPass: true),
                    const SizedBox(height: 15),
                    Obx(() => _dropdown(
                      "اختر المحافظة",
                      controller.locations.keys.toList(),
                      controller.selectedGovernorate.value,
                          (v) => controller.updateGovernorate(v),
                    )),
                    const SizedBox(height: 30),
                    // ربط الزر بدالة حفظ أدمن المحافظة
                    Obx(() => controller.isLoading.value
                        ? const CircularProgressIndicator()
                        : _submitBtn("إعتماد المشرف", controller.saveGovernorateAdmin)
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

  Widget _buildModernHeader() {
    return CircleAvatar(
      radius: 50,
      backgroundColor: MyColor.primaryBlue.withOpacity(0.1),
      child: Icon(Icons.admin_panel_settings, size: 50, color: MyColor.primaryBlue),
    );
  }

  Widget _input(TextEditingController ctr, String label, IconData icon, {bool isPass = false}) {
    return TextFormField(
      controller: ctr,
      obscureText: isPass,
      validator: (val) => val!.isEmpty ? "حقل مطلوب" : null,
      decoration: InputDecoration(
        labelText: label, prefixIcon: Icon(icon, color: MyColor.primaryBlue),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
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