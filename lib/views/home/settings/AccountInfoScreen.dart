import 'package:flutter/material.dart';
import 'package:flutter_qlchitieu/api/api_service.dart';
import 'package:flutter_qlchitieu/models/update_user_request.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountInfoScreen extends StatefulWidget {
  const AccountInfoScreen({super.key});

  @override
  _AccountInfoScreenState createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
  bool _isObscureOld = true;
  bool _isObscureNew = true;
  String userName = '';
  String userEmail = '';
  String userPhone = '';
  final ApiService _apiService = ApiService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      if (token != null) {
        final user = await _apiService.getCurrenUser(token);
        setState(() {
          userName = user.tenDangNhap;
          userEmail = user.email;
          userPhone = user.soDienThoai;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('Lỗi lấy thông tin người dùng: $e');
      setState(() => _isLoading = false);
    }
  }

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
                  SizedBox(height: 12),
                  _buildPasswordField(
                    "Xác nhận mật khẩu mới",
                    _isObscureNew,
                    () {
                      setDialogState(() => _isObscureNew = !_isObscureNew);
                    },
                  ),
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

  void _showEditDialog(
    String title,
    String currentValue,
    Function(String) onSave,
  ) {
    TextEditingController controller = TextEditingController(
      text: currentValue,
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Chỉnh sửa $title"),
            content: TextField(
              controller: controller,
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Hủy"),
              ),
              TextButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  final token = prefs.getString('token');

                  if (token == null) {
                    _showSnackBar("Không tìm thấy token", Colors.red);
                    return;
                  }

                  setState(() {
                    onSave(controller.text);
                  });

                  Navigator.pop(context);

                  final requestBody = UpdateUserRequest(
                    tenDangNhap: title == "Tên" ? controller.text : userName,
                    email: title == "Email" ? controller.text : userEmail,
                    soDienThoai:
                        title == "Số điện thoại" ? controller.text : userPhone,
                  );

                  try {
                    final response = await _apiService.updateUserInfo(
                      requestBody,
                      token,
                    );
                    if (response.success) {
                      _showSnackBar("Cập nhật thành công", Colors.green);
                      _loadUserInfo();
                    } else {
                      _showSnackBar(
                        response.message ?? "Cập nhật thất bại",
                        Colors.red,
                      );
                    }
                  } catch (e) {
                    _showSnackBar("Lỗi khi cập nhật: $e", Colors.red);
                  }
                },
                child: Text("Lưu"),
              ),
            ],
          ),
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
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
      trailing: Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
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
          userName,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text(userEmail, style: TextStyle(color: Colors.grey[600])),
      ],
    );
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
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildProfileHeader(),
                    SizedBox(height: 24),
                    _buildAccountItem(Icons.person, userName, () {
                      _showEditDialog("Tên", userName, (newValue) {
                        setState(() => userName = newValue);
                      });
                    }),
                    _buildAccountItem(Icons.email, userEmail, () {
                      _showEditDialog("Email", userEmail, (newValue) {
                        setState(() => userEmail = newValue);
                      });
                    }),
                    _buildAccountItem(Icons.phone, userPhone, () {
                      _showEditDialog("Số điện thoại", userPhone, (newValue) {
                        setState(() => userPhone = newValue);
                      });
                    }),
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
}
