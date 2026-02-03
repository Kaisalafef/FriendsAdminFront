import 'package:flutter/material.dart';
import 'package:friends_admin/View/pages/Adpage.dart';
import '../../constence/MyColor.dart';
import 'notificationScreen.dart';
import 'SettingScreen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // 1. تحديث قائمة الصفحات لتشمل AdPage في المنتصف
  final List<Widget> _pages = [
    const NotificationScreen(), // Index 0
          AdPage(),          // Index 1 (الصفحة الجديدة)
    const SettingScreen(),      // Index 2
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            splashFactory: NoSplash.splashFactory,
          ),
          child: BottomNavigationBar(
            backgroundColor: MyColor.primaryBlue,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            unselectedItemColor: MyColor.secondaryGrey.withOpacity(0.7),
            selectedItemColor: Colors.white,
            iconSize: 25,
            selectedIconTheme: const IconThemeData(size: 32),
            unselectedFontSize: 12,
            selectedFontSize: 14,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed, // لضمان ثبات العناصر الثلاثة

            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications_none_outlined),
                activeIcon: Icon(Icons.notifications),
                label: 'إشعارات',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_photo_alternate_outlined), // أيقونة الإعلانات
                activeIcon: Icon(Icons.add_photo_alternate),
                label: 'إعلان',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                activeIcon: Icon(Icons.settings),
                label: 'إعدادات',
              ),
            ],
          ),
        ),
      ),
    );
  }
}