import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:friends_admin/core/api/dio_client.dart'; // تأكد من المسار
import 'package:friends_admin/constence/MyColor.dart'; // تأكد من المسار

class SettingsController extends GetxController {

  final DioClient _dioClient = DioClient();

  // المتغيرات
  var username = "".obs; // سنملؤها من السيرفر
  var password = "********".obs; // مجرد شكل جمالي
  var userRole = "".obs; // لتخزين الصلاحية
  var isLoading = false.obs; // للتحميل
  

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile(); // جلب البيانات فور فتح الصفحة
  }



  // 1. دالة جلب البيانات (GET)
  Future<void> fetchUserProfile() async {
    try {
      // الرابط حسب ملف api.php هو /profile
      final response = await _dioClient.get('/profile');

      if (response.statusCode == 200) {
        var data = response.data;
        username.value = data['name'] ?? "مستخدم";
        userRole.value = data['role'] ?? ""; // تخزين الرتبة
      }
    } catch (e) {
      print("Error fetching profile: $e");
    }
  }

  // 2. دالة تحديث الاسم (PUT)
  Future<void> updateName(String newName) async {
    try {
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false); // تحميل

      final response = await _dioClient.put('/profile', data: {
        'name': newName,
      });

      Get.back(); // إغلاق التحميل

      if (response.statusCode == 200) {
        username.value = newName; // تحديث الواجهة محلياً
        Get.back(); // إغلاق الـ Dialog الخاص بالتعديل
        Get.snackbar("نجاح", "تم تحديث الاسم بنجاح", backgroundColor: Colors.green.withOpacity(0.2));
      }
    } catch (e) {
      Get.back(); // إغلاق التحميل
      Get.snackbar("خطأ", "فشل تحديث الاسم", backgroundColor: Colors.red.withOpacity(0.2));
    }
  }

  // 3. دالة تحديث كلمة المرور (PUT)
  Future<void> updatePassword(String newPassword) async {
    try {
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);

      /*
       ملاحظة: في Laravel الـ Validation هو 'confirmed'
       بما أننا نستخدم حقلاً واحداً في الواجهة، سنرسل نفس القيمة
       للحقلين password و password_confirmation
      */
      final response = await _dioClient.put('/profile', data: {
        'password': newPassword,
        'password_confirmation': newPassword,
      });

      Get.back(); // إغلاق التحميل

      if (response.statusCode == 200) {
        Get.back(); // إغلاق الـ Dialog
        Get.snackbar("نجاح", "تم تحديث كلمة المرور بنجاح", backgroundColor: Colors.green.withOpacity(0.2));
      }
    } catch (e) {
      Get.back(); // إغلاق التحميل
      Get.snackbar("خطأ", "فشل تحديث كلمة المرور", backgroundColor: Colors.red.withOpacity(0.2));
    }
  }

  // دالة عرض النافذة المنبثقة
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
            obscureText: isPassword, // إخفاء النص إذا كان كلمة مرور
            decoration: InputDecoration(
              hintText: isPassword ? "أدخل كلمة السر الجديدة" : "أدخل الاسم الجديد",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              filled: true,
              fillColor: Colors.grey[100],
            ),
          ),
        ],
      ),
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: MyColor.primaryBlue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () {
          if (textController.text.isNotEmpty) {
            // التحقق من طول كلمة المرور (لارافيل يطلب 8 غالباً)
            if (isPassword && textController.text.length < 8) {
              Get.snackbar("تنبيه", "كلمة المرور يجب أن تكون 8 أحرف على الأقل");
              return;
            }

            // استدعاء دوال الـ API بدلاً من التغيير المحلي فقط
            if (isPassword) {
              updatePassword(textController.text);
            } else {
              updateName(textController.text);
            }
          }
        },
        child: const Text("حفظ", style: TextStyle(color: Colors.white)),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: const Text("إلغاء", style: TextStyle(color: Colors.black)),
      ),
    );
  }
}