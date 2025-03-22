import 'package:flutter/material.dart';
import 'package:flutter_qlchitieu/views/settings/AccountInfoScreen.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cá nhân"),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.grid_view),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
          IconButton(icon: Icon(Icons.receipt_long), onPressed: () {}),
        ],
      ),
      drawer: Drawer(
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
      body: Column(
        children: [
          // Phần Avatar + Tên + Số điện thoại
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.green,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Colors.grey),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Nhat",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("05515151", style: TextStyle(color: Colors.white)),
                  ],
                ),
                Spacer(),
                Column(
                  children: [
                    Icon(Icons.eco, color: Colors.white),
                    Text("Free", style: TextStyle(color: Colors.white)),
                    Text(
                      "2/2 quỹ",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Danh sách mục cài đặt
          Expanded(
            child: ListView(
              children: [
                _buildMenuItem(
                  context,
                  icon: Icons.person,
                  text: "Thông tin tài khoản",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AccountInfoScreen()),
                    );
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.language,
                  text: "Ngôn ngữ",
                  onTap: () {},
                ),
                _buildToggleItem(),
              ],
            ),
          ),

          // Nút Đăng xuất
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50), // Nút rộng cả màn hình
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                // Xử lý đăng xuất tại đây
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Đăng xuất"),
                      content: Text("Bạn có chắc chắn muốn đăng xuất không?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("Hủy"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // Thêm logic đăng xuất tại đây
                          },
                          child: Text("Đăng xuất", style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text("Đăng xuất"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String text,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      trailing: trailing ?? Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildToggleItem() {
    return ListTile(
      leading: Icon(Icons.access_time, color: Colors.black54),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Nhắc nhập thu chi cuối ngày", style: TextStyle(fontSize: 16)),
          Text(
            "Nhắc nếu chưa nhập thu chi lúc 8:00 pm",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
      trailing: Switch(value: true, onChanged: (bool value) {}),
    );
  }
}
