import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'View/pages/SplashPage.dart';
import 'core/bindings/InitialBindings.dart';

void main() {
  // التأكد من تهيئة أدوات فلاتر قبل تشغيل التطبيق
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Friends Admin',
      locale: const Locale('ar'), // دعم اللغة العربية
      debugShowCheckedModeBanner: false,

      // الربط السحري: هنا نقوم بتعريف الـ Bindings الأساسية
      initialBinding: InitialBindings(),

      theme: ThemeData(
        fontFamily: 'Cairo', // إذا كنت تستخدم خطاً عربياً
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),

      home: const SplashPage(),
    );
  }
}