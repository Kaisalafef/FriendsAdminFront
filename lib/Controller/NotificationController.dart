import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/api/dio_client.dart';
import '../Model/HomeServiceModel.dart';

class NotificationController extends GetxController {
  var isLoading = true.obs;
  var requestList = <HomeServiceModel>[].obs;
  final DioClient _dioClient = DioClient();

  // جلب الطلبات قيد الانتظار فقط للعرض في شاشة الإشعارات
  List<HomeServiceModel> get pendingRequests =>
      requestList.where((req) => req.status == 'pending').toList();

  @override
  void onInit() {
    fetchRequests();
    super.onInit();
  }

  Future<void> fetchRequests() async {
    try {
      isLoading(true);
      var response = await _dioClient.get('/home-services');

      if (response.statusCode == 200) {
        var data = response.data['data'] as List;

        requestList.value = data.map((e) {
          List<String> imageUrls = [];
          if (e['images'] != null) {
            imageUrls = (e['images'] as List).map((img) {
              return "http://192.168.10.80:8000/storage/${img['image_path']}";
            }).toList();
          }

          return HomeServiceModel(
            id: e['id'],
            userId: e['user_id'] ?? 0,
            userName: e['user']?['name'] ?? "عميل",
            description: e['description'],
            address: e['address'],
            serviceType: e['service_type'],
            phone: e['phone'] ?? "لا يوجد رقم",
            profession: e['profession'] ?? "غير محدد",
            status: e['status'] ?? 'pending',
            images: imageUrls,
          );
        }).toList();
      }
    } catch (e) {
      print("Error fetching notifications: $e");
    } finally {
      isLoading(false);
    }
  }

  // في ملف NotificationController.dart

// 1. عدل تعريف الدالة لتستقبل note (اختياري)
Future<bool> updateRequestStatus(int requestId, String newStatus, {String? note}) async {
  try {
    // 2. إرسال الملاحظة مع الـ Body
    var response = await _dioClient.put(
      '/home-services/$requestId/status',
      data: {
        'status': newStatus,
        'admin_note': note // <--- هذا هو التعديل المهم
      },
    );

    if (response.statusCode == 200) {
      await fetchRequests(); // تحديث القائمة
      return true;
    }
    return false;
  } catch (e) {
    Get.snackbar("خطأ", "فشل تحديث الحالة: $e", backgroundColor: Colors.red, colorText: Colors.white);
    return false;
  }
}

  Future<void> sendNotification({
    required int userId,
    required String title,
    required String message,
  }) async {
    try {
      await _dioClient.post('/admin/notifications', data: {
        'user_id': userId,
        'title': title,
        'message': message,
      });
    } catch (e) {
      print("Error sending notification: $e");
    }
  }
}