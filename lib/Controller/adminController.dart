import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:friends_admin/core/api/dio_client.dart'; // تأكد من المسار

class AdminController extends GetxController {
  final DioClient _dioClient = DioClient();
  final formKey = GlobalKey<FormState>();

  // الحقول
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  // المتغيرات
  var isLoading = false.obs;
  var employeesList = <dynamic>[].obs; // القائمة القادمة من السيرفر

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

  var selectedGovernorate = Rxn<String>();
  var selectedCity = Rxn<String>();
  var availableCities = <String>[].obs;

  void updateGovernorate(String? gov) {
    selectedGovernorate.value = gov;
    selectedCity.value = null;
    if (gov != null) {
      availableCities.value = locations[gov] ?? [];
    } else {
      availableCities.value = [];
    }
  }

  // --- العمليات (API) ---

  // دالة مساعدة للإرسال
  Future<void> _submitAdmin({required String role}) async {
    if (!formKey.currentState!.validate()) return;

    if (selectedGovernorate.value == null) {
      Get.snackbar("خطأ", "يرجى اختيار المحافظة");
      return;
    }
    if (role == 'city_admin' && selectedCity.value == null) {
      Get.snackbar("خطأ", "يرجى اختيار المدينة");
      return;
    }

    isLoading.value = true;
    try {
      final response = await _dioClient.post('/create-admin', data: {
        'name': nameController.text,
        'phone': phoneController.text,
        'password': passwordController.text,
        'governorate': selectedGovernorate.value,
        'city': selectedCity.value,
        'role': role,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("نجاح", "تمت الإضافة بنجاح", backgroundColor: Colors.green, colorText: Colors.white);
        _clearFields();
        Get.back();
      }
    } catch (e) {
      print("Create Admin Error: $e");
      Get.snackbar("خطأ", "فشل إضافة المشرف، ربما الهاتف مكرر أو انت خارج نطاق محافظتك", backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // 1. حفظ أدمن المحافظة
  void saveGovernorateAdmin() {
    _submitAdmin(role: 'admin');
  }

  // 2. حفظ أدمن المدينة
  void saveCityAdmin(String CurrentUserGov) {
    if (selectedGovernorate.value != CurrentUserGov) {
      Get.snackbar(
        "تنبيه", 
        "لا يمكنك إضافة موظف في محافظة أخرى. يرجى اختيار محافظتك ($CurrentUserGov)",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return; // إيقاف العملية ومنع الإرسال
    }
    _submitAdmin(role: 'city_admin');
  }

  // 3. جلب موظفي المدن (لأدمن المحافظة)
  void fetchCityEmployees() async {
    isLoading.value = true;
    try {
      final response = await _dioClient.get('/city-admins');
      if (response.statusCode == 200) {
        employeesList.value = response.data;
      }
    } catch (e) {
      print("Fetch City Admins Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // 4. جلب جميع المشرفين (للسوبر أدمن)
  void fetchAllEmployees() async {
    isLoading.value = true;
    try {
      final response = await _dioClient.get('/all-admins');
      if (response.statusCode == 200) {
        employeesList.value = response.data;
      }
    } catch (e) {
      print("Fetch All Admins Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void _clearFields() {
    nameController.clear();
    phoneController.clear();
    passwordController.clear();
    selectedGovernorate.value = null;
    selectedCity.value = null;
  }
  // داخل كلاس AdminController

Future<void> deleteEmployee(int id) async {
  try {
    isLoading.value = true;
    
    // الاتصال بالباك إند
    final response = await _dioClient.delete('/delete-admin/$id');

    if (response.statusCode == 200) {
      // حذف العنصر من القائمة المحلية لتحديث الواجهة فوراً
      employeesList.removeWhere((emp) => emp['id'] == id);
      
      Get.snackbar("نجاح", "تم حذف الموظف بنجاح", 
          backgroundColor: Colors.green, colorText: Colors.white);
    }
  } catch (e) {
    print("Delete Error: $e");
    Get.snackbar("خطأ", "فشل عملية الحذف", 
        backgroundColor: Colors.red, colorText: Colors.white);
  } finally {
    isLoading.value = false;
  }
}
}