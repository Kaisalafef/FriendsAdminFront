import 'package:flutter/material.dart';
import '../../constence/MyColor.dart';
import 'notificationScreen.dart';
import 'ratingscreen.dart';
import 'SettingScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _selectedIndex = 0;

  // قائمة تحتوي على الصفحات بالترتيب
  final List<Widget> _pages = [
    const NotificationScreen(), // Index 0
   // const RatingScreen(),        // Index 1
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
          // هنا نقوم بتعديل الثيم الخاص بالبار فقط للتحكم في الوميض
          data: Theme.of(context).copyWith(
            splashFactory:NoSplash.splashFactory, //منع الوميض عند الضغط
            ),
          child: BottomNavigationBar(
            backgroundColor: MyColor.primaryBlue,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            unselectedItemColor: MyColor.secondaryGrey,
            selectedItemColor: Colors.white,

            iconSize: 25,
            selectedIconTheme: const IconThemeData(size: 35),

            unselectedFontSize: 14,

            showSelectedLabels: false,
            showUnselectedLabels: true,

            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Icon(Icons.notifications),
                ),
                label: 'إشعارات',
              ),
             /* BottomNavigationBarItem(
                icon: Icon(Icons.star),
                label: 'تقييم',
              ),*/
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'إعدادات',
              ),
            ],
          ),
        ),
      ),
    );
  }}