using System.Collections.Generic;

namespace Chinook.Data.Models
{
    public class MediaType
    {
        public MediaType()
        {
            Tracks = new List<Track>();
        }

        public int MediaTypeId { get; set; }
        public string Name { get; set; }
        public virtual ICollection<Track> Tracks { get; set; }
    }
}