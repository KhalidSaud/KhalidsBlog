using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using KhalidsBlog.Model;
using System.Net.Http;
using System.Net;

namespace KhalidsBlog.Controllers
{
	[Route("api/[controller]")]
	[ApiController]
	public class AuthController : ControllerBase
	{
		private readonly ApplicationDbContext _context;

		public AuthController(ApplicationDbContext context)
		{
			_context = context;
		}

		[HttpGet]
		public IEnumerable<User> GetLogin()
		{
			return _context.Users;
		}

		//[Route("login")]
		[HttpPost]
		public async Task<IActionResult> PostLogin(User user)
		{
			var userFromRepo = await Login(user.Email.ToLower(), user.Password);

			if (userFromRepo == null)
			{
				return StatusCode(StatusCodes.Status401Unauthorized, "Wrong email or password!");
			}



			return Ok(userFromRepo);
		}


		public async Task<User> Login(string email, string password)
		{
			var user = await _context.Users.FirstOrDefaultAsync(c => c.Email == email);

			if (user == null)
				return null;

			if (user.Password != password)
				return null;

			return user;
		}


		private bool UserExists(int id)
		{
			return _context.Users.Any(e => e.Id == id);
		}
	}
}