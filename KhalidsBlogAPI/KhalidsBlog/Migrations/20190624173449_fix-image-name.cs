using Microsoft.EntityFrameworkCore.Migrations;

namespace KhalidsBlog.Migrations
{
    public partial class fiximagename : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Images_Blog_BlogId",
                table: "Images");

            migrationBuilder.DropIndex(
                name: "IX_Images_BlogId",
                table: "Images");

            migrationBuilder.DropColumn(
                name: "BlogId",
                table: "Images");

            migrationBuilder.AddColumn<string>(
                name: "ImageName",
                table: "Blog",
                nullable: true);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "ImageName",
                table: "Blog");

            migrationBuilder.AddColumn<int>(
                name: "BlogId",
                table: "Images",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_Images_BlogId",
                table: "Images",
                column: "BlogId");

            migrationBuilder.AddForeignKey(
                name: "FK_Images_Blog_BlogId",
                table: "Images",
                column: "BlogId",
                principalTable: "Blog",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }
    }
}
