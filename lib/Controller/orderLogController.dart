import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../View/widget/orderModel.dart';
import '../core/api/dio_client.dart';

class OrderLogController extends GetxController {
  final DioClient _dioClient = DioClient();

  var isLoading = true.obs;
  var filteredOrders = <OrderModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void > fetchOrders() async {
    try {
      isLoading(true);

      // استخدام DioClient الذي يضيف التوكن تلقائياً عبر Interceptors
      final response = await _dioClient.get('/home-services');

      if (response.statusCode == 200) {
        // الوصول للبيانات داخل حقل 'data' كما يرسلها Laravel
        List<dynamic> data = response.data['data'];
        filteredOrders.assignAll(
            data.map((e) => OrderModel.fromJson(e)).toList()
        );
      }
    } catch (e) {
      // حل مشكلة LateInitializationError للسناكب بار
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar(
            "تنبيه",
            "فشل في جلب البيانات، تأكد من الاتصال بالسيرفر",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent.withOpacity(0.8),
            colorText: Colors.white
        );
      });
      print("Error: $e");
    } finally {
      isLoading(false);
    }
  }

  // دالة للتحديث اليدوي (Swipe to Refresh)
  Future<void> refreshOrders() async {
    await fetchOrders();
  }
}