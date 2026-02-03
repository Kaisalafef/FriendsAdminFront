import 'package:flutter/cupertino.dart';
import 'package:friends_admin/View/pages/HomeScreen.dart';
import 'package:get/get.dart';
import 'package:friends_admin/core/api/dio_client.dart'; // تأكد من صحة المسار لديك
import 'package:friends_admin/View/pages/LoginPage.dart'; // للعودة بعد النجاح

class Signupcontroller extends GetxController {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();
  final nameController = TextEditingController();

  // متغيرات الحالة
  bool isPasswordVisible = false;
  String? passwordErrorText;
  bool isLoading = false; // متغير لمؤشر التحميل

  // سطر الربط مع Dio
  final DioClient _dioClient = DioClient();

  // --- متغيرات الموقع ---
  String? selectedGovernorate; 
  String? selectedCity;        
  
  // بيانات المحافظات والمدن العراقية (تم الحفاظ عليها كما هي)
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

  List<String> get currentCities {
    if (selectedGovernorate == null) return [];
    return locations[selectedGovernorate] ?? [];
  }

  void changeGovernorate(String? val) {
    selectedGovernorate = val;
    selectedCity = null; 
    update(); 
  }

  void changeCity(String? val) {
    selectedCity = val;
    update(); 
  }

  // --- دالة الربط مع Laravel (الجديدة) ---
  Future<void> signup() async {
    if (passwordController.text != confirmPasswordController.text) {
    Get.snackbar("خطأ", "كلمتا السر غير متطابقتين");
    return;
  }
    // التأكد من اختيار الموقع أولاً
    if (selectedGovernorate == null || selectedCity == null) {
      Get.snackbar("تنبيه", "يرجى اختيار المحافظة والمدينة");
      return;
    }

    isLoading = true;
    update();

    try {
      final response = await _dioClient.post('/register', data: {
        'name': nameController.text,
        'email': phoneController.text, // إرسال الهاتف في حقل email كما يتوقع الباك إند
        'password': passwordController.text,
        'password_confirmation': passwordController.text, // مطلوب للـ Validation
        'governorate': selectedGovernorate,
        'city': selectedCity,
      });

      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.snackbar("نجاح", "تم إنشاء الحساب بنجاح");
        Get.offAll(() => HomeScreen()); // العودة لصفحة تسجيل الدخول
      }
    } catch (e) {
      Get.snackbar("خطأ", "فشل إنشاء الحساب، يرجى المحاولة لاحقاً");
      print("Signup Error: $e");
    } finally {
      isLoading = false;
      update();
    }
  }

  // --- دوال التحكم بالواجهة ---

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
      passwordErrorText = 'يرجى إدخال كلمة السر';
    } else if (password.length < 8) {
      passwordErrorText = 'يجب أن تكون كلمة السر 8 محارف على الأقل';
    } else {
      passwordErrorText = null;
    }
    update();
  }
}