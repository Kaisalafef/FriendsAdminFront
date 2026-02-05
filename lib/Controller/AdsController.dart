import 'package:flutter/material.dart';
import 'package:friends_admin/Model/AdsModel.dart';
import 'package:get/get.dart';
import '../core/api/dio_client.dart'; // تأكد من المسار لديك
class AdsController extends GetxController {
  var isLoading = true.obs;
  var adsList = <AdModel>[].obs;
  final DioClient _dioClient = DioClient();

  @override
  void onInit() {
    fetchAds();
    super.onInit();
  }

  // جلب الإعلانات
  Future<void> fetchAds() async {
    try {
      isLoading(true);
      var response = await _dioClient.get('/ads');
      if (response.statusCode == 200) {
        var data = response.data['ads'] as List;
        adsList.value = data.map((e) => AdModel.fromJson(e)).toList();
      }
    } catch (e) {
      print("Error fetching ads: $e");
    } finally {
      isLoading(false);
    }
  }

  // حذف إعلان
  Future<void> deleteAd(int id) async {
  try {
    // استخدمنا _dioClient.delete إذا كنت قد عرفت instance 
    // أو DioClient.dio.delete إذا كان static
    final response = await _dioClient.delete('/ads/$id');

    if (response.statusCode == 200) {
      // تحديث القائمة في الواجهة فوراً
      adsList.removeWhere((ad) => ad.id == id);
      adsList.refresh(); // لإجبار Obx على التحديث
      
      Get.snackbar(
        "نجاح", 
        "تم حذف الإعلان بنجاح",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.7),
        colorText: Colors.white,
      );
    }
  } catch (e) {
    // طباعة الخطأ في الكونسول لتشخيصه (مهم جداً)
    print("Delete Error: $e"); 
    
    Get.snackbar(
      "خطأ", 
      "فشل حذف الإعلان: تأكد من الصلاحيات",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.7),
      colorText: Colors.white,
    );
  }
}
Future<void> updateAd (int id, Map<String, dynamic> updatedData) async {
    try {
      final response = await _dioClient.put('/ads/$id', data: updatedData);

      if (response.statusCode == 200) {
        // تحديث القائمة في الواجهة فوراً
        int index = adsList.indexWhere((ad) => ad.id == id);
        if (index != -1) {
          adsList[index] = AdModel.fromJson(response.data['ad']);
          adsList.refresh(); // لإجبار Obx على التحديث
        }

        Get.snackbar(
          "نجاح", 
          "تم تحديث الإعلان بنجاح",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.7),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("Update Error: $e"); 
      
      Get.snackbar(
        "خطأ", 
        "فشل تحديث الإعلان",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
    }
  }
}