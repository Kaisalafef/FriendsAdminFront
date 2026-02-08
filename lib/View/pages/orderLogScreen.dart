import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:friends_admin/constence/MyColor.dart';
import '../../Controller/OrderLogController.dart';

class OrderLogScreen extends StatelessWidget {
  const OrderLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderLogController>();

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
              return _buildOrderCard(order);
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

  Widget _buildOrderCard(order) {
    // تحديد لون الحالة
    Color statusColor;
    String statusText;

    switch (order.status) {
      case 'accepted': statusColor = Colors.green; statusText = "مقبول"; break;
      case 'rejected': statusColor = Colors.red; statusText = "مرفوض"; break;
      default: statusColor = Colors.orange; statusText = "قيد الانتظار";
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(order.customerName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                // عرض حالة الطلب
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: statusColor)
                  ),
                  child: Text(statusText, style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(order.serviceName, style: TextStyle(color: MyColor.primaryBlue, fontWeight: FontWeight.w500)),
            const Divider(),
            _infoRow(Icons.location_on, order.location, Colors.red),
            const SizedBox(height: 5),
            _infoRow(Icons.map, "${order.governorate} - ${order.city}", Colors.blueGrey),
            const SizedBox(height: 5),
            _infoRow(Icons.phone, order.phone, Colors.green),
          ],
        ),
      ),
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