import 'dart:io';
import 'package:friends_admin/core/services/token_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AddEventController extends GetxController {
  // متغيرات الصور والتحميل
  var beforeImage = Rxn<File>();
  var afterImage = Rxn<File>();
  var isUploading = false.obs;
  final picker = ImagePicker();

  // اختيار صورة من المعرض
  Future<void> pickImage(bool isBefore) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (isBefore) {
        beforeImage.value = File(pickedFile.path);
      } else {
        afterImage.value = File(pickedFile.path);
      }
    }
  }

  // إرسال البيانات (بدون تمرير IDs)
  Future<void> uploadEvent(String title, String description) async {
    try {
      isUploading(true);

      // 1. جلب التوكن (افترضنا أنك خزنته باستخدام GetStorage أو SharedPreferences)
      // استبدل 'YOUR_TOKEN' بالمتغير الذي يحتوي على التوكن الفعلي
      // مثال إذا كنت تستخدم GetStorage
      final TokenService _tokenService = TokenService();
      String? token = await _tokenService.getToken();

      if (token == null) {
        Get.snackbar("خطأ", "انتهت جلسة تسجيل الدخول، يرجى تسجيل الدخول مجدداً");
        return;
      }

      var url = Uri.parse('http://192.168.1.103:8000/api/events');
      var request = http.MultipartRequest('POST', url);

      // 2. إضافة التوكن في الهيدرز (هذا هو مفتاح الحل للخطأ 401)
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token', // تأكد من كلمة Bearer متبوعة بمسافة ثم التوكن
      });

      request.fields['title'] = title;
      request.fields['description'] = description;

      if (beforeImage.value != null) {
        request.files.add(await http.MultipartFile.fromPath('before_image', beforeImage.value!.path));
      }
      if (afterImage.value != null) {
        request.files.add(await http.MultipartFile.fromPath('after_image', afterImage.value!.path));
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.back();
        Get.snackbar("نجاح", "تم الحفظ بنجاح");
      } else {
        print("❌ رد السيرفر: ${response.body}");
        Get.snackbar("خطأ", "فشل الإرسال برمز ${response.statusCode}");
      }
    } catch (e) {
      print("❌ خطأ: $e");
    } finally {
      isUploading(false);
    }
  }
}