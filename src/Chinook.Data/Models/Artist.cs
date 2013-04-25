using System.Collections.Generic;

namespace Chinook.Data.Models
{
    public class Artist
    {
        public Artist()
        {
            Albums = new List<Album>();
        }

        public int ArtistId { get; set; }
        public string Name { get; set; }
        public virtual ICollection<Album> Albums { get; set; }
    }
}