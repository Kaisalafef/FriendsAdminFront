import 'package:flutter/material.dart';
import 'package:friends_admin/constence/MyColor.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class DirectRequestDetailsPage extends StatelessWidget {
  final String userName;
  final String location;
  final String phone;
  final String note;
  final String profession;

  const DirectRequestDetailsPage({
    super.key,
    required this.userName,
    required this.location,
    required this.phone,
    required this.note,
    required this.profession,
  });

  // دالة فتح الخريطة
  Future<void> openMap(String location) async {
    final String googleMapsUrl = "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(location)}";
    final Uri url = Uri.parse(googleMapsUrl);

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar("خطأ", "لا يمكن فتح تطبيق الخرائط حالياً", 
        snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // دالة الاتصال الهاتفي
  Future<void> makeCall(String phoneNumber) async {
    final Uri url = Uri.parse("tel:$phoneNumber");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      Get.snackbar("خطأ", "لا يمكن إجراء المكالمة", 
        snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // خلفية فاتحة لإبراز البطاقات
      appBar: AppBar(
        title: Text("تفاصيل طلب $userName", 
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: MyColor.primaryBlue,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // بطاقة المعلومات الأساسية (نفس ستايل الملف الآخر)
            _buildModernCard([
              _detailRow("الفني", profession, Icons.work),
              _detailRow("اسم العميل", userName, Icons.person),
              
              _detailRow(
                "رقم الهاتف", 
                phone, 
                Icons.phone,
                extraWidget: TextButton.icon(
                  onPressed: () => makeCall(phone),
                  icon: const Icon(Icons.call, color: Colors.green, size: 18),
                  label: const Text("اتصال الآن", 
                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                ),
              ),

              _detailRow(
                "الموقع", 
                location, 
                Icons.location_on,
                extraWidget: TextButton.icon(
                  onPressed: () => openMap(location),
                  icon: Icon(Icons.map, color: MyColor.primaryBlue, size: 18),
                  label: const Text("عرض الخريطة"),
                ),
              ),
            ]),

            const SizedBox(height: 20),
            
            // قسم ملاحظات الطلب
            _buildSectionTitle("وصف المشكلة"),
            _buildModernCard([
              Text(
                note.isEmpty ? "لا توجد ملاحظات إضافية" : note, 
                style: const TextStyle(fontSize: 15, height: 1.5, color: Colors.black87)
              ),
            ]),

            const SizedBox(height: 30),
            
            // أزرار التحكم في الأسفل
            Row(
              children: [
                Expanded(child: _actionBtn("قبول الطلب", Colors.green, Colors.white, () {
                  Get.snackbar("تم", "تم قبول الطلب بنجاح");
                })),
                const SizedBox(width: 10),
                Expanded(child: _actionBtn("رفض", Colors.redAccent, Colors.white, () {
                  Get.back();
                })),
              ],
            )
          ],
        ),
      ),
    );
  }

  // ويدجت عنوان القسم
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Text(title, 
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: MyColor.primaryBlue)),
    );
  }

  // ويدجت البطاقة العصرية
  Widget _buildModernCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05), 
            blurRadius: 15, 
            offset: const Offset(0, 5)
          )
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  // ويدجت صف التفاصيل
  Widget _detailRow(String title, String val, IconData icon, {Widget? extraWidget}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(icon, color: MyColor.primaryBlue, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(val, 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black)),
              ),
              if (extraWidget != null) extraWidget,
            ],
          ),
          const Divider(height: 20, thickness: 0.5),
        ],
      ),
    );
  }

  // ويدجت الزر
  Widget _actionBtn(String label, Color bg, Color txt, VoidCallback tap) {
    return ElevatedButton(
      onPressed: tap,
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
      child: Text(label, style: TextStyle(color: txt, fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }
}