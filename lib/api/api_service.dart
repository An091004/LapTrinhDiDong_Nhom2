import 'dart:convert';
import 'package:flutter_qlchitieu/models/update_user_request.dart';
import 'package:flutter_qlchitieu/models/user_info_response.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_qlchitieu/models/user_model.dart';

class ApiService {
  static const String baseUrl =
      'http://192.168.1.111:5031'; //Không phải cổng local host nữa mà là địa chỉ ipv4
  //dotnet run --urls "http://0.0.0.0:5031" chạy bên api để chldấp nhận mọi kết nối
  static const String loginEndpoint = '/api/Auth/login';
  static const String registerEndpoint = '/api/Auth/register';
  static const String forgotPasswordEndpoint = '/api/Auth/forgot-password';
  static const String verifyOtpEndpoint = '/api/Auth/verify-otp';
  static const String resetPasswordEndpoint = '/api/Auth/reset-password';
  static const String getUserEndpoint = '/api/NguoiDungs/me';
  static const String updateUserEndpoint = '/api/NguoiDungs/update';
  Future<LoginResponse> login(LoginRequest request) async {
    final url = Uri.parse('$baseUrl$loginEndpoint');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      print('Response: ${response.statusCode} - ${response.body}'); // Debug

      if (response.statusCode == 200) {
        return LoginResponse.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        return LoginResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          'Failed to login: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<RegisterResponse> register(RegisterRequest request) async {
    final url = Uri.parse('$baseUrl$registerEndpoint');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      print('API Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        return RegisterResponse.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 400) {
        return RegisterResponse.fromError(response.body);
      } else {
        throw Exception(
          'Failed to register: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<ForgotPasswordResponse> forgotPassword(
    ForgotPasswordRequest request,
  ) async {
    final url = Uri.parse('$baseUrl$forgotPasswordEndpoint');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      print('API Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        return ForgotPasswordResponse.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        return ForgotPasswordResponse.fromError(response.body);
      } else if (response.statusCode == 500) {
        return ForgotPasswordResponse.fromError(response.body);
      } else {
        throw Exception(
          'Failed to forgot password: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<ForgotPasswordResponse> verifyOtp(VerifyOtpRequest request) async {
    final url = Uri.parse('$baseUrl$verifyOtpEndpoint');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      print('API Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        return ForgotPasswordResponse.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 400) {
        return ForgotPasswordResponse.fromError(response.body);
      } else {
        throw Exception(
          'Failed to verify OTP: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<ForgotPasswordResponse> resetPassword(
    ResetPasswordRequest request,
  ) async {
    final url = Uri.parse('$baseUrl$resetPasswordEndpoint');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      print('API Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        return ForgotPasswordResponse.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 400) {
        return ForgotPasswordResponse.fromError(response.body);
      } else if (response.statusCode == 404) {
        return ForgotPasswordResponse.fromError(response.body);
      } else {
        throw Exception(
          'Failed to reset password: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<UserInfoResponse> getCurrenUser(String token) async {
    final url = Uri.parse('$baseUrl$getUserEndpoint');
    try {
      final reponse = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (reponse.statusCode == 200) {
        return UserInfoResponse.fromJson(jsonDecode(reponse.body));
      } else {
        throw Exception('take info user failed:${reponse.statusCode}');
      }
    } catch (e) {
      throw Exception('Error:$e');
    }
  }

  Future<UpdateUserReponse> updateUserInfo(
    UpdateUserRequest request,
    String token,
  ) async {
    final url = Uri.parse('$baseUrl$updateUserEndpoint');
    try {
      final reponse = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(request.toJson()),
      );
      final data = jsonDecode(reponse.body);
      if (reponse.statusCode == 200) {
        return UpdateUserReponse.fromJson({...data, 'success': true});
      } else {
        return UpdateUserReponse.fromJson({...data, 'success': false});
      }
    } catch (e) {
      throw Exception('Error:$e');
    }
  }
}
