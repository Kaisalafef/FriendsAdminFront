import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constence/MyColor.dart';
import '../pages/RequestDetailsScreen.dart';
import 'package:friends_admin/View/widget/directRequestDetailsPage.dart';

Widget NotificationItem(BuildContext context, String name, String desc, String location, String type, String phone, String profession, {required List<String> images}) {
  bool isDirect = type == 'direct_request';
  Color sideColor = isDirect ? Colors.green : Colors.orange;

  return GestureDetector(
    onTap: () {
      if (isDirect) {
        Get.to(() => DirectRequestDetailsPage(userName: name, location: location, phone: phone, note: desc, profession: profession));
      } else {
        Get.to(() => RequestDetailsScreen(
          userName: name, 
          description: desc, 
          location: location, 
          phone: phone, 
          images: images ,
          // تمرير الصور المجهزة بالروابط الكاملة
        ));
      }
    },
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10)],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 8,
              decoration: BoxDecoration(color: sideColor, borderRadius: const BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20))),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 5),
                    Text(desc, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: MyColor.primaryBlue),
                        const SizedBox(width: 5),
                        Expanded(child: Text(location, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey).paddingOnly(left: 15),
          ],
        ),
      ),
    ),
  );
}