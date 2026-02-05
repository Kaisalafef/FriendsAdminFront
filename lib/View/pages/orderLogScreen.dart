import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:friends_admin/constence/MyColor.dart';
import '../../Controller/OrderLogController.dart';

class OrderLogScreen extends StatelessWidget {
  const OrderLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderLogController());

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("سجل الطلبات", style: TextStyle(color: Colors.white)),
        backgroundColor: MyColor.primaryBlue,
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
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
    );
  }

  Widget _buildEmptyState() {
    return ListView( // استخدمنا ListView لكي يعمل الـ RefreshIndicator
      children: [
        SizedBox(height: Get.height * 0.3),
        Center(
          child: Column(
            children: [
              Icon(Icons.list_alt, size: 70, color: Colors.grey[400]),
              const Text("لا توجد طلبات متوفرة لصلاحياتك حالياً"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderCard(order) {
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
                Text(order.serviceName, style: TextStyle(color: MyColor.primaryBlue, fontWeight: FontWeight.bold)),
              ],
            ),
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
        Text(text, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}