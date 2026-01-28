import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controller/SettingsController.dart';
import '../../constence/MyColor.dart';
import '../widget/buildSettingsField.dart';
import 'OrderLogScreen.dart';
import 'createAdminScreen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("الإعدادات", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: MyColor.primaryBlue,
        centerTitle: true,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25))),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // قسم البروفايل
            Center(
              child: Container(
                // تغليف الدائرة بـ Container لإضافة الظل
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15), // لون الظل وشفافيته
                      blurRadius: 20, // مدى تنعيم وحجم الظل
                      spreadRadius: 2, // مدى انتشار الظل
                      offset: const Offset(0, 10), // إزاحة الظل للأسفل (يعطي شعور بالارتفاع)
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 70,
                  backgroundColor: MyColor.primaryBlue.withOpacity(0.1),
                  // استخدام backgroundImage لضمان الشكل الدائري التام
                  backgroundImage: const AssetImage('image/photo_2026-01-12_10-03-16.jpg'),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // الحقول
            Obx(() => BuildSettingsField(value: controller.username.value, icon: Icons.person_outline, onEdit: () => controller.showEditDialog(context, isPassword: false))),
            const SizedBox(height: 15),
            Obx(() => BuildSettingsField(value: controller.password.value, icon: Icons.lock_outline, onEdit: () => controller.showEditDialog(context, isPassword: true))),

            const SizedBox(height: 30),

            // أزرار التحكم
            _buildSettingTile("سجل الطلبات", Icons.history, () => Get.to(const OrderLogScreen())),
            _buildSettingTile("تحكم بالموظفين", Icons.manage_accounts_outlined, () => Get.to(const CreateGovAdminScreen())),

            const SizedBox(height: 40),

            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text("تسجيل الخروج", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(backgroundColor: MyColor.primaryBlue, minimumSize: const Size(double.infinity, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingTile(String title, IconData icon, VoidCallback tap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)]),
      child: ListTile(
        leading: Icon(icon, color: MyColor.primaryBlue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: tap,
      ),
    );
  }
}