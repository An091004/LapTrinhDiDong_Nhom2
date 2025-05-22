using api_expenes_flutter.Data;
using api_expenes_flutter.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;
namespace api_expenes_flutter.Controllers
{
    [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class NguoiDungsController : ControllerBase
    {
        private readonly AppDbContext _context;

        public NguoiDungsController(AppDbContext context)
        {
            _context = context;
        }
        [HttpGet("me")]
        public async Task<IActionResult> GetCurrenUser()
        {
            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
            if (userIdClaim == null)
            {
                return Unauthorized(new { Message = "không xác định được người dùng" });
            }
            var userId = int.Parse(userIdClaim.Value);
            var user = await _context.NguoiDung.Where(u => u.MaNguoiDung == userId).Select(u => new { u.MaNguoiDung, u.TenDangNhap, u.email, u.SoDienThoai, u.AnhDaiDien, u.NgayTao }).FirstOrDefaultAsync();
            if (user == null)
            {
                return NotFound(new { Message = "không tìm thấy người dùng" });
            }
            return Ok(user);
        }
        [HttpPut("update")]
        public async Task<IActionResult> updateInfoUser([FromBody] UpdateUserRequest request)
        {
            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
            if (userIdClaim == null)
            {
                return Unauthorized(new { Message = "không xác định được người dùng" });

            }
            var userId = int.Parse(userIdClaim.Value);
            var user = await _context.NguoiDung.FindAsync(userId);//tìm người dùng trong db
            if (user == null)
            {
                return NotFound(new { Message = "không tìm thấy người dùng" });
            }
            //cập nhật thông tin người dùng
            user.TenDangNhap = request.TenDangNhap ?? user.TenDangNhap;//dấu ?? có tác dụng nếu giá trị null thì giữ nguyên,nếu không null thì thay đổi
            user.email = request.email ?? user.email;
            user.SoDienThoai = request.SoDienThoai ?? user.SoDienThoai;
            await _context.SaveChangesAsync();
            return Ok(new { Message = "Cập nhật user thành công" });
        }

    }
}
