import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'group_model.dart';

class AddGroupScreen extends StatefulWidget {
  final Function refreshUI;
  final List<GroupModel> groups;
  final List<String> allUsers;

  const AddGroupScreen({
    required this.refreshUI,
    required this.groups,
    required this.allUsers,
    Key? key,
  }) : super(key: key);

  @override
  _AddGroupScreenState createState() => _AddGroupScreenState();
}

class _AddGroupScreenState extends State<AddGroupScreen> {
  String groupName = "";
  List<String> selectedUsers = [];
  File? groupImage;
  final TextEditingController searchController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        groupImage = File(pickedFile.path);
      });
    }
  }

  void _saveGroup() {
    if (groupName.isNotEmpty && selectedUsers.isNotEmpty) {
      widget.refreshUI(() {
        widget.groups.add(
          GroupModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: groupName,
            members: selectedUsers.length + 1,
          ),
        );
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          "Tạo Nhóm Mới",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.check, size: 28, color: Colors.white),
            onPressed: _saveGroup,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage:
                        groupImage != null ? FileImage(groupImage!) : null,
                    child:
                        groupImage == null
                            ? Icon(
                              Icons.camera_alt,
                              size: 40,
                              color: Colors.grey[700],
                            )
                            : null,
                  ),
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.edit, size: 18, color: Colors.indigo),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: "Tên nhóm",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: Icon(Icons.group, color: Colors.indigo),
              ),
              onChanged: (value) {
                setState(() {
                  groupName = value;
                });
              },
            ),
            SizedBox(height: 16),
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "Tìm email hoặc số điện thoại",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: Icon(Icons.search, color: Colors.indigo),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
            SizedBox(height: 10),
            ...widget.allUsers
                .where(
                  (user) => user.toLowerCase().contains(
                    searchController.text.toLowerCase(),
                  ),
                )
                .map(
                  (user) => ListTile(
                    title: Text(user),
                    trailing:
                        selectedUsers.contains(user)
                            ? Icon(Icons.check_circle, color: Colors.indigo)
                            : Icon(
                              Icons.add_circle_outline,
                              color: Colors.grey,
                            ),
                    onTap: () {
                      setState(() {
                        if (selectedUsers.contains(user)) {
                          selectedUsers.remove(user);
                        } else {
                          selectedUsers.add(user);
                        }
                      });
                    },
                  ),
                ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveGroup,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Tạo nhóm",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
