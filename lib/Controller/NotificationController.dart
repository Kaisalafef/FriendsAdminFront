import 'package:get/get.dart';
import '../core/api/dio_client.dart';
import '../Model/HomeServiceModel.dart';

class NotificationController extends GetxController {
  var isLoading = true.obs;
  var requestList = <HomeServiceModel>[].obs;
  final DioClient _dioClient = DioClient();

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
          // جلب الصور وتحويلها لروابط كاملة
          List<String> imageUrls = [];
          if (e['images'] != null) {
            imageUrls = (e['images'] as List).map((img) {
              // تأكد من صحة الـ IP الخاص بك هنا
              return "http://192.168.0.107:8000/storage/${img['image_path']}";
            }).toList();
          }

          return HomeServiceModel(
            id: e['id'],
            userName: e['user']?['name'] ?? "عميل",
            description: e['description'],
            address: e['address'],
            serviceType: e['service_type'],
            phone: e['phone'] ?? "لا يوجد رقم", // جلب الهاتف
            profession: e['profession'] ?? "غير محدد", // تأكد من إضافة هذا السطر
            images: imageUrls, // قائمة الروابط الكاملة
          );
        }).toList();
      }
    } catch (e) {
      print("Error fetching notifications: $e");
    } finally {
      isLoading(false);
    }
  }
}