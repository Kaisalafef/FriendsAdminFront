import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:friends_admin/constence/MyColor.dart';
import '../../Controller/OrderLogController.dart';
import '../widget/orderModel.dart';

class OrderLogScreen extends StatelessWidget {
  const OrderLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderLogController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("سجل الطلبات", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: MyColor.primaryBlue,
        centerTitle: true,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
      ),
      body: Obx(() {
        if (controller.filteredOrders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey[300]),
                const SizedBox(height: 10),
                Text("لا توجد طلبات لعرضها", style: TextStyle(color: Colors.grey[500], fontSize: 18)),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.filteredOrders.length,
          itemBuilder: (context, index) {
            final order = controller.filteredOrders[index];
            return _buildOrderCard(order);
          },
        );
      }),
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: MyColor.primaryBlue.withOpacity(0.1)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(order.customerName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: MyColor.primaryBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                child: Text(order.serviceName, style: TextStyle(fontSize: 12, color: MyColor.primaryBlue, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const Divider(height: 25),
          Row(
            children: [
              Icon(Icons.location_on, size: 18, color: Colors.red[400]),
              const SizedBox(width: 8),
              Expanded(child: Text(order.location, style: const TextStyle(fontSize: 14, color: Colors.black87))),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.map_outlined, size: 18, color: Colors.grey[400]),
              const SizedBox(width: 8),
              Text("${order.governorate} - ${order.city}", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              const Spacer(),
              Text(order.date.toString().substring(0, 10), style: TextStyle(fontSize: 12, color: Colors.grey[400])),
            ],
          ),
        ],
      ),
    );
  }
}