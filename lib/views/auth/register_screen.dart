import 'package:flutter/material.dart';
<<<<<<< HEAD

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6D9937),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png', // Thay bằng logo của bạn
                height: 80,
              ),
              SizedBox(height: 16),
              Text(
                'Zomo',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  minimumSize: Size(double.infinity, 48),
                ),
                child: Text(
                  'ĐĂNG NHẬP BẰNG SỐ ĐIỆN THOẠI',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 20),

              Text(
                'Đăng ký bằng email',
                style: TextStyle(color: Colors.white70),
              ),
              SizedBox(height: 10),

              // Ô nhập Họ tên
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.email, color: Colors.grey),
                  hintText: 'Email...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 10),

              // Ô nhập Email
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.lock, color: Colors.grey),
                  hintText: 'Mật Khẩu...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 10),

              
        
              SizedBox(height: 10),

              // Nút đăng ký
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  minimumSize: Size(double.infinity, 48),
                ),
                child: Text(
                  'ĐĂNG KÝ',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 10),

              // Quay lại màn hình đăng nhập
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Đã có tài khoản? - Đăng nhập',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Quên mật khẩu?',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
=======
import 'package:flutter_qlchitieu/api/api_service.dart';
import 'package:flutter_qlchitieu/models/user_model.dart';
import 'package:flutter_qlchitieu/views/auth/login_screen.dart';
import 'package:http/http.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final ApiService _apiService = ApiService();

  bool _isObscure = true;

  void _register() async {
    String username = _usernameController.text.trim();
    String email = _emailController.text.trim();
    String phone = _phoneController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (username.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showSnackBar('Vui lòng nhập đầy đủ thông tin!', Colors.red);
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _showSnackBar('Email không hợp lệ!', Colors.red);
      return;
    }

    if (!RegExp(r'^(0|\+84)\d{9}$').hasMatch(phone)) {
      _showSnackBar('Số điện thoại không hợp lệ!', Colors.red);
      return;
    }

    if (password != confirmPassword) {
      _showSnackBar('Mật khẩu xác nhận không khớp!', Colors.red);
      return;
    }
    final request = RegisterRequest(
      tenDangNhap: username,
      email: email,
      soDienThoai: phone,
      matKhau: password,
    );
    try {
      final response = await _apiService.register(request);
      if (response.message == "Đăng ký thành công") {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Đăng ký thành công!")));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message ?? 'Đăng ký thất bại!')),
        );
      }
    } catch (e) {
      String errorMessage;
      print('Error details: $e');
      if (e.toString().contains('400')) {
        errorMessage = 'Email hoặc tên đăng nhập đã tồn tại!';
      } else if (e.toString().contains('connection')) {
        errorMessage = 'Không thể kết nối đến máy chủ, vui lòng kiểm tra mạng!';
      } else {
        errorMessage = 'Đã có lỗi xảy ra: $e';
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildLogo(),
                SizedBox(height: 16),
                Text(
                  'ĐĂNG KÝ TÀI KHOẢN',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 20),
                _buildTextField(
                  _usernameController,
                  Icons.person,
                  'Nhập tài khoản...',
                ),
                SizedBox(height: 12),
                _buildTextField(
                  _emailController,
                  Icons.email,
                  'Nhập email...',
                  TextInputType.emailAddress,
                ),
                SizedBox(height: 12),
                _buildTextField(
                  _phoneController,
                  Icons.phone,
                  'Nhập số điện thoại...',
                  TextInputType.phone,
                ),
                SizedBox(height: 12),
                _buildPasswordField(_passwordController, 'Nhập mật khẩu...'),
                SizedBox(height: 12),
                _buildPasswordField(
                  _confirmPasswordController,
                  'Xác nhận mật khẩu...',
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'ĐĂNG KÝ',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Đã có tài khoản?",
                      style: TextStyle(color: Colors.black87),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Đăng nhập ngay',
                        style: TextStyle(color: Colors.blue[800]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
>>>>>>> main
          ),
        ),
      ),
    );
  }
<<<<<<< HEAD
=======

  Widget _buildLogo() {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/images/logo.png',
          height: 100,
          width: 100,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    IconData icon,
    String hintText, [
    TextInputType keyboardType = TextInputType.text,
  ]) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
        prefixIcon: Icon(icon, color: Colors.grey[700]),
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildPasswordField(
    TextEditingController controller,
    String hintText,
  ) {
    return TextField(
      controller: controller,
      obscureText: _isObscure,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
        prefixIcon: Icon(Icons.lock, color: Colors.grey[700]),
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        suffixIcon: IconButton(
          icon: Icon(
            _isObscure ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey[700],
          ),
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
        ),
      ),
    );
  }
>>>>>>> main
}
