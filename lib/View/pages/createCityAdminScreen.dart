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
      appBar: AppBar(title: const Text("إضافة مشرف مدينة"), backgroundColor: MyColor.primaryBlue, elevation: 0),
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
                child: Column(
                  children: [
                    _input(controller.nameController, "اسم مسؤول المدينة", Icons.person_pin_circle_outlined),
                    const SizedBox(height: 15),
                    Obx(() => _dropdown("المحافظة التابع لها", controller.locations.keys.toList(), controller.selectedGovernorate.value, (v) => controller.updateGovernorate(v))),
                    const SizedBox(height: 15),
                    Obx(() => _dropdown("حدد المدينة", controller.availableCities, controller.selectedCity.value, (v) => controller.selectedCity.value = v)),
                    const SizedBox(height: 30),
                    _submitBtn("حفظ بيانات المشرف", () {}),
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
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: CircleAvatar(
        radius: 50,
        backgroundColor: MyColor.primaryBlue.withOpacity(0.1),
        backgroundImage: const AssetImage('image/photo_2026-01-12_10-03-16.jpg'),
      ),
    );
  }

  Widget _input(TextEditingController ctr, String label, IconData icon) {
    return TextFormField(
      controller: ctr,
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