using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using KhalidsBlog.Model;
using System.IO;
using Microsoft.AspNetCore.Hosting;

namespace KhalidsBlog.Controllers
{
	[Route("api/[controller]")]
	[ApiController]
	public class BlogsController : ControllerBase
	{
		private readonly ApplicationDbContext _context;
		private readonly IHostingEnvironment host;

		public BlogsController(ApplicationDbContext context, IHostingEnvironment host)
		{
			_context = context;
			this.host = host;
		}

		// GET: api/Blogs
		[HttpGet]
		public IEnumerable<Blog> GetBlog()
		{
			return _context.Blog;
		}

		// GET: api/Blogs/5
		[HttpGet("{id}")]
		public async Task<IActionResult> GetBlog([FromRoute] int id)
		{
			if (!ModelState.IsValid)
			{
				return BadRequest(ModelState);
			}

			var blog = await _context.Blog.FindAsync(id);

			if (blog == null)
			{
				return NotFound();
			}


			return Ok(blog);
		}

		// PUT: api/Blogs/5
		[HttpPut("{id:int}")]
		public async Task<IActionResult> PutBlog([FromRoute] int id, [FromBody] Blog blog)
		{
			if (!ModelState.IsValid)
			{
				return BadRequest(ModelState);
			}

			if (id != blog.Id)
			{
				return BadRequest("Unauthrized access!");
			}

			_context.Entry(blog).State = EntityState.Modified;

			try
			{
				await _context.SaveChangesAsync();
			}
			catch (DbUpdateConcurrencyException)
			{
				if (!BlogExists(id))
				{
					return NotFound();
				}
				else
				{
					throw;
				}
			}

			return NoContent();
		}

		// POST: api/Blogs
		[HttpPost]
		public async Task<IActionResult> PostBlog([FromBody] Blog blog)
		{
			if (!ModelState.IsValid)
			{
				return BadRequest(ModelState);
			}

			_context.Blog.Add(blog);
			await _context.SaveChangesAsync();

			return CreatedAtAction("GetBlog", new { id = blog.Id }, blog);
		}

		// DELETE: api/Blogs/5
		[HttpDelete("{id}")]
		public async Task<IActionResult> DeleteBlog([FromRoute] int id)
		{
			if (!ModelState.IsValid)
			{
				return BadRequest(ModelState);
			}

			var blog = await _context.Blog.FindAsync(id);
			if (blog == null)
			{
				return NotFound();
			}

			if (blog.ImageName != null)
			{
				DeleteImage(blog.ImageName);
			}

			_context.Blog.Remove(blog);
			await _context.SaveChangesAsync();

			return Ok(blog);
		}

		private bool BlogExists(int id)
		{
			return _context.Blog.Any(e => e.Id == id);
		}

		public void DeleteImage(string FileName)
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