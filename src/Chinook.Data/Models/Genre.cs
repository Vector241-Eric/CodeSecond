using System;
using System.Collections.Generic;

namespace Chinook.Data.Models
{
    public partial class Genre
    {
        public Genre()
        {
            this.Tracks = new List<Track>();
        }

        public int GenreId { get; set; }
        public string Name { get; set; }
        public virtual ICollection<Track> Tracks { get; set; }
    }
}
