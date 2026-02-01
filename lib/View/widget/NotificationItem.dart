import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constence/MyColor.dart';
import '../pages/RequestDetailsScreen.dart';
import 'directRequestDetailsPage.dart';

Widget NotificationItem(BuildContext context, String name, String desc, String location, String type, String phone) {
  bool isDirect = type == 'direct';
  Color sideColor = isDirect ? Colors.green : Colors.orange;

  return TweenAnimationBuilder(
    duration: const Duration(milliseconds: 500),
    tween: Tween<double>(begin: 0, end: 1),
    builder: (context, double value, child) {
      return Transform.scale(
        scale: value,
        child: child,
      );
    },
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 8,
              decoration: BoxDecoration(
                color: sideColor,
                borderRadius: const BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
              ),
            ),
            Expanded(
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Text(desc, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey[600])),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: MyColor.primaryBlue),
                        const SizedBox(width: 4),
                        Text(location, style: TextStyle(fontSize: 12, color: MyColor.textGrey)),
                      ],
                    ),
                    if (isDirect) ...[
                      const SizedBox(height: 5),
                      Text(phone, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                    ],
                  ],
                ),
                trailing: CircleAvatar(
                  backgroundColor: MyColor.primaryBlue.withOpacity(0.1),
                  child: Icon(Icons.arrow_forward_ios, size: 16, color: MyColor.primaryBlue),
                ),
                onTap: () {
                  if (isDirect) {
                    Get.to(DirectRequestDetailsPage(userName: name, location: location, phone: phone, note: desc));
                  } else {
                    Get.to(RequestDetailsScreen(userName: name, description: desc, location: location));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}