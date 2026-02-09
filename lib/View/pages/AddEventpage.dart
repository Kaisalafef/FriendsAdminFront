import 'package:flutter/material.dart';
import 'package:friends_admin/Controller/AdEventController.dart';
import 'package:get/get.dart';

class AddEventPage extends StatelessWidget {
  AddEventPage({super.key});

  final titleController = TextEditingController();
  final descController = TextEditingController();
  final AddEventController controller = Get.put(AddEventController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("إضافة عمل جديد"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // حقول النص
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "عنوان العمل", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: descController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: "وصف العمل", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 25),

            // صناديق اختيار الصور
            Row(
              children: [
                Expanded(child: _imageBox(context, "قبل العمل", true)),
                const SizedBox(width: 15),
                Expanded(child: _imageBox(context, "بعد العمل", false)),
              ],
            ),

            const SizedBox(height: 40),

            // زر الحفظ
            Obx(() => controller.isUploading.value
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 55),
                backgroundColor: Colors.blueAccent,
              ),
              onPressed: () {
                if (titleController.text.isNotEmpty && descController.text.isNotEmpty) {
                  controller.uploadEvent(titleController.text, descController.text);
                } else {
                  Get.snackbar("تنبيه", "يرجى كتابة العنوان والوصف");
                }
              },
              icon: const Icon(Icons.cloud_upload, color: Colors.white),
              label: const Text("نشر العمل الآن", style: TextStyle(color: Colors.white, fontSize: 16)),
            )),
          ],
        ),
      ),
    );
  }

  // ودجت اختيار الصورة
  Widget _imageBox(BuildContext context, String label, bool isBefore) {
    return GestureDetector(
      onTap:() => controller.pickImage(isBefore),
      child: Obx(() {
        final file = isBefore ? controller.beforeImage.value : controller.afterImage.value;
        return Container(
          height: 150,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey[300]!),
            image: file != null ? DecorationImage(image: FileImage(file), fit: BoxFit.cover) : null,
          ),
          child: file == null
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add_photo_alternate_outlined, size: 40, color: Colors.grey),
              const SizedBox(height: 8),
              Text(label, style: const TextStyle(color: Colors.grey)),
            ],
          )
              : null,
        );
      }),
    );
  }
}