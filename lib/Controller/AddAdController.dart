import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../core/api/dio_client.dart'; // تأكد من استيراد كلاس Dio الذي أعددناه

class AddAdController extends GetxController {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  String? selectedGovernorate;  
  File? selectedImage;
  bool isLoading = false;
  final DioClient _dioClient = DioClient();

  // اختيار صورة من المعرض
  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage = File(pickedFile.path);
      update();
    }
  }

  // إرسال الإعلان للباك إند
  Future<void> uploadAd() async {
    if (titleController.text.isEmpty || descriptionController.text.isEmpty || selectedGovernorate == null) {
      Get.snackbar("خطأ", "يرجى ملء كافة الحقول");
      return;
    }

    isLoading = true;
    update();

    try {
      // تجهيز البيانات كـ FormData لرفع الملفات
      dio.FormData formData = dio.FormData.fromMap({
        "title": titleController.text,
        "description": descriptionController.text,
        "governorate": selectedGovernorate,
        "active": 1, // تفعيل الإعلان تلقائياً
        if (selectedImage != null)
          "image": await dio.MultipartFile.fromFile(
            selectedImage!.path,
            filename: selectedImage!.path.split('/').last,
          ),
      });

      final response = await _dioClient.post('/ads', data: formData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("تم بنجاح", "تم إنشاء الإعلان ويظهر الآن للمستخدمين");
        _clearFields();
      }
    } catch (e) {
      Get.snackbar("خطأ", "فشل رفع الإعلان: $e");
    } finally {
      isLoading = false;
      update();
    }
  }

  void _clearFields() {
    titleController.clear();
    descriptionController.clear();
    selectedGovernorate = null;
    selectedImage = null;
    update();
  }
}