import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter_qlchitieu/views/settings/settings_creeen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
=======
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
>>>>>>> main

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: Builder(
  builder: (context) => IconButton(
    icon: Icon(Icons.menu, color: Colors.white),
    onPressed: () {
      Scaffold.of(context).openDrawer(); // Mở Drawer trực tiếp
    },
  ),
),
        title: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min, // Để tránh chiếm hết không gian
            children: [
              Text("Thống kê", style: TextStyle(color: Colors.white)),
              Text(
                "Nhóm2",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.send, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer( // Thêm menu drawer
      width: MediaQuery.of(context).size.width * 0.6, // 60% chiều rộng màn hình
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Trang chủ'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Cài đặt'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      
      body: Center(
        child: Text("Màn hình chính", style: TextStyle(fontSize: 18)),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 4) {
            // Khi nhấn vào Cài đặt, mở màn hình mới
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsScreen()),
            );
          }
          // trả về màn hình thống kê
          else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsScreen()),
            );
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.wallet), label: "Ví"),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "Thống kê",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 40, color: Colors.green),
            label: "",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "Nhóm"),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: "Cài đặt"),
        ],
=======
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
>>>>>>> main
      ),
    );
  }
}
