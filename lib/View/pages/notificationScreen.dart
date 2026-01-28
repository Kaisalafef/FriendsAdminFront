import 'package:flutter/material.dart';
import 'package:friends_admin/constence/MyColor.dart';
// import 'package:get/get_core/src/get_main.dart'; // غير مستخدم هنا مباشرة
// import 'package:get/get_navigation/src/extension_navigation.dart';

import '../widget/NotificationItem.dart';
// import 'RequestDetailsScreen.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // تحديث البيانات لتشمل النوع ورقم الهاتف
    final List<Map<String, String>> requests = [
      {
        'name': 'أحمد',
        'desc': 'طلب صيانة مكيف مركزي في الطابق الثاني',
        'location': 'الرياض، حي النرجس',
        'type': 'special', // نوع الطلب: خاص
        'phone': '0500000000' // رقم الهاتف (لن يظهر لأن النوع خاص)
      },
      {
        'name': 'سارة',
        'desc': 'تصميم داخلي مستعجل للمكتب',
        'location': 'جدة، حي الروضة',
        'type': 'direct', // نوع الطلب: مباشر
        'phone': '0551234567' // سيظهر هذا الرقم
      },
      {
        'name': 'شركة النور',
        'desc': 'طلب توريد مواد بناء للموقع الجديد',
        'location': 'الدمام، المنطقة الصناعية',
        'type': 'direct', // نوع الطلب: مباشر
        'phone': '0569876543' // سيظهر هذا الرقم
      },
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        title: const Text("الإشعارات", style: TextStyle(color: Colors.white)),
        backgroundColor: MyColor.primaryBlue,
      ),
      body: requests.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications, size: 100, color: MyColor.primaryBlue),
            const SizedBox(height: 20),
            const Text(
              "لا توجد إشعارات جديدة حالياً",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: requests.length,
        itemBuilder: (context, index) {
          return NotificationItem(
            context,
            requests[index]['name']!,
            requests[index]['desc']!,
            requests[index]['location']!,
            requests[index]['type']!,  // تمرير النوع
            requests[index]['phone']!, // تمرير الهاتف
          );
        },
      ),
    );
  }
}