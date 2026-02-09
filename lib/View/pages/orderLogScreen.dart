import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:friends_admin/constence/MyColor.dart';
import '../../Controller/OrderLogController.dart';
import '../../Controller/SettingsController.dart';

class OrderLogScreen extends StatelessWidget {
  const OrderLogScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // استخدام Get.put لضمان إنشاء الكونترولر إذا لم يكن موجوداً
    final controller = Get.put(OrderLogController());

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("سجل كافة الطلبات", style: TextStyle(color: Colors.white)),
        backgroundColor: MyColor.primaryBlue,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.refreshOrders(),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.filteredOrders.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: controller.filteredOrders.length,
            itemBuilder: (context, index) {
              final order = controller.filteredOrders[index];
              // ✅ التعديل هنا: نمرر context للدالة
              return _buildOrderCard(context, order);
            },
          );
        }),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.list_alt, size: 70, color: Colors.grey[400]),
          const Text("لا توجد طلبات متوفرة حالياً"),
        ],
      ),
    );
  }

  // ✅ التعديل هنا: إضافة BuildContext context كـ parameter
  Widget _buildOrderCard(BuildContext context, order) {
    final controller = Get.find<OrderLogController>();
    final controller1 = Get.put(SettingsController());
    // ✅ التعديل هنا: إخفاء الزر إذا كانت الرتبة city_admin
    // الزر يظهر فقط إذا لم تكن الرتبة city_admin
    bool canDelete = controller1.userRole.value != 'city_admin';

    Color statusColor;
    String statusText;

    switch (order.status) {
      case 'accepted':
        statusColor = Colors.green;
        statusText = "مقبول";
        break;
      case 'rejected':
        statusColor = Colors.red;
        statusText = "مرفوض";
        break;
      default:
        statusColor = Colors.orange;
        statusText = "قيد الانتظار";
    }

    return Card(
      elevation: 3,
      shadowColor: Colors.black12,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(order.customerName, style: const TextStyle(fontWeight: FontWeight.bold))),

                // ✅ الشرط هنا سيمنع رسم الزر إذا كان canDelete = false
                if (canDelete)
                  Material(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => _showDeleteConfirmation(context, controller, order.id),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.delete_outline, color: Colors.red, size: 22),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(order.serviceName, style: TextStyle(color: MyColor.primaryBlue, fontWeight: FontWeight.w600)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: statusColor.withOpacity(0.5))
                  ),
                  child: Text(statusText,
                      style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Divider(),
            ),
            _infoRow(Icons.location_on_outlined, order.location, Colors.redAccent),
            const SizedBox(height: 8),
            _infoRow(Icons.map_outlined, "${order.governorate} - ${order.city}", Colors.blueGrey),
            const SizedBox(height: 8),
            _infoRow(Icons.phone_outlined, order.phone, Colors.green),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, OrderLogController controller, int orderId) {
    Get.defaultDialog(
      title: "حذف الطلب",
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
      middleText: "هل أنت متأكد من رغبتك في حذف هذا الطلب نهائياً؟\nلا يمكن التراجع عن هذا الإجراء.",
      textCancel: "إلغاء",
      textConfirm: "حذف",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        Get.back();
        controller.deleteOrder(orderId);
      },
    );
  }

  Widget _infoRow(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 13), overflow: TextOverflow.ellipsis)),
      ],
    );
  }
}