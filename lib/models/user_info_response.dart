class UserInfoResponse {
  final int maNguoiDung;
  final String tenDangNhap;
  final String email;
  final String soDienThoai;
  final String? anhDaiDien;
  final String ngayTao;
  UserInfoResponse({
    required this.maNguoiDung,
    required this.tenDangNhap,
    required this.email,
    required this.soDienThoai,
    required this.anhDaiDien,
    required this.ngayTao,
  });

  factory UserInfoResponse.fromJson(Map<String, dynamic> json) {
    return UserInfoResponse(
      maNguoiDung: json['maNguoiDung'],
      tenDangNhap: json['tenDangNhap'],
      email: json['email'],
      soDienThoai: json['soDienThoai'],
      anhDaiDien: json['anhDaiDien'],
      ngayTao: json['ngayTao'],
    );
  }
}
