import 'package:flutter/material.dart';

class AccountInfoScreen extends StatefulWidget {
  const AccountInfoScreen({super.key});

  @override
  _AccountInfoScreenState createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
  bool _isObscureOld = true;
  bool _isObscureNew = true;

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (BuildContext context) {
        return Wrap(
          children: [
            _buildPickerOption(Icons.camera_alt, "Chụp ảnh", () {
              Navigator.pop(context);
            }),
            _buildPickerOption(Icons.photo_library, "Chọn ảnh từ thư viện", () {
              Navigator.pop(context);
            }),
            Divider(),
            _buildPickerOption(Icons.cancel, "Hủy", () {
              Navigator.pop(context);
            }),
          ],
        );
      },
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                "Đổi mật khẩu",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildPasswordField("Mật khẩu cũ", _isObscureOld, () {
                    setDialogState(() => _isObscureOld = !_isObscureOld);
                  }),
                  SizedBox(height: 12),
                  _buildPasswordField("Mật khẩu mới", _isObscureNew, () {
                    setDialogState(() => _isObscureNew = !_isObscureNew);
                  }),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Hủy", style: TextStyle(color: Colors.grey[700])),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _showSnackBar(
                      "Mật khẩu đã được đổi thành công!",
                      Colors.green,
                    );
                  },
                  child: Text("Xác nhận"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thông tin cá nhân"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildProfileHeader(),
            SizedBox(height: 24),
            _buildAccountItem(Icons.person, "Nhật"),
            _buildAccountItem(Icons.email, "Cập nhật email..."),
            _buildAccountItem(Icons.phone, "08787829"),
            _buildAccountItem(
              Icons.lock,
              "Đổi mật khẩu",
              _showChangePasswordDialog,
            ),
            Spacer(),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text("Xóa tài khoản"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.person, size: 50, color: Colors.grey[700]),
            ),
            GestureDetector(
              onTap: _showImagePicker,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                child: Icon(Icons.edit, size: 18, color: Colors.blueAccent),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          "Nhật Nguyễn",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text("nhat@example.com", style: TextStyle(color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildPasswordField(
    String hintText,
    bool isObscure,
    VoidCallback toggleObscure,
  ) {
    return TextField(
      obscureText: isObscure,
      decoration: InputDecoration(
        labelText: hintText,
        border: OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility),
          onPressed: toggleObscure,
        ),
      ),
    );
  }

  Widget _buildAccountItem(IconData icon, String text, [VoidCallback? onTap]) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(text, style: TextStyle(fontSize: 16)),
      trailing: onTap != null ? Icon(Icons.arrow_forward_ios, size: 16) : null,
      onTap: onTap,
    );
  }

  Widget _buildPickerOption(IconData icon, String text, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(
        text,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
    );
  }
}
