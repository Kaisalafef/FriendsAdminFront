import 'package:get/get.dart';

import '../View/widget/orderModel.dart';
 // تأكد من المسار

enum AdminRole { superAdmin, governorateAdmin, cityAdmin }

class OrderLogController extends GetxController {
  // === محاكاة بيانات الأدمن المسجل دخوله حالياً ===
  // في التطبيق الحقيقي، هذه البيانات تأتي من خدمة المصادقة (AuthService)
  final AdminRole currentRole = AdminRole.superAdmin; // غير هذا للتجربة: governorateAdmin أو cityAdmin
  final String adminGovernorate = "القاهرة";
  final String adminCity = "مدينة نصر";
  // ===========================================

  var allOrders = <OrderModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  void fetchOrders() {
    // محاكاة جلب البيانات من السيرفر
    var serverData = [
      OrderModel(id: '1', customerName: 'أحمد محمد', location: 'شارع 9، المعادي', governorate: 'القاهرة', city: 'المعادي', serviceName: 'صيانة تكييف', date: DateTime.now()),
      OrderModel(id: '2', customerName: 'سارة علي', location: 'عباس العقاد', governorate: 'القاهرة', city: 'مدينة نصر', serviceName: 'نظافة منزلية', date: DateTime.now()),
      OrderModel(id: '3', customerName: 'محمود حسن', location: 'محطة الرمل', governorate: 'الإسكندرية', city: 'وسط البلد', serviceName: 'سباكة', date: DateTime.now()),
      OrderModel(id: '4', customerName: 'خالد جمال', location: 'شارع الهرم', governorate: 'الجيزة', city: 'الهرم', serviceName: 'كهرباء', date: DateTime.now()),
    ];
    allOrders.assignAll(serverData);
  }

  // هذه القائمة هي التي سيتم عرضها في الواجهة بناءً على الفلترة
  List<OrderModel> get filteredOrders {
    switch (currentRole) {
      case AdminRole.superAdmin:
      // السوبر أدمن يرى كل شيء
        return allOrders;

      case AdminRole.governorateAdmin:
      // يرى فقط طلبات محافظته
        return allOrders.where((order) => order.governorate == adminGovernorate).toList();

      case AdminRole.cityAdmin:
      // يرى فقط طلبات مدينته
        return allOrders.where((order) => order.city == adminCity).toList();

      default:
        return [];
    }
  }
}