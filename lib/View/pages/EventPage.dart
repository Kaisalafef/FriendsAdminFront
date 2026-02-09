import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:friends_admin/Controller/EventController.dart';
import 'package:friends_admin/Model/EventModel.dart';
import 'package:friends_admin/View/pages/AddEventPage.dart';
import 'package:friends_admin/constence/MyColor.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class EventPage extends StatelessWidget {
  const EventPage({super.key});

  @override
  Widget build(BuildContext context) {
    // حقن الكنترولر باستخدام GetX
    final EventsController controller = Get.put(EventsController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("أعمالنا", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: MyColor.primaryBlue,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => controller.fetchEvents(),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.fetchEvents(),
        child: Obx(() {
          // 1. حالة التحميل
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. حالة القائمة فارغة
          if (controller.eventsList.isEmpty) {
            return _buildEmptyState();
          }

          // 3. عرض القائمة
          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: controller.eventsList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: _buildEventCard(context, controller.eventsList[index]),
              );
            },
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: (){Get.to(AddEventPage());
          controller.fetchEvents();}),
    );
  }
}
Widget _buildEventCard(BuildContext context, EventModel event) {
  return Container(
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. صور قبل وبعد
        Row(
          children: [
            Expanded(child: _buildImageSection(event.fullBeforeImage, "قبل")),
            Container(width: 1, height: 150, color: Colors.white), // فاصل
            Expanded(child: _buildImageSection(event.fullAfterImage, "بعد")),
          ],
        ),

        // 2. التفاصيل
        Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    event.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  // عرض التاريخ بشكل بسيط (يمكن تحسينه باستخدام مكتبة intl)
                  Text(
                    event.createdAt.substring(0, 10), // يأخذ فقط السنة والشهر واليوم
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                  
                ],
              ),
              const SizedBox(height: 8),
              Text(
                event.description,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              Positioned(
      left: 10,
      top: 10,
      child: CircleAvatar(
        backgroundColor: Colors.white.withOpacity(0.9),
        child: IconButton(
          icon: const Icon(Icons.delete_forever, color: Colors.red),
          onPressed: () => _showDeleteConfirmation(event.id!),
        ),
      ),
    ),
              // عرض اسم الفني إذا وجد
              // if (event.workerName != null)
              //   Row(
              //     children: [
              //        Icon(Icons.person_outline, size: 16, color: MyColor.primaryBlue),
              //       const SizedBox(width: 5),
              //       Text(
              //         "تنفيذ: ${event.workerName}",
              //         style:  TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: MyColor.primaryBlue),
              //       ),
              //     ],
              //   )
            ],
          ),
        ),
      ],
    ),
  );
}

void _showDeleteConfirmation(int eventId) {
  final EventsController controller = Get.find<EventsController>();
  Get.defaultDialog(
    title: "تأكيد الحذف",
    middleText: "هل أنت متأكد من حذف هذا العمل نهائياً؟",
    textConfirm: "حذف",
    textCancel: "إلغاء",
    confirmTextColor: Colors.white,
    buttonColor: Colors.red,
    onConfirm: () {
      Get.back(); // إغلاق الديالوج
      controller.deleteEvent(eventId); // استدعاء دالة الحذف
    },
  );
}
// ودجت صغيرة لعرض الصورة مع التسمية
Widget _buildImageSection(String imageUrl, String label) {
  return Stack(
    children: [
      SizedBox(
        height: 150,
        width: double.infinity,
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[200],
                child: const Center(child: Icon(Icons.image_not_supported, color: Colors.grey)),
              );
            },
          ),
        ),
      ),
      Positioned(
        top: 10,
        right: 10,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 10)),
        ),
      ),
    ],
  );
}

// تصميم الحالة الفارغة
Widget _buildEmptyState() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.photo_library_outlined, size: 80, color: Colors.grey[300]),
        const SizedBox(height: 20),
        Text(
          "لا توجد أعمال منشورة حالياً",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[500]),
        ),
      ],
    ),
  );
}