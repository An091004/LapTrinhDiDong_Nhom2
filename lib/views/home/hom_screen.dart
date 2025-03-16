import 'package:flutter/material.dart';
class HomScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: Colors.green,
        title: Column(
          children: [
            Text("Thống kê", style: TextStyle(color: Colors.white)),
            Text("Nhóm2", style: TextStyle(color: Colors.white, fontSize: 14)),
          ],
        ),
        actions: [
          IconButton(icon: Icon(Icons.send, color: Colors.white), onPressed: () {}),
        ],
        
      ),
      drawer: Drawer(

        width: MediaQuery.of(context).size.width * 0.6, // 60% chiều rộng màn hình
        backgroundColor: Color(0xFF6D9937), 
        child: Column(
          children: [
            DrawerHeader(              
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Nhóm của bạn (1)",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text("N2", style: TextStyle(color: Colors.white)),
              ),
              title: Text("Nhóm 2"),
              subtitle: Text("1 thành viên\n0 đ"),
              trailing: Icon(Icons.settings),
              onTap: () {
                // Điều hướng hoặc hiển thị thông tin nhóm
              },
            ),
            ListTile(
              title: Text("Tạo nhóm mới"),
              onTap: () {
                // Chuyển đến trang tạo nhóm
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Phần chọn tháng
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: () {}),
                Text("Tháng này", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                IconButton(icon: Icon(Icons.arrow_forward_ios), onPressed: () {}),
              ],
            ),
          ),

          // Thống kê thu / chi
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text("- 0", style: TextStyle(color: Colors.red, fontSize: 24)),
                    Text("0 giao dịch"),
                    Text("Chi", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  children: [
                    Text("+ 0", style: TextStyle(color: Colors.green, fontSize: 24)),
                    Text("0 giao dịch"),
                    Text("Thu", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),

          // Hiển thị khi không có dữ liệu
          Expanded(
            child: Center(
              child: Text("Không có dữ liệu", style: TextStyle(color: Colors.grey, fontSize: 16)),
            ),
          ),
        ],
      ),

      // Thanh navigation
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.wallet), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle, size: 40, color: Colors.green), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: ""),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
