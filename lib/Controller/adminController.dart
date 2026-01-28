import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminController extends GetxController {
  final formKey = GlobalKey<FormState>();

  // الحقول النصية
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  // خارطة المواقع
  final Map<String, List<String>> locations = {
    "بغداد": ["بغداد", "الكاظمية", "الأعظمية", "مدينة الصدر", "أبو غريب"],
    "البصرة": ["البصرة", "الزبير", "القرنة", "الفاو", "شط العرب"],
    "نينوى": ["الموصل", "تلعفر", "الحمدانية", "بعاج", "سنجار"],
    "كركوك": ["كركوك", "داقوق", "الحويجة", "تازة خورماتو"],
    "الأنبار": ["الرمادي", "الفلوجة", "القائم", "هيت", "حديثة"],
    "صلاح الدين": ["تكريت", "سامراء", "بيجي", "الشرقاط", "بلد"],
    "ديالى": ["بعقوبة", "الخالص", "المقدادية", "خانقين", "بلدروز"],
    "بابل": ["الحلة", "المحاويل", "المسيب", "الهاشمية", "القاسم"],
    "كربلاء": ["كربلاء", "عين التمر", "الحسينية"],
    "النجف": ["النجف", "الكوفة", "المناذرة", "المشخاب"],
    "القادسية": ["الديوانية", "الشامية", "عفك", "غماس"],
    "واسط": ["الكوت", "النعمانية", "الحي", "الصويرة", "العزيزية"],
    "ميسان": ["العمارة", "المجر الكبير", "قلعة صالح", "علي الغربي", "علي الشرقي"],
    "ذي قار": ["الناصرية", "الشطرة", "سوق الشيوخ", "الرفاعي", "الجبايش"],
    "المثنى": ["السماوة", "الرميثة", "الخضر", "السلمان"],
    "حلبجة": ["حلبجة", "خورمال", "بيارة", "سيد صادق"],
    "أربيل": ["أربيل", "عنكاوا", "خبات", "كويسنجق", "مخمور"],
    "دهوك": ["دهوك", "زاخو", "العمادية", "سيميل", "عقرة"]
  };

  // القيم المختارة
  var selectedGovernorate = Rxn<String>();
  var selectedCity = Rxn<String>();

  // قائمة المدن المتاحة
  var availableCities = <String>[].obs;

  // تحديث المحافظة وتصفية المدن
  void updateGovernorate(String? gov) {
    selectedGovernorate.value = gov;
    selectedCity.value = null; // تصفير المدينة عند تغيير المحافظة
    if (gov != null) {
      availableCities.value = locations[gov] ?? [];
    } else {
      availableCities.value = [];
    }
  }

  // دالة حفظ أدمن المحافظة (يستخدمها السوبر أدمن)
  void createGovernorateAdmin() {
    if (formKey.currentState!.validate()) {
      Get.snackbar(
        "تمت العملية",
        "جاري إنشاء أدمن محافظة لـ: ${selectedGovernorate.value}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.indigo,
        colorText: Colors.white,
      );
      // هنا تضع كود الربط مع الباك إند
    }
  }

  // دالة حفظ أدمن المدينة (يستخدمها أدمن المحافظة)
  void createCityAdmin() {
    if (formKey.currentState!.validate()) {
      Get.snackbar(
        "تمت العملية",
        "جاري إنشاء أدمن مدينة لـ: ${selectedCity.value} في ${selectedGovernorate.value}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.teal,
        colorText: Colors.white,
      );
      // هنا تضع كود الربط مع الباك إند
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }
  // داخل كلاس AdminController
  void saveAdmin() {
    if (formKey.currentState!.validate()) {
      // هنا تضع منطق حفظ البيانات أو إرسالها للسيرفر
      print("تم حفظ بيانات المشرف: ${nameController.text}");

      // إظهار رسالة نجاح
      Get.snackbar(
        "تم بنجاح",
        "تم اعتماد المشرف الجديد",
        snackPosition: SnackPosition.TOP,
        colorText: Colors.black,
      );

      // إفراغ الحقول بعد الحفظ (اختياري)
      nameController.clear();
      phoneController.clear();
      passwordController.clear();
    }
  }
}