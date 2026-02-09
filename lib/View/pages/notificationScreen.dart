import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:friends_admin/constence/MyColor.dart';
import '../../Controller/NotificationController.dart';
import '../widget/NotificationItem.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationController controller = Get.put(NotificationController());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
        title: const Text("الطلبات الجديدة", style: TextStyle(color: Colors.white)),
        backgroundColor: MyColor.primaryBlue,
        actions: [
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

        // استخدام القائمة المفلترة هنا
        final pendingList = controller.pendingRequests;

        if (pendingList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications_off_outlined, size: 100, color: MyColor.secondaryGrey),
                const SizedBox(height: 20),
                const Text("لا توجد طلبات جديدة حالياً", style: TextStyle(fontSize: 18, color: Colors.grey)),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 10),
          itemCount: pendingList.length,
          itemBuilder: (context, index) {
            final request = pendingList[index];
            return NotificationItem(
              context,
              request.id,
              request.userId,
              request.userName,
              request.description ?? "طلب جديد",
              request.address ?? "لا يوجد عنوان",
              request.serviceType,
              request.phone ?? "لا يوجد رقم",
              request.profession ?? "غير محدد",
              request.status,
              images: request.images,
            );
          },
        );
      }),
    );
  }
}