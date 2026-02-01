import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:friends_admin/constence/MyColor.dart';

class CustomerRatingItem extends StatelessWidget {
  final String customerName;
  final String serviceName;
  final int rating;

  const CustomerRatingItem({
    super.key,
    required this.customerName,
    required this.serviceName,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        // إضافة padding داخلي للـ Card بالكامل لتوسيع المساحة
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. اسم الشخص (تم تكبير الخط من 16 إلى 22)
            Text(
              customerName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 5), // زيادة المسافة الفاصلة

            // 2. صف يحتوي على اسم الخدمة والنجوم
            Row(
              children: [
                // اسم الخدمة (تم تكبير الخط من 14 إلى 18)
                Expanded( // يفضل استخدام Expanded لضمان عدم حدوث overflow إذا كان النص طويلاً
                  child: Text(
                    serviceName,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                const SizedBox(width: 5),

                // رسم النجوم (تم تكبير حجم النجمة من 18 إلى 26)
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 18,
                    );
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}