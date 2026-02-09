import 'package:flutter/material.dart';
import 'package:friends_admin/constence/MyColor.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Controller/NotificationController.dart';

class DirectRequestDetailsPage extends StatelessWidget {
  final int requestId; // <--- معرف الخدمة
  final int userId;
  final String userName;
  final String location;
  final String phone;
  final String note;
  final String profession;
  final String currentStatus; // <--- الحالة

  DirectRequestDetailsPage({
    super.key,
    required this.requestId,
    required this.userId,
    required this.userName,
    required this.location,
    required this.phone,
    required this.note,
    required this.profession,
    required this.currentStatus,
  });

  final NotificationController controller = Get.find<NotificationController>();
  final TextEditingController noteController = TextEditingController();

  Future<void> openMap(String location) async {
    final String googleMapsUrl = "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(location)}";
    final Uri url = Uri.parse(googleMapsUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> makeCall(String phoneNumber) async {
    final Uri url = Uri.parse("tel:$phoneNumber");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isPending = currentStatus == 'pending';

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text("تفاصيل طلب $userName", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
            // شريط الحالة
            if (!isPending)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: currentStatus == 'accepted' ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: currentStatus == 'accepted' ? Colors.green : Colors.red),
                ),
                child: Text(
                  currentStatus == 'accepted' ? "الطلب مقبول" : "الطلب مرفوض",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: currentStatus == 'accepted' ? Colors.green : Colors.red, fontWeight: FontWeight.bold),
                ),
              ),

            // البطاقة
            _buildModernCard([
              _detailRow("الفني", profession, Icons.work),
              _detailRow("اسم العميل", userName, Icons.person),
              _detailRow("رقم الهاتف", phone, Icons.phone,
                extraWidget: TextButton.icon(
                  onPressed: () => makeCall(phone),
                  icon: const Icon(Icons.call, color: Colors.green, size: 18),
                  label: const Text("اتصال الآن", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                ),
              ),
              _detailRow("الموقع", location, Icons.location_on,
                extraWidget: TextButton.icon(
                  onPressed: () => openMap(location),
                  icon: Icon(Icons.map, color: MyColor.primaryBlue, size: 18),
                  label: const Text("عرض الخريطة"),
                ),
              ),
            ]),

            const SizedBox(height: 20),

            _buildSectionTitle("وصف المشكلة"),
            _buildModernCard([
              Text(
                  note.isEmpty ? "لا توجد ملاحظات إضافية" : note,
                  style: const TextStyle(fontSize: 15, height: 1.5, color: Colors.black87)
              ),
            ]),

            const SizedBox(height: 30),

            // الأزرار
            if (isPending)
              Row(
                children: [
                  Expanded(child: _actionBtn("قبول الطلب", Colors.green, Colors.white, () {
                    _showActionDialog(context, isAccept: true);
                  })),
                  const SizedBox(width: 10),
                  Expanded(child: _actionBtn("رفض", Colors.redAccent, Colors.white, () {
                    _showActionDialog(context, isAccept: false);
                  })),
                ],
              )
          ],
        ),
      ),
    );
  }

  void _showActionDialog(BuildContext context, {required bool isAccept}) {
    noteController.clear();
    String title = isAccept ? "قبول الطلب" : "رفض الطلب";
    String hint = isAccept ? "حدد موعد وصول العمال" : "سبب الرفض";

    Get.defaultDialog(
      title: title,
      titleStyle: TextStyle(color: isAccept ? Colors.green : Colors.red, fontWeight: FontWeight.bold),
      content: Column(
        children: [
          Text(isAccept
              ? "سيتم تغيير الحالة وإبلاغ العميل."
              : "سيتم رفض الطلب وإبلاغ العميل.", textAlign: TextAlign.center),
          const SizedBox(height: 15),
          TextField(
            controller: noteController,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              filled: true,
              fillColor: Colors.grey[100],
            ),
            maxLines: 3,
          ),
        ],
      ),
      textConfirm: "تأكيد",
      textCancel: "إلغاء",
      confirmTextColor: Colors.white,
      buttonColor: isAccept ? Colors.green : Colors.red,
      // في دالة _showActionDialog داخل ملف RequestDetailsScreen.dart

onConfirm: () async {
  if (noteController.text.isEmpty) {
    Get.snackbar("تنبيه", "الرجاء كتابة ملاحظة للعميل", backgroundColor: Colors.orange);
    return;
  }

  Get.back(); // إغلاق الـ Dialog
  Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false); // إظهار التحميل

  // --- التعديل هنا ---
  
  // نقوم بتجهيز نص الرسالة الكامل
  String fullMessage = isAccept
      ? "تم قبول الطلب. موعد الوصول: ${noteController.text}"
      : "عذراً، تم رفض الطلب. السبب: ${noteController.text}";

  // نستدعي دالة التحديث فقط (وهي ستقوم بالحفظ في الداتابيز عبر الباك إند)
  bool success = await controller.updateRequestStatus(
      requestId, 
      isAccept ? 'accepted' : 'rejected',
      note: fullMessage // نرسل النص هنا
  );

  Get.back(); // إغلاق التحميل

  if (success) {
    Get.back(); // العودة للشاشة الرئيسية
    Get.snackbar("تم", "تم تحديث الحالة وإشعار العميل بنجاح", backgroundColor: Colors.green, colorText: Colors.white);
  } else {
    // البقاء في الصفحة في حال الفشل
  }
},
    );
  }

  // ... (نفس الدوال المساعدة للواجهة _buildSectionTitle, _buildModernCard, _detailRow, _actionBtn)
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Text(title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: MyColor.primaryBlue)),
    );
  }

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