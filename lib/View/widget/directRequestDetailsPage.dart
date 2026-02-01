import 'package:flutter/material.dart';
import 'package:friends_admin/View/pages/HomeScreen.dart';
import 'package:friends_admin/constence/MyColor.dart';
import 'package:get/get.dart';

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
      backgroundColor: Colors.grey[50],
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
            // --- البطاقة ---
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailItem(
                      title: "اسم العميل",
                      value: userName,
                      icon: Icon(Icons.person, color: MyColor.primaryBlue),
                    ),
                    _buildDetailItem(
                      title: "الموقع",
                      value: location,
                      icon: Icon(Icons.location_on, color: MyColor.primaryBlue),
                      widget: Container(
                        margin: const EdgeInsets.only(top: 8),
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () {
                            Get.to(HomeScreen());
                          },
                          label: const Text(
                            "فتح الخريطة",
                            style: TextStyle(fontSize: 14,/* fontWeight: FontWeight.bold*/),
                          ),
                          icon: Icon(Icons.map, /*color: MyColor.primaryBlue,*/ size: 18),
                          style: TextButton.styleFrom(
                           /* foregroundColor: MyColor.primaryBlue,*/
                           // backgroundColor: MyColor.primaryBlue.withOpacity(0.1),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                      ),
                    ),
                    _buildDetailItem(
                      title: "رقم الهاتف",
                      value: phone,
                      valueColor: Colors.black,
                      icon: Icon(Icons.phone, color: MyColor.primaryBlue),
                    ),
                    _buildDetailItem(
                      title: "الملاحظة",
                      value: note,
                      icon: Icon(Icons.note, color: MyColor.primaryBlue),
                      isLast: true,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // --- الأزرار ---
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    label: "رفض",
                    color: MyColor.secondaryGrey,
                    textColor: Colors.black, // <-- هنا جعلنا النص أسود
                    onPressed: () {
                      // كود الرفض
                    },
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildActionButton(
                    label: "موافقة",
                    color: MyColor.primaryBlue,
                    textColor: Colors.white, // <-- هنا جعلنا النص أبيض
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

  // --- ويدجت التفاصيل ---
  Widget _buildDetailItem({
    required String title,
    required String value,
    Icon? icon,
    Widget? widget,
    Color? valueColor,
    bool isLast = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: MyColor.textGrey,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null) ...[
              Icon(icon.icon, size: 20, color: icon.color),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: valueColor ?? Colors.black87,
                  fontWeight: FontWeight.bold,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
        if (widget != null) ...[
          widget,
        ],
        const SizedBox(height: 15),
      ],
    );
  }

  // --- ويدجت الزر (تم التعديل) ---
  Widget _buildActionButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
    Color textColor = Colors.white, // معامل اختياري للون النص بقيمة افتراضية بيضاء
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: textColor, // استخدام اللون الممرر هنا
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.2),
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}