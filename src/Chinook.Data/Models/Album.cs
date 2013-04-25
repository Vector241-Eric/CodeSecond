using System.Collections.Generic;

namespace Chinook.Data.Models
{
    public class Album
    {
        public Album()
        {
            Tracks = new List<Track>();
        }

        public int AlbumId { get; set; }
        public string Title { get; set; }
        public int ArtistId { get; set; }
        public virtual Artist Artist { get; set; }
        public virtual ICollection<Track> Tracks { get; set; }
    }
}