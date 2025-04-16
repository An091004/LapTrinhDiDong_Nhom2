using api_expenes_flutter.Data;
using api_expenes_flutter.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.VisualStudio.Web.CodeGenerators.Mvc.Templates.BlazorIdentity.Pages.Manage;
using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Identity;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using System.Net.Mail;
using System.Net;
namespace api_expenes_flutter.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly AppDbContext _context;
        private readonly IConfiguration _configuration;
        public AuthController(AppDbContext context, IConfiguration configuration)
        {
            _context = context;
            _configuration = configuration;
        }
        [HttpPost("register")]
        public async Task<IActionResult> Register([FromBody] NguoiDung request)
        {
            // kiểm tra email và tên đăng nhập đã tồn tại
            if (await _context.NguoiDung.AnyAsync(u => u.email == request.email))
            {
                return BadRequest("Email đã tồn tại");
            }

            if (await _context.NguoiDung.AnyAsync(t => t.TenDangNhap == request.TenDangNhap))
            {
                return BadRequest("Tên đăng nhập đã tồn tại");
            }

            var user = new NguoiDung
            {
                TenDangNhap = request.TenDangNhap,
                email = request.email,
                SoDienThoai = request.SoDienThoai,
                MatKhau = request.MatKhau,
                AnhDaiDien = request.AnhDaiDien ?? "",
            };

            // Hash mật khẩu và gán vào user
            var hasher = new PasswordHasher<NguoiDung>();
            user.MatKhau = hasher.HashPassword(user, request.MatKhau);

            _context.NguoiDung.Add(user);
            await _context.SaveChangesAsync();

            return Ok(new { message = "Đăng ký thành công" });
        }
        [HttpPost("login")]
        public async Task<IActionResult> login([FromBody] LoginRequest request)
        {
            
            var user = await _context.NguoiDung.FirstOrDefaultAsync(u => u.email == request.email);
            if (user == null )
            {
                return Unauthorized(new { message = "Email không đúng" });
            }
            var hasher=new PasswordHasher<NguoiDung>();
            var result=hasher.VerifyHashedPassword(user,user.MatKhau,request.MatKhau);
            if (result == PasswordVerificationResult.Failed)
            {
                return Unauthorized(new { message = "Mật khẩu không đúng" });
            }
            var token = GenerateJwtToken(user);
            return Ok(new {Token=token});
        }


        [HttpPost("forgot-password")]
        public async Task<IActionResult> ForgotPassword([FromBody] ForgotPasswordDto request)
        {
            var user = await _context.NguoiDung.FirstOrDefaultAsync(u => u.email == request.Email);
            if (user == null) return NotFound("Email không tồn tại");

            var otp = new Random().Next(100000, 999999).ToString();
            _context.OtpCodes.Add(new OtpCodes
            {
                Email = request.Email,
                OtpCode = otp,
                ExpiredAt = DateTime.Now.AddMinutes(5)
            });
            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateException ex)
            {
                return BadRequest(ex.InnerException?.Message ?? ex.Message);
            }
            try
            {
                // Gửi email thật
                using var client = new SmtpClient("smtp.gmail.com", 587)
                {
                    Credentials = new NetworkCredential("vonhut123a@gmail.com", "svsufvjmyslvqjxp"),
                    EnableSsl = true
                };
                await client.SendMailAsync(new MailMessage(
                    from: "vonhut123a@gmail.com",
                    to: request.Email,
                    subject: "Mã OTP khôi phục mật khẩu",
                    body: $"Mã OTP của bạn là: {otp}"
                ));
            }
            catch (SmtpException ex)
            {
                return StatusCode(500, "Lỗi gửi email: " + ex.Message + "\n" + ex.StackTrace);
            }


            return Ok(new { message = "Đã gửi OTP về email" });
        }
        [HttpPost("verify-otp")]
        public async Task<IActionResult> VerifyOtp([FromBody] OtpVerifyDto request)
        {
            var otp = await _context.OtpCodes
                .Where(o => o.Email == request.Email && o.OtpCode == request.OtpCode)
                .OrderByDescending(o => o.ExpiredAt)
                .FirstOrDefaultAsync();

            if (otp == null || otp.ExpiredAt < DateTime.Now)
                return BadRequest("OTP không hợp lệ hoặc đã hết hạn");

            return Ok(new { message = "OTP hợp lệ" });
        }
        [HttpPost("reset-password")]
        public async Task<IActionResult> ResetPassword([FromBody] ResetPasswordDto request)
        {
            var otp = await _context.OtpCodes
                .Where(o => o.Email == request.Email && o.OtpCode == request.OtpCode)
                .OrderByDescending(o => o.ExpiredAt)
                .FirstOrDefaultAsync();

            if (otp == null || otp.ExpiredAt < DateTime.Now)
                return BadRequest("OTP không hợp lệ hoặc đã hết hạn");

            var user = await _context.NguoiDung.FirstOrDefaultAsync(u => u.email == request.Email);
            if (user == null) return NotFound("Người dùng không tồn tại");

            var hasher = new PasswordHasher<NguoiDung>();
            user.MatKhau = hasher.HashPassword(user, request.NewPassword);
            await _context.SaveChangesAsync();

            return Ok(new { message = "Đặt lại mật khẩu thành công" });
        }

        private string GenerateJwtToken(NguoiDung user)
        {
            var jwtKey = _configuration["Jwt:Key"];
            if (string.IsNullOrEmpty(jwtKey))
            {
                throw new InvalidOperationException("JWT Key is not configured.");
            }
            var claims = new[]
            {
                new Claim(ClaimTypes.NameIdentifier, user.TenDangNhap),

                new Claim(ClaimTypes.Email, user.email),


            };

            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_configuration["Jwt:Key"]));
            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

            var token = new JwtSecurityToken(
                issuer: _configuration["Jwt:Issuer"],
                audience: _configuration["Jwt:Audience"],
                claims: claims,
                expires: DateTime.Now.AddHours(1),
                signingCredentials: creds);

            return new JwtSecurityTokenHandler().WriteToken(token);
        }
        public class LoginRequest()
        {
            [Required(ErrorMessage = "Email là bắt buộc")]
            [EmailAddress(ErrorMessage = "Email không hợp lệ")]
            public required string email { get; set; }

            

            [Required(ErrorMessage = "Mật khẩu là bắt buộc")]
            [RegularExpression(@"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{6,}$", ErrorMessage = "Mật khẩu phải ít nhất 6 ký tự, gồm chữ hoa, chữ thường và số")]
            public required string MatKhau { get; set; }
        }
        public class ForgotPasswordDto
        {
            public required string Email { get; set; }
        }
    }
}
