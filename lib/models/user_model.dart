//# 👤 Thông tin người dùng (id, tên, email, số điện thoại)

class LoginRequest {
  final String email;
  final String matKhau;

  LoginRequest({required this.email, required this.matKhau});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'MatKhau': matKhau, // Khớp với tên trường trong API
    };
  }
}

class LoginResponse {
  final String? token;
  final String? message;

  LoginResponse({this.token, this.message});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(token: json['token'], message: json['message']);
  }
}

class RegisterRequest {
  final String tenDangNhap;
  final String email;
  final String soDienThoai;
  final String matKhau;
  final String? anhDaiDien;

  RegisterRequest({
    required this.tenDangNhap,
    required this.email,
    required this.soDienThoai,
    required this.matKhau,
    this.anhDaiDien,
  });

  Map<String, dynamic> toJson() {
    return {
      'TenDangNhap': tenDangNhap,
      'email': email,
      'SoDienThoai': soDienThoai,
      'MatKhau': matKhau,
      'AnhDaiDien': anhDaiDien ?? "",
    };
  }
}

class RegisterResponse {
  final String? message;

  RegisterResponse({this.message});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(message: json['message']);
  }

  factory RegisterResponse.fromError(String error) {
    return RegisterResponse(message: error);
  }
}

class ForgotPasswordRequest {
  final String email;

  ForgotPasswordRequest({required this.email});

  Map<String, dynamic> toJson() {
    return {'email': email};
  }
}

class VerifyOtpRequest {
  final String email;
  final String otpCode;

  VerifyOtpRequest({required this.email, required this.otpCode});

  Map<String, dynamic> toJson() {
    return {'Email': email, 'OtpCode': otpCode};
  }
}

class ResetPasswordRequest {
  final String email;
  final String otpCode;
  final String newPassword;

  ResetPasswordRequest({
    required this.email,
    required this.otpCode,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {'Email': email, 'OtpCode': otpCode, 'NewPassword': newPassword};
  }
}

class ForgotPasswordResponse {
  final String? message;

  ForgotPasswordResponse({this.message});

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponse(message: json['message']);
  }

  factory ForgotPasswordResponse.fromError(String error) {
    return ForgotPasswordResponse(message: error);
  }
}
