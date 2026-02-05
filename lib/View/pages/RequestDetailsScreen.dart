import 'package:flutter/material.dart';
import 'package:friends_admin/constence/MyColor.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class RequestDetailsScreen extends StatelessWidget {
  final String userName;
  final String description;
  final String location;
  final String phone;
  final List<String> images;

  const RequestDetailsScreen({
    super.key, 
    required this.userName, 
    required this.description, 
    required this.location, 
    required this.phone, 
    required this.images
  });

  @override
  Widget build(BuildContext context) {
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
            
            // وصف المشكلة
            _buildSectionTitle("وصف المشكلة"),
            _buildModernCard([
              Text(description, style: const TextStyle(fontSize: 15, height: 1.5)),
            ]),

            const SizedBox(height: 20),

            // معرض الصور
            if (images.isNotEmpty) ...[
              _buildSectionTitle("الصور المرفقة"),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => Get.dialog(Dialog(child: Image.network(images[index]))),
                      child: Container(
                        margin: const EdgeInsets.only(left: 10),
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: NetworkImage(images[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
            
            const SizedBox(height: 30),
            
            // أزرار التحكم
            Row(
              children: [
                Expanded(child: _actionBtn("قبول الطلب", Colors.green, Colors.white, () {})),
                const SizedBox(width: 10),
                Expanded(child: _actionBtn("رفض", Colors.redAccent, Colors.white, () {})),
              ],
            )
          ],
        ),
      ),
    );
  }

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
}