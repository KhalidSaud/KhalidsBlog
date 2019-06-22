using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using KhalidsBlog.Model;

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
		public IEnumerable<User> GetUsers()
		{
			return _context.Users;
		}

		[HttpPost("login")]
		public async Task<IActionResult> Login(User user)
		{
			var userFromRepo = await Login(user.Email.ToLower(), user.Password);

			if (userFromRepo == null)
				return Unauthorized();


			return Ok();
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