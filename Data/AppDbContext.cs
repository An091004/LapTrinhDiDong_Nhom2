using api_expenes_flutter.Models;
using Microsoft.EntityFrameworkCore;
namespace api_expenes_flutter.Data
{
    public class AppDbContext:DbContext
    {
        public AppDbContext(DbContextOptions options) : base(options) { }
        public DbSet<NguoiDung> NguoiDung { get; set; }
        public DbSet<OtpCodes> OtpCodes { get; set; }
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);
        }
    }
}
