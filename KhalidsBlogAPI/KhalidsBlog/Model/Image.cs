using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace KhalidsBlog.Model
{
	public class Image
	{
		public int Id { get; set; }

		[Required]
		[StringLength(255)]
		public string FileName { get; set; }
	}
}
