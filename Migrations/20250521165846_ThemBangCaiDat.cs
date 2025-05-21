using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace api_expenes_flutter.Migrations
{
    /// <inheritdoc />
    public partial class ThemBangCaiDat : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropPrimaryKey(
                name: "PK_Users",
                table: "Users");

            migrationBuilder.RenameTable(
                name: "Users",
                newName: "NguoiDung");

            migrationBuilder.RenameColumn(
                name: "Email",
                table: "NguoiDung",
                newName: "email");

            migrationBuilder.AlterColumn<string>(
                name: "AnhDaiDien",
                table: "NguoiDung",
                type: "nvarchar(max)",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "nvarchar(max)");

            migrationBuilder.AddPrimaryKey(
                name: "PK_NguoiDung",
                table: "NguoiDung",
                column: "MaNguoiDung");

            migrationBuilder.CreateTable(
                name: "CaiDat",
                columns: table => new
                {
                    MaCaiDat = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    MaNguoiDung = table.Column<int>(type: "int", nullable: false),
                    CheDoToi = table.Column<bool>(type: "bit", nullable: false),
                    ThongBao = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_CaiDat", x => x.MaCaiDat);
                });

            migrationBuilder.CreateTable(
                name: "OtpCodes",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Email = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    OtpCode = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    ExpiredAt = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_OtpCodes", x => x.Id);
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "CaiDat");

            migrationBuilder.DropTable(
                name: "OtpCodes");

            migrationBuilder.DropPrimaryKey(
                name: "PK_NguoiDung",
                table: "NguoiDung");

            migrationBuilder.RenameTable(
                name: "NguoiDung",
                newName: "Users");

            migrationBuilder.RenameColumn(
                name: "email",
                table: "Users",
                newName: "Email");

            migrationBuilder.AlterColumn<string>(
                name: "AnhDaiDien",
                table: "Users",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "",
                oldClrType: typeof(string),
                oldType: "nvarchar(max)",
                oldNullable: true);

            migrationBuilder.AddPrimaryKey(
                name: "PK_Users",
                table: "Users",
                column: "MaNguoiDung");
        }
    }
}
