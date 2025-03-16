import 'package:flutter/material.dart';
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomScreen(),),);
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
          ),
        ),
      ),
    );
  }
}