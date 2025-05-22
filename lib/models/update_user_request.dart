class UpdateUserRequest {
  final String? tenDangNhap;
  final String? email;
  final String? soDienThoai;
  UpdateUserRequest({this.tenDangNhap, this.email, this.soDienThoai});
  Map<String, dynamic> toJson() {
    return {
      'TenDangNhap': tenDangNhap,
      'email': email,
      'SoDienThoai': soDienThoai,
    };
  }
}

class UpdateUserReponse {
  final bool success;
  final String? message;
  UpdateUserReponse({required this.success, this.message});
  factory UpdateUserReponse.fromJson(Map<String, dynamic> json) {
    return UpdateUserReponse(
      success: json['success'] ?? true,
      message: json['message'],
    );
  }
}
