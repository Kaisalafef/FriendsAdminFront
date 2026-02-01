import 'package:flutter/material.dart';
import '../../constence/MyColor.dart';

Widget BuildSettingsField({required String value, required IconData icon, required VoidCallback onEdit}) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: Colors.grey[200]!),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5)),
      ],
    ),
    child: Row(
      children: [
        CircleAvatar(backgroundColor: MyColor.primaryBlue.withOpacity(0.1), child: Icon(icon, color: MyColor.primaryBlue, size: 20)),
        const SizedBox(width: 15),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
        IconButton(onPressed: onEdit, icon: Icon(Icons.edit_note, color: MyColor.primaryBlue.withOpacity(0.5))),
      ],
    ),
  );
}