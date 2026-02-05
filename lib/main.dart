import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'View/pages/SplashPage.dart'; // استدعاء صفحة السبلاش الجديدة

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
      // التغيير هنا: البداية من SplashPage لفحص التوكن
      home: const SplashPage(),
    );
  }
}