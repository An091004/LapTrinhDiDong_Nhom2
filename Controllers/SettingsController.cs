using api_expenes_flutter.Data;
using api_expenes_flutter.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.DotNet.Scaffolding.Shared.Messaging;
using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Writers;
using System.Net.WebSockets;
using System.Security.Claims;

namespace api_expenes_flutter.Controllers
{
    [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class SettingsController : ControllerBase
    {
        private readonly AppDbContext _context;

        public SettingsController(AppDbContext context)
        {
            _context = context;
        }
       [HttpGet]
       public async Task<IActionResult> getSettings()
        {
            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier);
            if (userIdClaim == null) { return Unauthorized(new {Message="not found user"}); }
            var userId = int.Parse(userIdClaim.Value);
            var settings = await _context.CaiDat.FirstOrDefaultAsync(s => s.MaNguoiDung == userId);
            if (settings == null)
            { return NotFound(new { Message = "setting not found for user" }); }
            return Ok(settings);
        }
        [HttpPut("update")]
        public async Task<IActionResult> updateSettings([FromBody] updateSettingRequest request)
        {
            var userIdClaim=User.FindFirst(ClaimTypes.NameIdentifier);
            if (userIdClaim == null) { return Unauthorized(new { Message = "not found user" }); }
            var userId=int.Parse(userIdClaim.Value);
            var settings = await _context.CaiDat.FirstOrDefaultAsync(s => s.MaNguoiDung == userId);
            if (settings == null)
            { return NotFound(new { Message = "setting not found for user" }); }
            settings.CheDoToi = request.CheDoToi ?? settings.CheDoToi;
            settings.ThongBao=request.ThongBao ?? settings.ThongBao;
            await _context.SaveChangesAsync();
            return Ok(new { Message = "Update setting sucessfull" });

        }
    }
}
