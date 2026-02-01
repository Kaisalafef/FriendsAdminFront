import 'package:flutter/material.dart';
import 'package:friends_admin/constence/MyColor.dart';
import 'package:get/get.dart';
import 'package:friends_admin/View/pages/HomeScreen.dart';

class RequestDetailsScreen extends StatelessWidget {
  final String userName;
  final String description;
  final String location;

  const RequestDetailsScreen({super.key, required this.userName, required this.description, required this.location});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text("تفاصيل طلب $userName", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: MyColor.primaryBlue,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: TweenAnimationBuilder(
          duration: const Duration(milliseconds: 600),
          tween: Tween<double>(begin: 0, end: 1),
          builder: (context, double value, child) {
            return Opacity(opacity: value, child: child);
          },
          child: Column(
            children: [
              _buildModernCard([
                _detailRow("اسم العميل", userName, Icons.person),
                _detailRow("الموقع", location, Icons.location_on,
                    extraWidget: TextButton.icon(
                      onPressed: () => Get.to(const HomeScreen()),
                      icon: const Icon(Icons.map, size: 18),
                      label: const Text("فتح الخريطة"),
                    )
                ),
                _detailRow("وصف الطلب", description, Icons.description),
              ]),
              const SizedBox(height: 20),
              _buildModernCard([
                const Text("الصورة المرفقة", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey[100],
                    child: Icon(Icons.image, size: 50, color: Colors.grey[400]),
                  ),
                ),
              ]),
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(child: _actionBtn("رفض", Colors.grey[200]!, Colors.black, () {})),
                  const SizedBox(width: 15),
                  Expanded(child: _actionBtn("موافقة", MyColor.primaryBlue, Colors.white, () {})),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10))],
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  Widget _detailRow(String title, String val, IconData icon, {Widget? extraWidget}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.grey[500], fontSize: 13)),
          const SizedBox(height: 5),
          Row(
            children: [
              Icon(icon, color: MyColor.primaryBlue, size: 20),
              const SizedBox(width: 10),
              Expanded(child: Text(val, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
            ],
          ),
          if (extraWidget != null) extraWidget,
        ],
      ),
    );
  }

  Widget _actionBtn(String label, Color bg, Color txt, VoidCallback tap) {
    return SizedBox(
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: bg, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
        onPressed: tap,
        child: Text(label, style: TextStyle(color: txt, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }
}