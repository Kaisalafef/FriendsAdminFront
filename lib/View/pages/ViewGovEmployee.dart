import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controller/adminController.dart';
import '../../constence/MyColor.dart';

class ViewGovEmployee extends StatelessWidget {
  const ViewGovEmployee({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchAllEmployees();
    });

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "كافة المشرفين",
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
          return Center(child: Text("لا يوجد بيانات", style: TextStyle(color: Colors.grey[600])));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.employeesList.length,
          itemBuilder: (context, index) {
            final emp = controller.employeesList[index];
            return InkWell(
              onTap: () => _showOptionsBottomSheet(context, emp), // استدعاء قائمة الخيارات
              borderRadius: BorderRadius.circular(16),
              child: _buildGovCard(emp),
            );
          },
        );
      }),
    );
  }
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
  Widget _buildGovCard(Map emp) {
    // تحديد نوع الرتبة لتغيير اللون
    bool isGovAdmin = emp['role'] == 'admin'; // افتراض أن 'admin' هو أدمن المحافظة
    Color roleColor = isGovAdmin ? Colors.orange : MyColor.primaryBlue;
    String roleName = isGovAdmin ? "أدمن محافظة" : "أدمن مدينة";

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
        // شريط جانبي ملون لتمييز الرتبة
        border: Border(right: BorderSide(color: roleColor, width: 4)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // الأيقونة
                CircleAvatar(
                  radius: 22,
                  backgroundColor: roleColor.withOpacity(0.1),
                  child: Icon(
                    isGovAdmin ? Icons.admin_panel_settings : Icons.location_city,
                    color: roleColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 15),

                // البيانات
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // الاسم والتاج
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              emp['name'] ?? "غير معروف",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // "تاج" يوضح الرتبة
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: roleColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              roleName,
                              style: TextStyle(color: roleColor, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // المحافظة والمدينة
                      Text(
                        "${emp['governorate']} - ${emp['city']}",
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),

                      const Divider(height: 20), // خط فاصل خفيف

                      // رقم الهاتف
                      Row(
                        children: [
                          Icon(Icons.phone_android, size: 16, color: Colors.grey[500]),
                          const SizedBox(width: 5),
                          Text(
                            emp['phone'] ?? emp['email'] ?? "لا يوجد رقم",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}