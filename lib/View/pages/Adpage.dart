import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controller/AdsController.dart';
import '../../constence/MyColor.dart';
import 'AddAdPage.dart';

class AdPage extends StatelessWidget {
  const AdPage({super.key});

  @override
  Widget build(BuildContext context) {
    // استدعاء الكنترولر وتحديث البيانات عند فتح الصفحة
    final AdsController controller = Get.put(AdsController());
    controller.fetchAds(); 

    return Scaffold(
      appBar: AppBar(
        title: const Text("إعلاناتي", style: TextStyle(color: Colors.white)),
        backgroundColor: MyColor.primaryBlue,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColor.primaryBlue,
        onPressed: () => Get.to(() =>  AddAdPage()),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.adsList.isEmpty) {
          return const Center(child: Text("لا توجد إعلانات حالياً"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(15),
          itemCount: controller.adsList.length,
          itemBuilder: (context, index) {
            final ad = controller.adsList[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: [
                  // عرض صورة الإعلان
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                    child: Image.network(
                      ad.fullImageUrl,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => 
                        const Icon(Icons.broken_image, size: 50),
                    ),
                  ),
                  ListTile(
                    title: Text(ad.title ?? "بدون عنوان", style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(ad.description ?? "", maxLines: 2, overflow: TextOverflow.ellipsis),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // زر التعديل
                        // IconButton(
                        //   icon: const Icon(Icons.edit, color: Colors.blue),
                        //   onPressed: () {
                        //     // سنقوم بربط التعديل لاحقاً بنفس صفحة الإضافة
                        //     Get.snackbar("تنبيه", "ميزة التعديل قيد التطوير");
                        //   },
                        // ),
                        // زر الحذف
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmDelete(context, controller, ad.id),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  void _confirmDelete(BuildContext context, AdsController controller, int id) {
    Get.defaultDialog(
      title: "حذف الإعلان",
      middleText: "هل أنت متأكد من حذف هذا الإعلان نهائياً؟",
      textConfirm: "حذف",
      textCancel: "إلغاء",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        controller.deleteAd(id);
        Get.back();
      },
    );
  }
}