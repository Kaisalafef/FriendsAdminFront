import 'package:get/get.dart';
import '../../core/api/dio_client.dart';
import '../../Controller/LoginController.dart';
import '../../Controller/SignupController.dart';
import '../../Controller/adminController.dart';
import '../../Controller/AdsController.dart';
import '../../Controller/AddAdController.dart';
import '../../Controller/EventController.dart';
import '../../Controller/AdEventController.dart';
import '../../Controller/NotificationController.dart';
import '../../Controller/orderLogController.dart';
import '../../Controller/SettingsController.dart';
import '../../Controller/LogoutController.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    // 1. الأساسيات (Core)
    Get.lazyPut(() => DioClient(), fenix: true);

    // 2. كنترولات المصادقة (Auth)
    Get.lazyPut(() => LoginController(), fenix: true);
    Get.lazyPut(() => Signupcontroller(), fenix: true); // لاحظ الاسم حسب ملفك
    Get.lazyPut(() => LogoutController(), fenix: true);

    // 3. كنترولات الإدارة والبيانات
    Get.lazyPut(() => AdminController(), fenix: true);
    Get.lazyPut(() => AdsController(), fenix: true);
    Get.lazyPut(() => AddAdController(), fenix: true);
    Get.lazyPut(() => EventsController(), fenix: true); // الاسم داخل ملف EventController
    Get.lazyPut(() => AddEventController(), fenix: true); // الاسم داخل ملف AdEventController

    // 4. كنترولات الطلبات والإشعارات
    Get.lazyPut(() => NotificationController(), fenix: true);
    Get.lazyPut(() => OrderLogController(), fenix: true);
    Get.lazyPut(() => SettingsController(), fenix: true);
  }
}