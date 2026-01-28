import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:friends_admin/constence/MyColor.dart'; // تأكد من المسار

class SettingsController extends GetxController {
  var username = "اسم المستخدم الحالي".obs;
  var password = "********".obs;

  void showEditDialog(BuildContext context, {required bool isPassword}) {
    TextEditingController textController = TextEditingController();

    if (!isPassword) {
      textController.text = username.value;
    }

    Get.defaultDialog(
      title: isPassword ? "تعديل كلمة السر" : "تعديل الاسم",
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      content: Column(
        children: [
          TextField(
            controller: textController,
            obscureText: isPassword,
            decoration: InputDecoration(
              hintText: isPassword ? "أدخل كلمة السر الجديدة" : "أدخل الاسم الجديد",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              filled: true,
              fillColor: Colors.grey[100],
            ),
          ),
        ],
      ),
      // --- التعديل يبدأ من هنا ---
      // نلغي textConfirm و onConfirm ونستخدم confirm لزر مخصص
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: MyColor.primaryBlue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () {
          if (textController.text.isNotEmpty) {
            if (isPassword) {
              password.value = textController.text;
              Get.back(); // نغلق الـ Dialog أولاً
              Get.snackbar(
                "تم تحديث كلمة السر بنجاح",
                "",
                snackPosition: SnackPosition.TOP, // يفضل ظهوره في الأسفل
                colorText: Colors.black,
              );
            } else {
              username.value = textController.text;
              Get.back(); // نغلق الـ Dialog أولاً
              Get.snackbar(
                "تم تحديث الاسم بنجاح",
                "",
                snackPosition: SnackPosition.TOP,
                colorText: Colors.black,
              );
            }
          }
        },
        child: const Text("حفظ", style: TextStyle(color: Colors.white)),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: const Text("إلغاء", style: TextStyle(color: Colors.black)),
      ),
      // --- انتهى التعديل ---
    );
  }
}