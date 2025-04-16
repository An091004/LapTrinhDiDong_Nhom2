import 'package:flutter/material.dart';
import 'group_model.dart';
import 'group_detail_screen.dart';
import 'add_group_screen.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key});

  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  bool isSearching = false;
  String searchQuery = "";

  final List<GroupModel> groups = [
    GroupModel(id: "1", name: "Gia đình", members: 3),
    GroupModel(id: "2", name: "Bạn lầy lầy", members: 5),
    GroupModel(id: "3", name: "Đồng nghiệp", members: 4),
  ];

  final List<String> allUsers = [
    "Nguyễn Văn A",
    "Trần Thị B",
    "Lê Văn C",
    "Phạm Thị D",
    "Hoàng Văn E",
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 4,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title:
            isSearching
                ? TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value.toLowerCase();
                    });
                  },
                  autofocus: true,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Tìm nhóm...',
                    hintStyle: TextStyle(color: Colors.white60),
                    border: InputBorder.none,
                  ),
                )
                : Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage("assets/images/user.jpg"),
                      radius: 22,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Nhóm của tôi",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
        actions: [
          IconButton(
            icon: Icon(
              isSearching ? Icons.close : Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                searchQuery = ""; // Reset tìm kiếm khi tắt
              });
            },
          ),
        ],
      ),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.65,
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.lightBlue),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: const Text(
                  'Menu Điều Hướng',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            _buildDrawerItem(
              context,
              Icons.settings,
              'Cài đặt',
              () => Navigator.pop(context),
            ),
            _buildDrawerItem(
              context,
              Icons.exit_to_app,
              'Đăng xuất',
              () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: ListView.builder(
          itemCount: groups.length,
          itemBuilder: (context, index) {
            final group = groups[index];

            // Lọc nhóm theo từ khóa tìm kiếm
            if (searchQuery.isNotEmpty &&
                !group.name.toLowerCase().contains(searchQuery)) {
              return SizedBox.shrink(); // Ẩn nếu không khớp tìm kiếm
            }

            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
              elevation: 5,
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                leading: CircleAvatar(
                  backgroundColor: Colors.blueAccent.shade100,
                  radius: 25,
                  child: Text(
                    group.name.substring(0, 2),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                title: Text(
                  group.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: Row(
                  children: [
                    Icon(Icons.people, size: 18, color: Colors.blueGrey),
                    SizedBox(width: 5),
                    Text("${group.members} thành viên"),
                    Spacer(),
                  ],
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey.shade600,
                  size: 18,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GroupDetailScreen(group: group),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => AddGroupScreen(
                    refreshUI: setState,
                    groups: groups,
                    allUsers: allUsers,
                  ),
            ),
          );
        },
        backgroundColor: Colors.teal,
        elevation: 8,
        child: Icon(Icons.add, size: 30, color: Colors.white),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.black54),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      onTap: onTap,
    );
  }
}
