import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controller/adminController.dart';
import '../../constence/MyColor.dart';

class ViewCityEmployee extends StatelessWidget {
  const ViewCityEmployee({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminController>();

    // جلب البيانات عند فتح الصفحة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchCityEmployees();
    });

    return Scaffold(
      backgroundColor: Colors.grey[100], // خلفية فاتحة للصفحة
      appBar: AppBar(
        title: const Text(
          "موظفي المدن",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: MyColor.primaryBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: MyColor.primaryBlue));
        }
        if (controller.employeesList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline, size: 80, color: Colors.grey[400]),
                const SizedBox(height: 10),
                Text("لا يوجد موظفين حالياً", style: TextStyle(color: Colors.grey[600], fontSize: 18)),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.employeesList.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final emp = controller.employeesList[index];
            return InkWell(
              onTap: () => _showOptionsBottomSheet(context, emp), // استدعاء قائمة الخيارات
              borderRadius: BorderRadius.circular(16),
              child: _buildEmployeeCard(emp),
            );
          },
        );
      }),
    );
  }


// --- أضف هذه الدالة داخل الكلاس ---

  void _showOptionsBottomSheet(BuildContext context, Map emp) {
  Get.bottomSheet(
  Container(
  padding: const EdgeInsets.all(20),
  decoration: const BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.only(
  topLeft: Radius.circular(20),
  topRight: Radius.circular(20),
  ),
  ),
  child: Column(
  mainAxisSize: MainAxisSize.min,
  children: [
  Text(
  "إجراءات على الحساب: ${emp['name']}",
  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
  ),
  const SizedBox(height: 20),

  // خيار الحذف
  ListTile(
  leading: const Icon(Icons.delete_forever, color: Colors.red),
  title: const Text("حذف الحساب نهائياً", style: TextStyle(color: Colors.red)),
  onTap: () {
  Get.back();
  _showDeleteConfirmation(emp); // تأكيد الحذف
  },
  ),
  const SizedBox(height: 10),
  ],
  ),
  ),
  );
  }

  void _showDeleteConfirmation(Map emp) {
    final AdminController controller = Get.find();
  Get.defaultDialog(
  title: "تأكيد الحذف",
  middleText: "هل أنت متأكد من حذف حساب ${emp['name']}؟",
  textConfirm: "نعم، حذف",
  textCancel: "إلغاء",
  confirmTextColor: Colors.white,
  buttonColor: Colors.red,
  onConfirm: () {
  // استدعاء دالة الحذف من الكنترولر وتمرير ID الموظف
  controller.deleteEmployee(emp['id']);
  Get.back();
  },
  );
  }
  // ودجت مخصص للبطاقة لتجميل التصميم
  Widget _buildEmployeeCard(Map emp) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // 1. الصورة الرمزية (Avatar)
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: MyColor.primaryBlue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person, color: MyColor.primaryBlue, size: 30),
            ),
            const SizedBox(width: 16),

            // 2. تفاصيل الموظف
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // الاسم
                  Text(
                    emp['name'] ?? "بدون اسم",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // المدينة
                  Row(
                    children: [
                      Icon(Icons.location_city, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        emp['city'] ?? "غير محدد",
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // رقم الهاتف (مميز بلون مختلف)
                  Row(
                    children: [
                      Icon(Icons.phone, size: 14, color: MyColor.primaryBlue),
                      const SizedBox(width: 4),
                      Text(
                        emp['phone'] ?? emp['email'] ?? "لا يوجد رقم", // أحياناً يخزن الرقم في الإيميل حسب الباك إند
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: MyColor.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}