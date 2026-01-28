import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class Signupcontroller extends GetxController {
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final nameController = TextEditingController();

  bool isPasswordVisible = false;
  String? passwordErrorText;

  // --- متغيرات الموقع ---
  String? selectedGovernorate; // المحافظة المختارة
  String? selectedCity;        // المدينة المختارة

  // بيانات المحافظات والمدن العراقية
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

  // إرجاع قائمة المدن بناءً على المحافظة المختارة حالياً
  List<String> get currentCities {
    if (selectedGovernorate == null) return [];
    return locations[selectedGovernorate] ?? [];
  }

  // دالة تغيير المحافظة
  void changeGovernorate(String? val) {
    selectedGovernorate = val;
    selectedCity = null; // تصفير المدينة عند تغيير المحافظة
    update(); // تحديث الواجهة
  }

  // دالة تغيير المدينة
  void changeCity(String? val) {
    selectedCity = val;
    update(); // تحديث الواجهة
  }

  // --- بقية دوال التحكم بكلمة المرور ---

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    update();
  }

  void clearPasswordError() {
    passwordErrorText = null;
    update();
  }

  void validatePassword() {
    final password = passwordController.text;

    if (password.isEmpty) {
      passwordErrorText = 'Please enter your password';
    } else if (password.length < 8) {
      passwordErrorText = 'Password must be at least 8 characters';
    } else {
      passwordErrorText = null;
    }
    update();
  }
}