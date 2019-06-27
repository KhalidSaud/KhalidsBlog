using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Reflection;
using System.Threading.Tasks;
using KhalidsBlog.Model;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace KhalidsBlog.Controllers
{
	
	[ApiController]
	public class ImagesController : ControllerBase
	{
		private readonly string[] ACCEPTED_FILE_TYPES = new[] { ".jpg", ".jpeg", ".png" };

		private readonly IHostingEnvironment host;
		private readonly ApplicationDbContext _context;


		public ImagesController(IHostingEnvironment host, ApplicationDbContext context)
		{
			this.host = host;
			_context = context;
		}

		[HttpPost]
		[Route("api/blogId/{Id}/addImage")]
		public async Task<IActionResult> Upload(int Id, IFormFile file)
		{

			var uploadsFolderPath = Path.Combine(host.WebRootPath, "images"); // c:\wwwroot\

			if (!Directory.Exists(uploadsFolderPath))
			{
				Directory.CreateDirectory(uploadsFolderPath);
			}

			if (file == null) return BadRequest("Null file");
			if (file.Length == 0) return BadRequest("Empty file");
			if (file.Length > 10 * 1024 * 1024) return BadRequest("Max file size 10mb exceeded");
			if (!ACCEPTED_FILE_TYPES.Any(s => s == Path.GetExtension(file.FileName))) return BadRequest("Invalid file type");

			try
			{
				var fileName = Guid.NewGuid().ToString() + Path.GetExtension(file.FileName);
				var filePath = Path.Combine(uploadsFolderPath, fileName);

				using (var stream = new FileStream(filePath, FileMode.Create))
				{
					await file.CopyToAsync(stream);
				}

				//var image = new Image { FileName = fileName };
				var blog = await _context.Blog.SingleOrDefaultAsync(b => b.Id == Id);

				if(blog == null)
				{
					return BadRequest("Failed to find blog record");
				}

				var imageName = blog.ImageName;

				if (imageName != "")
				{
					DeletePreviousImage(imageName);
				}

				blog.ImageName = fileName;
				await _context.SaveChangesAsync();

				return Ok();
			}
			catch (Exception)
			{

				return BadRequest();
			}
			
		}


		[HttpGet()]
		[Route("api/image/{FileName}")]
		public async Task<IActionResult> GetImage(string FileName)
		{

			var uploadsFolderPath = Path.Combine(host.WebRootPath, "images");
			//var imageName = "da0cd247-1bfe-4ac8-b4bc-0f72e1311506.jpg";

			var imageName = FileName;
			string file = Path.Combine(uploadsFolderPath, imageName);
			if (file == null) return BadRequest("Null file");
			if (file.Length == 0) return BadRequest("Empty file");

			try
			{
				
				var memory = new MemoryStream();
				using (var stream = new FileStream(file, FileMode.Open))
				{
					await stream.CopyToAsync(memory);
				}

				memory.Position = 0;
				return File(memory, GetMimeType(file), imageName) ;
			}
			catch (Exception e)
			{
				return BadRequest(e.Message);
			}
		}

		private static string AssemblyDirectory
		{
			get
			{
				string codeBase = Assembly.GetExecutingAssembly().CodeBase;
				UriBuilder uri = new UriBuilder(codeBase);
				string path = Uri.UnescapeDataString(uri.Path);
				return Path.GetDirectoryName(path);
			}
		}

		private string GetMimeType(string file)
		{
			string extension = Path.GetExtension(file).ToLowerInvariant();
			switch (extension)
			{
				case ".txt": return "text/plain";
				case ".pdf": return "application/pdf";
				case ".doc": return "application/vnd.ms-word";
				case ".docx": return "application/vnd.ms-word";
				case ".xls": return "application/vnd.ms-excel";
				case ".png": return "image/png";
				case ".jpg": return "image/jpeg";
				case ".jpeg": return "image/jpeg";
				case ".gif": return "image/gif";
				case ".csv": return "text/csv";
				default: return "";
			}
		}


		private void DeletePreviousImage(string FileName)
		{

			var uploadsFolderPath = Path.Combine(host.WebRootPath, "images");
			//var imageName = "da0cd247-1bfe-4ac8-b4bc-0f72e1311506.jpg";

			var imageName = FileName;
			string file = Path.Combine(uploadsFolderPath, imageName);
			if (file == null) return;
			if (file.Length == 0) return;

			if (System.IO.File.Exists(file))
			{
				System.IO.File.Delete(file);
			}
		}

	}
}