import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:friends_admin/constence/MyColor.dart';
import '../../Controller/NotificationController.dart'; // تأكد من المسار
import '../widget/NotificationItem.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // حقن الكنترولر
    final NotificationController controller = Get.put(NotificationController());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        title: const Text("طلبات الخدمات", style: TextStyle(color: Colors.white)),
        backgroundColor: MyColor.primaryBlue,
        actions: [
          // زر تحديث القائمة
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => controller.fetchRequests(),
          )
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: MyColor.primaryBlue));
        }

        if (controller.requestList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications_off_outlined, size: 100, color: MyColor.secondaryGrey),
                const SizedBox(height: 20),
                const Text(
                  "لا توجد طلبات جديدة حالياً",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 10),
          itemCount: controller.requestList.length,
          // داخل ListView.builder في ملف notificationScreen.dart
itemBuilder: (context, index) {
  final request = controller.requestList[index];
  
  return NotificationItem(
    context,
    request.userName,
    request.description ?? "طلب جديد",
    request.address ?? "لا يوجد عنوان",
    request.serviceType,
    request.phone ?? "لا يوجد رقم",
    request.profession ?? "غير محدد",
    images: request.images, // الصور القادمة من الكنترولر (روابط كاملة)
  );
},
        );
      }),
    );
  }
}