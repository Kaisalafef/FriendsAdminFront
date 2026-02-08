import 'package:flutter/material.dart';

import 'package:friends_admin/core/api/dio_client.dart';
import 'package:get/get.dart';

import '../Model/EventModel.dart';
class EventsController extends GetxController {
  var isLoading = true.obs;
  var eventsList = <EventModel>[].obs;
  final DioClient _dioClient = DioClient();
  @override
  void onInit() {
    fetchEvents();
    super.onInit();
  }

  Future<void>  fetchEvents() async {
    try {
      isLoading(true);
      // طلب GET للرابط /events
      var response = await _dioClient.get('/events');

      if (response.statusCode == 200) {
        // بما أن الباك اند يستخدم paginate(10)، البيانات تكون داخل 'data'
        var jsonData = response.data;
        var data = jsonData['data'] as List;

        eventsList.value = data.map((e) => EventModel.fromJson(e)).toList();
      }
    } catch (e) {
      print("Error fetching events: $e");
    } finally {
      isLoading(false);
    }
  }
  // داخل كلاس EventsController

Future<void> deleteEvent(int eventId) async {
  try {
    isLoading(true);
    // إرسال طلب الحذف
    var response = await _dioClient.delete('/events/$eventId');

    if (response.statusCode == 200) {
      // إزالة العنصر من القائمة المحلية لتحديث الواجهة فوراً
      eventsList.removeWhere((event) => event.id == eventId);
      
      Get.snackbar("نجاح", "تم حذف العمل بنجاح", 
          backgroundColor: Colors.green, colorText: Colors.white);
    }
  } catch (e) {
    print("Error deleting event: $e");
    Get.snackbar("خطأ", "فشل في حذف العمل", 
        backgroundColor: Colors.red, colorText: Colors.white);
  } finally {
    isLoading(false);
  }
}
}