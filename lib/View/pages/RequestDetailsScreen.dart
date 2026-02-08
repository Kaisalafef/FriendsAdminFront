import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:friends_admin/Controller/NotificationController.dart';
import 'package:friends_admin/constence/MyColor.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';

class RequestDetailsScreen extends StatelessWidget {
  final int requestId; // معرف الخدمة للتحديث
  final int userId;
  final String userName;
  final String description;
  final String location;
  final String phone;
  final List<String> images;
  final String currentStatus;

  RequestDetailsScreen({
    super.key,
    required this.requestId,
    required this.userId,
    required this.userName,
    required this.description,
    required this.location,
    required this.phone,
    required this.images,
    required this.currentStatus,
  });

  final NotificationController controller = Get.find<NotificationController>();
  final TextEditingController noteController = TextEditingController();

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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // حالة الطلب
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
                  currentStatus == 'accepted' ? "هذا الطلب مقبول مسبقاً" : "هذا الطلب مرفوض",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: currentStatus == 'accepted' ? Colors.green : Colors.red, fontWeight: FontWeight.bold),
                ),
              ),

            // بطاقة المعلومات الأساسية
            _buildModernCard([
              _detailRow("اسم العميل", userName, Icons.person),
              _detailRow("رقم الهاتف", phone, Icons.phone,
                  extraWidget: TextButton.icon(
                    onPressed: () => launchUrl(Uri.parse("tel:$phone")),
                    icon: const Icon(Icons.call, color: Colors.green),
                    label: const Text("اتصال الآن"),
                  )
              ),
              _detailRow("الموقع", location, Icons.location_on,
                  extraWidget: TextButton.icon(
                    onPressed: () async {
                      final url = Uri.parse("https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(location)}");
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url, mode: LaunchMode.externalApplication);
                      }
                    },
                    label: const Text("عرض على الخريطة"),
                    icon: const Icon(Icons.map, size: 18),
                  )),
            ]),

            const SizedBox(height: 20),

            _buildSectionTitle("وصف المشكلة"),
            _buildModernCard([
              Text(description, style: const TextStyle(fontSize: 15, height: 1.5)),
            ]),

            const SizedBox(height: 20),

            if (images.isNotEmpty) ...[
              _buildSectionTitle("الصور المرفقة"),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(left: 10),
                      width: 150,
                      child: Stack(
                        children: [
                          GestureDetector(
                            onTap: () => Get.dialog(Dialog(child: Image.network(images[index]))),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image: NetworkImage(images[index]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 5,
                            right: 5,
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.black.withOpacity(0.5),
                              child: IconButton(
                                icon: const Icon(Icons.download, size: 18, color: Colors.white),
                                onPressed: () => _downloadImage(images[index]),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],

            const SizedBox(height: 30),

            // إخفاء الأزرار إذا لم يكن pending
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
              ? "سيتم تغيير الحالة إلى مقبول وإشعار العميل."
              : "سيتم تغيير الحالة إلى مرفوض وإشعار العميل.", textAlign: TextAlign.center),
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
      onConfirm: () async {
        if (noteController.text.isEmpty) {
          Get.snackbar("تنبيه", "الرجاء كتابة ملاحظة للعميل", backgroundColor: Colors.orange);
          return;
        }

        Get.back(); // إغلاق الـ Dialog
        Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false); // تحميل

        // 1. تحديث الحالة في الداتابيز
        bool success = await controller.updateRequestStatus(requestId, isAccept ? 'accepted' : 'rejected');

        if (success) {
          // 2. إرسال الإشعار بالتفاصيل الخاصة (الوقت أو السبب)
          await controller.sendNotification(
            userId: userId,
            title: isAccept ? "تم قبول طلبك ✅" : "تم رفض الطلب ❌",
            message: isAccept
                ? "تم قبول الطلب. موعد الوصول: ${noteController.text}"
                : "عذراً، تم رفض الطلب. السبب: ${noteController.text}",
          );

          Get.back(); // إغلاق التحميل
          Get.back(); // العودة للشاشة الرئيسية
          Get.snackbar("تم", "تم تحديث الحالة وإرسال الإشعار", backgroundColor: Colors.green, colorText: Colors.white);
        } else {
          Get.back(); // إغلاق التحميل فقط
        }
      },
    );
  }

  // ... (بقية دوال _buildModernCard, _detailRow, _actionBtn, _downloadImage كما هي)
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(title, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: MyColor.primaryBlue)),
    );
  }

  Widget _buildModernCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
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
          Row(
            children: [
              Icon(icon, color: MyColor.primaryBlue, size: 18),
              const SizedBox(width: 10),
              Expanded(child: Text(val, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
              if (extraWidget != null) extraWidget,
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionBtn(String label, Color bg, Color txt, VoidCallback tap) {
    return ElevatedButton(
      onPressed: tap,
      style: ElevatedButton.styleFrom(backgroundColor: bg, padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
      child: Text(label, style: TextStyle(color: txt, fontWeight: FontWeight.bold)),
    );
  }

  Future<void> _downloadImage(String imageUrl) async {
    // ... (نفس الكود السابق)
    try {
      Get.snackbar("جاري التحميل", "يتم الآن حفظ الصورة...");
      var response = await Dio().get(imageUrl, options: Options(responseType: ResponseType.bytes));
      final result = await ImageGallerySaverPlus.saveImage(Uint8List.fromList(response.data));
      if (result['isSuccess']) {
        Get.snackbar("تم الحفظ", "تم حفظ الصورة في الاستوديو", backgroundColor: Colors.green);
      }
    } catch (e) {
      Get.snackbar("خطأ", "فشل التحميل: $e", backgroundColor: Colors.red);
    }
  }
}