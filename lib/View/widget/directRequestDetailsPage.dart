import 'package:flutter/material.dart';
import 'package:friends_admin/View/pages/HomeScreen.dart';
import 'package:friends_admin/constence/MyColor.dart';
import 'package:get/get.dart'; // تم استخدام get للإيجاز بدلاً من المسارات الطويلة

class DirectRequestDetailsPage extends StatelessWidget {
  final String userName;
  final String location;
  final String phone;
  final String note;

  const DirectRequestDetailsPage({
    super.key,
    required this.userName,
    required this.location,
    required this.phone,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // خلفية فاتحة جداً لإبراز البطاقة
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          "تفاصيل طلب $userName",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: MyColor.primaryBlue,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // --- بطاقة التفاصيل ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildDetailItem(
                    title: "اسم صاحب الطلب",
                    value: userName,
                    icon: Icon(Icons.person, color: MyColor.primaryBlue),
                  ),
                  _buildDetailItem(
                    title: "الموقع",
                    value: location,
                    icon: Icon(Icons.location_on, color: Colors.red[600]),
                    widget: TextButton.icon(
                      onPressed: () {
                        Get.to(HomeScreen());
                      },
                      label: const Text(
                        "اعرض الخريطة",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      icon: Icon(Icons.map, color: MyColor.primaryBlue, size: 18),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.centerRight,
                      ),
                    ),
                  ),
                  _buildDetailItem(
                    title: "رقم الهاتف",
                    value: phone,
                    icon: Icon(Icons.phone, color: MyColor.primaryBlue),
                  ),
                  // إزالة الخط الفاصل من آخر عنصر لجمالية أكثر
                  _buildDetailItem(
                    title: "الملاحظة",
                    value: note,
                    icon: Icon(Icons.note, color: MyColor.primaryBlue),
                    isLast: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --- الأزرار ---
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    label: "رفض",
                    color: Colors.blue, // حافظت على اللون كما طلبت
                    onPressed: () {
                      // كود الرفض
                    },
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildActionButton(
                    label: "موافقة",
                    color: Colors.blue, // حافظت على اللون كما طلبت
                    onPressed: () {
                      // كود الموافقة
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- ويدجت التفاصيل المحسنة ---
  Widget _buildDetailItem({
    required String title,
    required String value,
    Icon? icon,
    Widget? widget,
    bool isLast = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        // العنوان
        Text(
          title,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),

        // القيمة والأيقونة
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null) ...[
              icon,
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),

        // زر إضافي (مثل الخريطة)
        if (widget != null) ...[
          const SizedBox(height: 5),
          Align(alignment: Alignment.centerLeft, child: widget),
        ],

        const SizedBox(height: 10),

        // الخط الفاصل
        if (!isLast)
          Divider(
            color: MyColor.primaryBlue.withOpacity(0.3),
            thickness: 1,
          ),
      ],
    );
  }

  // --- ويدجت الزر الموحد ---
  Widget _buildActionButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        elevation: 5,
        shadowColor: Colors.black.withOpacity(0.3),
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}