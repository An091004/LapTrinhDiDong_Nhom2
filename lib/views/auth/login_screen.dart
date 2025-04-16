import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter_qlchitieu/views/auth/register_screen.dart';
import 'package:flutter_qlchitieu/views/home/hom_screen.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6D9937), // Màu nền xanh lá
      
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo
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

              // Nút đăng nhập bằng số điện thoại
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
                'Đăng nhập bằng email',
                style: TextStyle(color: Colors.white70),
              ),
              SizedBox(height: 10),

              // Ô nhập Email
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

              // Ô nhập Mật khẩu
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.lock, color: Colors.grey),
                  hintText: 'Mật khẩu...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 10),

              // Nút đăng nhập
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(),),);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  minimumSize: Size(double.infinity, 48),
                ),
                child: Text(
                  'ĐĂNG NHẬP',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 10),

              // Liên kết "Đăng ký" và "Quên mật khẩu"
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen(),),);
                },
                child: Text(
                  'Chưa có tài khoản? - Đăng ký mới',
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
import 'package:flutter_qlchitieu/models/user_model.dart';
import 'package:flutter_qlchitieu/views/auth/forgot_password_screen.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register_screen.dart';
import 'package:flutter_qlchitieu/views/home/hom_screen.dart';
import 'package:flutter_qlchitieu/api/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isObscure = true;

  void _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vui lòng nhập đầy đủ tài khoản và mật khẩu!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    final request = LoginRequest(email: email, matKhau: password);
    try {
      final response = await _apiService.login(request);
     
      if (response.token != null) {
        await _saveToken(response.token!);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Đăng nhập thành công!")));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message ?? 'Đăng nhập thất bại!')),
        );
      }
    } catch (e) {
      String errorMessage;
      print('Error details: $e'); // In lỗi chi tiết để debug
      if (e.toString().contains('401')) {
        errorMessage = 'Email hoặc mật khẩu không đúng!';
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

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height, // Đảm bảo full màn hình
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Container(
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
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'QUẢN LÍ CHI TIÊU',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28, // Giảm nhẹ font để tránh thô ráp
                    fontWeight: FontWeight.w600, // Dùng w600 để mềm mại hơn
                    color: Colors.black87,
                    letterSpacing: 1.2, // Tăng khoảng cách chữ một chút
                    fontFamily: 'Helvetica',
                    shadows: [
                      Shadow(
                        blurRadius: 6,
                        color: Colors.black26,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // Text(
                //   'Đăng nhập để tiếp tục',
                //   style: TextStyle(color: Colors.grey[800], fontSize: 18),
                // ),

                // Form nhập liệu
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.text,
                  style: TextStyle(color: Colors.black87),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    prefixIcon: Icon(Icons.person, color: Colors.grey[700]),
                    hintText: 'Tài khoản...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: _isObscure,
                  style: TextStyle(color: Colors.black87),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    prefixIcon: Icon(Icons.lock, color: Colors.grey[700]),
                    hintText: 'Mật khẩu...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text(
                    'ĐĂNG NHẬP',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Chưa có tài khoản?",
                      style: TextStyle(color: Colors.grey[800]),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Đăng ký ngay',
                        style: TextStyle(color: Colors.blue[800]),
                      ),
                    ),
                  ],
                ),

                TextButton(
                  onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Quên mật khẩu',
                        style: TextStyle(color: Colors.blue[800]),
                      ),
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
}
=======
}
>>>>>>> main
