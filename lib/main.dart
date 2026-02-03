import 'package:flutter/material.dart';
import 'package:friends_admin/View/pages/AddAdPage.dart';
import 'package:friends_admin/View/pages/LoginPage.dart';
import 'package:get/get_navigation/get_navigation.dart';

import 'View/pages/HomeScreen.dart';



void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      locale: const Locale('ar'),
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
