import 'package:flutter/material.dart';
import 'group/group_screen.dart';
import 'overview/overview_screen.dart';
import 'activity/activity_screen.dart';
import 'settings/settings_creeen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _activities = [
    {
      "groupName": "Nhóm Bạn Thân",
      "description": "Mua bánh sinh nhật",
      "amount": 150000,
      "date": "22/03/2025",
    },
    {
      "groupName": "Gia Đình",
      "description": "Ăn tối cuối tuần",
      "amount": 500000,
      "date": "21/03/2025",
    },
  ];

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      GroupScreen(),
      OverviewScreen(),
      ActivityScreen(activities: _activities),
      SettingsScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Hiển thị màn hình được chọn

      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "Nhóm"),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "Tổng quan",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "Hoạt động",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Cài đặt"),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
