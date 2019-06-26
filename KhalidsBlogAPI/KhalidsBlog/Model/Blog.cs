using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.Collections.ObjectModel;

namespace KhalidsBlog.Model
{
	public class Blog
	{
		[Key]
		public int Id { get; set; }

		[Required]
		[Display(Name = "Blog's Title")]
		public string Title { get; set; }

		public string ImageName { get; set; }

		public string Content { get; set; }

	}
}
