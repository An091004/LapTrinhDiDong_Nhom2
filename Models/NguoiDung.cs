using System.ComponentModel.DataAnnotations;

namespace api_expenes_flutter.Models
{
    public class NguoiDung
    {
        [Key]
        public int MaNguoiDung { get; set; }
        [Required(ErrorMessage = "TenDangNhap là bắt buộc")]
        public required string TenDangNhap { get; set; }

        [Required(ErrorMessage = "Email là bắt buộc")]
        [EmailAddress(ErrorMessage = "Email không hợp lệ")]
        public required string email { get; set; }

        [Required(ErrorMessage = "Số điện thoại là bắt buộc")]
        [RegularExpression(@"^(0|\+84)(\d{9})$", ErrorMessage = "Số điện thoại không hợp lệ (phải bắt đầu bằng 0 hoặc +84 và có 10 chữ số)")]
        public required string SoDienThoai { get; set; }

        [Required(ErrorMessage = "Mật khẩu là bắt buộc")]
        [RegularExpression(@"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{6,}$", ErrorMessage = "Mật khẩu phải ít nhất 6 ký tự, gồm chữ hoa, chữ thường và số")]
        public required string MatKhau { get; set; }
        public string? AnhDaiDien { get; set; }
    }
    public class OtpCodes
    {
        [Key]
        public int Id { get; set; }
        [Required]
        [EmailAddress]
        public string Email { get; set; }
        public string OtpCode { get; set; }
        public DateTime ExpiredAt { get; set; }
    }
    public class OtpVerifyDto
    {
        [Required]
        [EmailAddress]
        public string Email { get; set; }
        public string OtpCode { get; set; }
    }

    public class ResetPasswordDto
    {
        [Required]
        [EmailAddress]
        public string Email { get; set; }
        [Required]
        public string OtpCode { get; set; }
        [Required(ErrorMessage = "Mật khẩu là bắt buộc")]
        [RegularExpression(@"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{6,}$", ErrorMessage = "Mật khẩu phải ít nhất 6 ký tự, gồm chữ hoa, chữ thường và số")]
        public string NewPassword { get; set; }
    }
}
