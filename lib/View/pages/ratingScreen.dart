import 'package:flutter/material.dart';

import '../../constence/MyColor.dart';
import '../widget/customerRatingItem.dart';

class RatingScreen extends StatelessWidget {
  const RatingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // قائمة تجريبية للبيانات
    final List<Map<String, dynamic>> ratingsData = [
      {"name": "أحمد محمد", "score": 5, "service": "تنظيف منازل"},
      {"name": "سارة أحمد", "score": 4, "service": "غسيل سيارات"},
      {"name": "خالد العتيبي", "score": 3, "service": "صيانة مكيفات"},
    ];
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        title: const Text(
          "التقييم",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: MyColor.primaryBlue,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 10),
        itemCount: ratingsData.length,
        itemBuilder: (context, index) {
          return CustomerRatingItem(
            customerName: ratingsData[index]['name'],
            serviceName: ratingsData[index]['service'],
            rating: ratingsData[index]['score'],
          );
        },
      ),
    );
  }
}