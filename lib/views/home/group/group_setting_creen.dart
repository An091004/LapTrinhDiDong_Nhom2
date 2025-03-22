import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  final String groupName;

  const SettingScreen({super.key, required this.groupName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cài đặt nhóm",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.grey[200]!],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade400,
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[300],
                        child: Icon(Icons.group, size: 50, color: Colors.grey),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        groupName, // Hiển thị tên nhóm được truyền vào
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(width: 5),
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            // Các cài đặt
            Expanded(
              child: ListView(
                children: [
                  SettingOption(
                    icon: Icons.people,
                    title: "Xem thành viên",
                    onTap: () {},
                  ),
                  SettingOption(
                    icon: Icons.person_add,
                    title: "Thêm thành viên",
                    onTap: () {},
                  ),
                  SettingOption(
                    icon: Icons.security,
                    title: "Quản lý quyền thành viên",
                    onTap: () {},
                  ),
                  SettingOption(
                    icon: Icons.notifications,
                    title: "Cài đặt thông báo",
                    onTap: () {},
                  ),
                  SettingOption(
                    icon: Icons.exit_to_app,
                    title: "Rời nhóm",
                    color: Colors.red,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: Text("Xác nhận"),
                              content: Text(
                                "Bạn có chắc chắn muốn rời khỏi nhóm không?",
                              ),
                              actions: [
                                TextButton(
                                  child: Text("Hủy"),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                TextButton(
                                  child: Text("Đồng ý"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey[100],
    );
  }
}

class SettingOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const SettingOption({
    super.key,
    required this.icon,
    required this.title,
    this.color = Colors.black87,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      onTap: onTap,
    );
  }
}
